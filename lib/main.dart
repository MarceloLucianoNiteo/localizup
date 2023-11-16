import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'db.dart';

final database = DatabaseOperation();

//FOREGROUND TASK
void _initForeTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
        channelId: "localizup_foreground",
        channelName: "Localizup Foreground Service"),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 20000,
      autoRunOnBoot: true,
    ),
  );

  FlutterForegroundTask.startService(
    notificationTitle: 'Foreground Service is running',
    notificationText: 'Tap to return to the app',
    callback: startCallback,
  );
}

class PositionDataEntity {
  final int? id;
  LatLng position;
  final DateTime dateTime;
  final DateTime? syncedAt;

  PositionDataEntity({
    this.id,
    required this.position,
    required this.dateTime,
    this.syncedAt,
  });

  factory PositionDataEntity.fromEntity(PositionEntity entity) =>
      PositionDataEntity(
          position: LatLng(
              double.parse(entity.latitude), double.parse(entity.longitude)),
          dateTime: DateTime.parse(entity.date),
          id: entity.id,
          syncedAt: entity.syncedAt != null
              ? DateTime.parse(entity.syncedAt!)
              : null);

  factory PositionDataEntity.fromMap(Map<String, dynamic> map) =>
      PositionDataEntity(
          position: LatLng(map['latitude'], map['longitude']),
          dateTime: DateTime.parse(map['date']),
          id: map['id'],
          syncedAt: map['syncedAt']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'date': DateFormat('yyyyMMddTHHmmss').format(dateTime),
      'syncedAt': syncedAt != null
          ? DateFormat('yyyyMMddTHHmmss').format(syncedAt!)
          : null,
    };
  }
}

class ClientsEntity {
  LatLng position;
  final String name;

  ClientsEntity(this.position, this.name);
}

Future<bool> getLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission? permission;

  if (!serviceEnabled) {
    permission = await Geolocator.requestPermission();
  }

  return permission != null && permission == LocationPermission.always;
}

Future<PositionDataEntity> _getPosition() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return PositionDataEntity(
      position: LatLng(position.latitude, position.longitude),
      dateTime: DateTime.now());
}

Future<void> insertPosition() async {
  final data = await _getPosition();
  await database.insertPosition(data);
}

Future<void> insertConfig(int time) async {
  //await database.insertConfig(time);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getLocationPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ReceivePort? _port;
  int? index;
  final TextEditingController _controller = TextEditingController(text: "20");
  final TextEditingController _sendToDBController =
      TextEditingController(text: "60");
  final List<PositionDataEntity> positions = [];
  final streamController = StreamController<dynamic>.broadcast();
  PositionDataEntity? startPosition;
  StreamSubscription? subscription;

  final clients = [
    ClientsEntity(const LatLng(-19.8762674, -44.0134774), "Pague Menos"),
    ClientsEntity(const LatLng(-19.8776928, -44.0218306), "Hexa Farma"),
    ClientsEntity(const LatLng(-19.8776928, -44.0218306), "Drogaria Bontempo"),
    ClientsEntity(const LatLng(-19.8895981, -44.0143633), "Drogaria Araújo"),
    ClientsEntity(
        const LatLng(-19.8897192, -44.017024), "Drogaria Alípio de Melo"),
  ];

  @override
  void initState() {
    super.initState();
    _port = FlutterForegroundTask.receivePort;
    database.getAll();
    _port!.listen((message) {
      streamController.sink.add(message);
    });
  }

  Future<void> setListenToSinc(int time) async {
    if (subscription != null) {
      await subscription?.cancel();
      subscription = null;
    }

    subscription ??= streamController.stream.listen((dynamic data) async {
      if (data is Map<String, dynamic>) {
        final pos = PositionDataEntity.fromMap(data);
        final posDate =
            positions.where((element) => element.syncedAt != null).lastOrNull;
        if (posDate == null ||
            DateTime.now().difference(posDate.syncedAt!).inSeconds >= time) {
          await database.updateSyncedPosition();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Text("Tempo de coleta (s):"),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50,
                  height: 30,
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      FlutterForegroundTask.updateService(
                        notificationTitle: 'Foreground Service is running',
                        notificationText: 'Tap to return to the app',
                        callback: startCallback,
                        foregroundTaskOptions: ForegroundTaskOptions(
                          interval: int.parse(_controller.text) * 1000,
                          autoRunOnBoot: true,
                        ),
                      );
                    },
                    child: const Text("Atualizar"))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Tempo de sinc. (s):"),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50,
                  height: 30,
                  child: TextFormField(
                    controller: _sendToDBController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setListenToSinc(int.parse(_sendToDBController.text));
                    },
                    child: const Text("Atualizar"))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      _initForeTask();
                      setListenToSinc(int.parse(_sendToDBController.text));
                      database.getAllPosition().listen((event) {
                        positions.clear();
                        setState(() {
                          positions.addAll(event
                              .map((e) => PositionDataEntity.fromEntity(e))
                              .toList());
                          if (positions.isNotEmpty) {
                            startPosition = positions.first;
                          }
                        });
                      });
                    },
                    child: const Text("Iniciar")),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await database.deletePosition();
                      setState(() {
                        positions.clear();
                      });
                    },
                    child: const Text("Limpar")),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Image.network("https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyAd14lS11kSj0CEWbN8uR8AO39uR1ftGgs") ,
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  SendPort? _sendPort;

  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    log('customData: $customData');
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    //final pos = await _getPosition();
    await insertPosition();
    database.getAll();
    print("Collected");
    //_sendPort?.send();
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {}

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    log('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}
