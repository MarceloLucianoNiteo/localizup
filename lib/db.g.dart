// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $PositionEntitiesTable extends PositionEntities
    with TableInfo<$PositionEntitiesTable, PositionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionEntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<String> latitude = GeneratedColumn<String>(
      'latitude', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<String> longitude = GeneratedColumn<String>(
      'longitude', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<String> syncedAt = GeneratedColumn<String>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, latitude, longitude, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'position_entities';
  @override
  VerificationContext validateIntegrity(Insertable<PositionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PositionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PositionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}longitude'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $PositionEntitiesTable createAlias(String alias) {
    return $PositionEntitiesTable(attachedDatabase, alias);
  }
}

class PositionEntity extends DataClass implements Insertable<PositionEntity> {
  final int id;
  final String date;
  final String latitude;
  final String longitude;
  final String? syncedAt;
  const PositionEntity(
      {required this.id,
      required this.date,
      required this.latitude,
      required this.longitude,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['latitude'] = Variable<String>(latitude);
    map['longitude'] = Variable<String>(longitude);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<String>(syncedAt);
    }
    return map;
  }

  PositionEntitiesCompanion toCompanion(bool nullToAbsent) {
    return PositionEntitiesCompanion(
      id: Value(id),
      date: Value(date),
      latitude: Value(latitude),
      longitude: Value(longitude),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PositionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PositionEntity(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      latitude: serializer.fromJson<String>(json['latitude']),
      longitude: serializer.fromJson<String>(json['longitude']),
      syncedAt: serializer.fromJson<String?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'latitude': serializer.toJson<String>(latitude),
      'longitude': serializer.toJson<String>(longitude),
      'syncedAt': serializer.toJson<String?>(syncedAt),
    };
  }

  PositionEntity copyWith(
          {int? id,
          String? date,
          String? latitude,
          String? longitude,
          Value<String?> syncedAt = const Value.absent()}) =>
      PositionEntity(
        id: id ?? this.id,
        date: date ?? this.date,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  @override
  String toString() {
    return (StringBuffer('PositionEntity(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, latitude, longitude, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PositionEntity &&
          other.id == this.id &&
          other.date == this.date &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.syncedAt == this.syncedAt);
}

class PositionEntitiesCompanion extends UpdateCompanion<PositionEntity> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> latitude;
  final Value<String> longitude;
  final Value<String?> syncedAt;
  const PositionEntitiesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  PositionEntitiesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String latitude,
    required String longitude,
    this.syncedAt = const Value.absent(),
  })  : date = Value(date),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<PositionEntity> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? latitude,
    Expression<String>? longitude,
    Expression<String>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  PositionEntitiesCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<String>? latitude,
      Value<String>? longitude,
      Value<String?>? syncedAt}) {
    return PositionEntitiesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<String>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<String>(longitude.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<String>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionEntitiesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $PositionEntitiesTable positionEntities =
      $PositionEntitiesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [positionEntities];
}
