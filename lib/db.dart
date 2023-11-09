import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

part 'db.g.dart';

@DataClassName('PositionEntity')
class PositionEntities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get latitude => text()();
  TextColumn get longitude => text()();
  TextColumn get syncedAt => text().nullable()();
}

@DriftDatabase(tables: [PositionEntities])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

class DatabaseOperation {
  final database = AppDatabase();

  Stream<List<PositionEntity>> getAllPosition() {
    final data = database.select(database.positionEntities).watch();

    return data;
  }

  Future<void> insertPosition(PositionDataEntity data) async {
    try {
      await database
          .into(database.positionEntities)
          .insert(PositionEntitiesCompanion(
        date: Value(data.dateTime.toIso8601String()),
        latitude: Value(data.position.latitude.toString()),
        longitude: Value(data.position.longitude.toString()),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePosition() async {
    await database.delete(database.positionEntities).go();
  }

  Future<void> updateSyncedPosition() async {
    await (database.update(database.positionEntities)
      ..where((tbl) => tbl.syncedAt.isNull())).write(PositionEntitiesCompanion(
      syncedAt: Value(DateFormat('yyyyMMddTHHmmss').format(DateTime.now()))
    ));
  }

  Future<void> updatePosition(PositionDataEntity positionEntity) async {
    await (database.update(database.positionEntities)
      ..where((tbl) => tbl.id.equals(positionEntity.id!))).write(PositionEntitiesCompanion(
      id: Value(positionEntity.id!),
      date: Value(DateFormat('yyyyMMddTHHmmss').format(positionEntity.dateTime)),
      latitude: Value(positionEntity.position.latitude.toString()),
      longitude: Value(positionEntity.position.longitude.toString()),
      syncedAt: const Value(null)
    ));
  }
}
