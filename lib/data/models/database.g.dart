// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _collectionNameMeta = const VerificationMeta(
    'collectionName',
  );
  @override
  late final GeneratedColumn<String> collectionName = GeneratedColumn<String>(
    'collection_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OperationType, int>
  operationType = GeneratedColumn<int>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<OperationType>($SyncQueueItemsTable.$converteroperationType);
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collectionName,
    documentId,
    operationType,
    payload,
    isSynced,
    createdAt,
    retryCount,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_name')) {
      context.handle(
        _collectionNameMeta,
        collectionName.isAcceptableOrUnknown(
          data['collection_name']!,
          _collectionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionNameMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_name'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      operationType: $SyncQueueItemsTable.$converteroperationType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}operation_type'],
        )!,
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OperationType, int, int> $converteroperationType =
      const EnumIndexConverter<OperationType>(OperationType.values);
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final int id;
  final String collectionName;
  final String documentId;
  final OperationType operationType;
  final String payload;
  final bool isSynced;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  const SyncQueueItem({
    required this.id,
    required this.collectionName,
    required this.documentId,
    required this.operationType,
    required this.payload,
    required this.isSynced,
    required this.createdAt,
    required this.retryCount,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_name'] = Variable<String>(collectionName);
    map['document_id'] = Variable<String>(documentId);
    {
      map['operation_type'] = Variable<int>(
        $SyncQueueItemsTable.$converteroperationType.toSql(operationType),
      );
    }
    map['payload'] = Variable<String>(payload);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      collectionName: Value(collectionName),
      documentId: Value(documentId),
      operationType: Value(operationType),
      payload: Value(payload),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<int>(json['id']),
      collectionName: serializer.fromJson<String>(json['collectionName']),
      documentId: serializer.fromJson<String>(json['documentId']),
      operationType: $SyncQueueItemsTable.$converteroperationType.fromJson(
        serializer.fromJson<int>(json['operationType']),
      ),
      payload: serializer.fromJson<String>(json['payload']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionName': serializer.toJson<String>(collectionName),
      'documentId': serializer.toJson<String>(documentId),
      'operationType': serializer.toJson<int>(
        $SyncQueueItemsTable.$converteroperationType.toJson(operationType),
      ),
      'payload': serializer.toJson<String>(payload),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncQueueItem copyWith({
    int? id,
    String? collectionName,
    String? documentId,
    OperationType? operationType,
    String? payload,
    bool? isSynced,
    DateTime? createdAt,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
  }) => SyncQueueItem(
    id: id ?? this.id,
    collectionName: collectionName ?? this.collectionName,
    documentId: documentId ?? this.documentId,
    operationType: operationType ?? this.operationType,
    payload: payload ?? this.payload,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      collectionName: data.collectionName.present
          ? data.collectionName.value
          : this.collectionName,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payload: data.payload.present ? data.payload.value : this.payload,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('collectionName: $collectionName, ')
          ..write('documentId: $documentId, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collectionName,
    documentId,
    operationType,
    payload,
    isSynced,
    createdAt,
    retryCount,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.collectionName == this.collectionName &&
          other.documentId == this.documentId &&
          other.operationType == this.operationType &&
          other.payload == this.payload &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<int> id;
  final Value<String> collectionName;
  final Value<String> documentId;
  final Value<OperationType> operationType;
  final Value<String> payload;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.collectionName = const Value.absent(),
    this.documentId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payload = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String collectionName,
    required String documentId,
    required OperationType operationType,
    required String payload,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : collectionName = Value(collectionName),
       documentId = Value(documentId),
       operationType = Value(operationType),
       payload = Value(payload);
  static Insertable<SyncQueueItem> custom({
    Expression<int>? id,
    Expression<String>? collectionName,
    Expression<String>? documentId,
    Expression<int>? operationType,
    Expression<String>? payload,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionName != null) 'collection_name': collectionName,
      if (documentId != null) 'document_id': documentId,
      if (operationType != null) 'operation_type': operationType,
      if (payload != null) 'payload': payload,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
    });
  }

  SyncQueueItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? collectionName,
    Value<String>? documentId,
    Value<OperationType>? operationType,
    Value<String>? payload,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<String?>? lastError,
  }) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      collectionName: collectionName ?? this.collectionName,
      documentId: documentId ?? this.documentId,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionName.present) {
      map['collection_name'] = Variable<String>(collectionName.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<int>(
        $SyncQueueItemsTable.$converteroperationType.toSql(operationType.value),
      );
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('collectionName: $collectionName, ')
          ..write('documentId: $documentId, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $DoctorsTable extends Doctors with TableInfo<$DoctorsTable, Doctor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specializationMeta = const VerificationMeta(
    'specialization',
  );
  @override
  late final GeneratedColumn<String> specialization = GeneratedColumn<String>(
    'specialization',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clinicAddressMeta = const VerificationMeta(
    'clinicAddress',
  );
  @override
  late final GeneratedColumn<String> clinicAddress = GeneratedColumn<String>(
    'clinic_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _territoryMeta = const VerificationMeta(
    'territory',
  );
  @override
  late final GeneratedColumn<String> territory = GeneratedColumn<String>(
    'territory',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('C'),
  );
  static const VerificationMeta _lastVisitDateMeta = const VerificationMeta(
    'lastVisitDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastVisitDate =
      GeneratedColumn<DateTime>(
        'last_visit_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _visitFrequencyMeta = const VerificationMeta(
    'visitFrequency',
  );
  @override
  late final GeneratedColumn<int> visitFrequency = GeneratedColumn<int>(
    'visit_frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _conversionProbabilityMeta =
      const VerificationMeta('conversionProbability');
  @override
  late final GeneratedColumn<double> conversionProbability =
      GeneratedColumn<double>(
        'conversion_probability',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    specialization,
    clinicAddress,
    phone,
    territory,
    classification,
    lastVisitDate,
    visitFrequency,
    conversionProbability,
    latitude,
    longitude,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Doctor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('specialization')) {
      context.handle(
        _specializationMeta,
        specialization.isAcceptableOrUnknown(
          data['specialization']!,
          _specializationMeta,
        ),
      );
    }
    if (data.containsKey('clinic_address')) {
      context.handle(
        _clinicAddressMeta,
        clinicAddress.isAcceptableOrUnknown(
          data['clinic_address']!,
          _clinicAddressMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('territory')) {
      context.handle(
        _territoryMeta,
        territory.isAcceptableOrUnknown(data['territory']!, _territoryMeta),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('last_visit_date')) {
      context.handle(
        _lastVisitDateMeta,
        lastVisitDate.isAcceptableOrUnknown(
          data['last_visit_date']!,
          _lastVisitDateMeta,
        ),
      );
    }
    if (data.containsKey('visit_frequency')) {
      context.handle(
        _visitFrequencyMeta,
        visitFrequency.isAcceptableOrUnknown(
          data['visit_frequency']!,
          _visitFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('conversion_probability')) {
      context.handle(
        _conversionProbabilityMeta,
        conversionProbability.isAcceptableOrUnknown(
          data['conversion_probability']!,
          _conversionProbabilityMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Doctor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Doctor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      specialization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialization'],
      )!,
      clinicAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clinic_address'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      territory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}territory'],
      )!,
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      lastVisitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_visit_date'],
      ),
      visitFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_frequency'],
      )!,
      conversionProbability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_probability'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
    );
  }

  @override
  $DoctorsTable createAlias(String alias) {
    return $DoctorsTable(attachedDatabase, alias);
  }
}

class Doctor extends DataClass implements Insertable<Doctor> {
  final String id;
  final String name;
  final String specialization;
  final String clinicAddress;
  final String phone;
  final String territory;
  final String classification;
  final DateTime? lastVisitDate;
  final int visitFrequency;
  final double conversionProbability;
  final double latitude;
  final double longitude;
  const Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.clinicAddress,
    required this.phone,
    required this.territory,
    required this.classification,
    this.lastVisitDate,
    required this.visitFrequency,
    required this.conversionProbability,
    required this.latitude,
    required this.longitude,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['specialization'] = Variable<String>(specialization);
    map['clinic_address'] = Variable<String>(clinicAddress);
    map['phone'] = Variable<String>(phone);
    map['territory'] = Variable<String>(territory);
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || lastVisitDate != null) {
      map['last_visit_date'] = Variable<DateTime>(lastVisitDate);
    }
    map['visit_frequency'] = Variable<int>(visitFrequency);
    map['conversion_probability'] = Variable<double>(conversionProbability);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    return map;
  }

  DoctorsCompanion toCompanion(bool nullToAbsent) {
    return DoctorsCompanion(
      id: Value(id),
      name: Value(name),
      specialization: Value(specialization),
      clinicAddress: Value(clinicAddress),
      phone: Value(phone),
      territory: Value(territory),
      classification: Value(classification),
      lastVisitDate: lastVisitDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisitDate),
      visitFrequency: Value(visitFrequency),
      conversionProbability: Value(conversionProbability),
      latitude: Value(latitude),
      longitude: Value(longitude),
    );
  }

  factory Doctor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Doctor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      specialization: serializer.fromJson<String>(json['specialization']),
      clinicAddress: serializer.fromJson<String>(json['clinicAddress']),
      phone: serializer.fromJson<String>(json['phone']),
      territory: serializer.fromJson<String>(json['territory']),
      classification: serializer.fromJson<String>(json['classification']),
      lastVisitDate: serializer.fromJson<DateTime?>(json['lastVisitDate']),
      visitFrequency: serializer.fromJson<int>(json['visitFrequency']),
      conversionProbability: serializer.fromJson<double>(
        json['conversionProbability'],
      ),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'specialization': serializer.toJson<String>(specialization),
      'clinicAddress': serializer.toJson<String>(clinicAddress),
      'phone': serializer.toJson<String>(phone),
      'territory': serializer.toJson<String>(territory),
      'classification': serializer.toJson<String>(classification),
      'lastVisitDate': serializer.toJson<DateTime?>(lastVisitDate),
      'visitFrequency': serializer.toJson<int>(visitFrequency),
      'conversionProbability': serializer.toJson<double>(conversionProbability),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? specialization,
    String? clinicAddress,
    String? phone,
    String? territory,
    String? classification,
    Value<DateTime?> lastVisitDate = const Value.absent(),
    int? visitFrequency,
    double? conversionProbability,
    double? latitude,
    double? longitude,
  }) => Doctor(
    id: id ?? this.id,
    name: name ?? this.name,
    specialization: specialization ?? this.specialization,
    clinicAddress: clinicAddress ?? this.clinicAddress,
    phone: phone ?? this.phone,
    territory: territory ?? this.territory,
    classification: classification ?? this.classification,
    lastVisitDate: lastVisitDate.present
        ? lastVisitDate.value
        : this.lastVisitDate,
    visitFrequency: visitFrequency ?? this.visitFrequency,
    conversionProbability: conversionProbability ?? this.conversionProbability,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );
  Doctor copyWithCompanion(DoctorsCompanion data) {
    return Doctor(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      specialization: data.specialization.present
          ? data.specialization.value
          : this.specialization,
      clinicAddress: data.clinicAddress.present
          ? data.clinicAddress.value
          : this.clinicAddress,
      phone: data.phone.present ? data.phone.value : this.phone,
      territory: data.territory.present ? data.territory.value : this.territory,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      lastVisitDate: data.lastVisitDate.present
          ? data.lastVisitDate.value
          : this.lastVisitDate,
      visitFrequency: data.visitFrequency.present
          ? data.visitFrequency.value
          : this.visitFrequency,
      conversionProbability: data.conversionProbability.present
          ? data.conversionProbability.value
          : this.conversionProbability,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Doctor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('specialization: $specialization, ')
          ..write('clinicAddress: $clinicAddress, ')
          ..write('phone: $phone, ')
          ..write('territory: $territory, ')
          ..write('classification: $classification, ')
          ..write('lastVisitDate: $lastVisitDate, ')
          ..write('visitFrequency: $visitFrequency, ')
          ..write('conversionProbability: $conversionProbability, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    specialization,
    clinicAddress,
    phone,
    territory,
    classification,
    lastVisitDate,
    visitFrequency,
    conversionProbability,
    latitude,
    longitude,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Doctor &&
          other.id == this.id &&
          other.name == this.name &&
          other.specialization == this.specialization &&
          other.clinicAddress == this.clinicAddress &&
          other.phone == this.phone &&
          other.territory == this.territory &&
          other.classification == this.classification &&
          other.lastVisitDate == this.lastVisitDate &&
          other.visitFrequency == this.visitFrequency &&
          other.conversionProbability == this.conversionProbability &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class DoctorsCompanion extends UpdateCompanion<Doctor> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> specialization;
  final Value<String> clinicAddress;
  final Value<String> phone;
  final Value<String> territory;
  final Value<String> classification;
  final Value<DateTime?> lastVisitDate;
  final Value<int> visitFrequency;
  final Value<double> conversionProbability;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int> rowid;
  const DoctorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.specialization = const Value.absent(),
    this.clinicAddress = const Value.absent(),
    this.phone = const Value.absent(),
    this.territory = const Value.absent(),
    this.classification = const Value.absent(),
    this.lastVisitDate = const Value.absent(),
    this.visitFrequency = const Value.absent(),
    this.conversionProbability = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoctorsCompanion.insert({
    required String id,
    required String name,
    this.specialization = const Value.absent(),
    this.clinicAddress = const Value.absent(),
    this.phone = const Value.absent(),
    this.territory = const Value.absent(),
    this.classification = const Value.absent(),
    this.lastVisitDate = const Value.absent(),
    this.visitFrequency = const Value.absent(),
    this.conversionProbability = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Doctor> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? specialization,
    Expression<String>? clinicAddress,
    Expression<String>? phone,
    Expression<String>? territory,
    Expression<String>? classification,
    Expression<DateTime>? lastVisitDate,
    Expression<int>? visitFrequency,
    Expression<double>? conversionProbability,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (specialization != null) 'specialization': specialization,
      if (clinicAddress != null) 'clinic_address': clinicAddress,
      if (phone != null) 'phone': phone,
      if (territory != null) 'territory': territory,
      if (classification != null) 'classification': classification,
      if (lastVisitDate != null) 'last_visit_date': lastVisitDate,
      if (visitFrequency != null) 'visit_frequency': visitFrequency,
      if (conversionProbability != null)
        'conversion_probability': conversionProbability,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoctorsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? specialization,
    Value<String>? clinicAddress,
    Value<String>? phone,
    Value<String>? territory,
    Value<String>? classification,
    Value<DateTime?>? lastVisitDate,
    Value<int>? visitFrequency,
    Value<double>? conversionProbability,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<int>? rowid,
  }) {
    return DoctorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      phone: phone ?? this.phone,
      territory: territory ?? this.territory,
      classification: classification ?? this.classification,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      visitFrequency: visitFrequency ?? this.visitFrequency,
      conversionProbability:
          conversionProbability ?? this.conversionProbability,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (specialization.present) {
      map['specialization'] = Variable<String>(specialization.value);
    }
    if (clinicAddress.present) {
      map['clinic_address'] = Variable<String>(clinicAddress.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (territory.present) {
      map['territory'] = Variable<String>(territory.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (lastVisitDate.present) {
      map['last_visit_date'] = Variable<DateTime>(lastVisitDate.value);
    }
    if (visitFrequency.present) {
      map['visit_frequency'] = Variable<int>(visitFrequency.value);
    }
    if (conversionProbability.present) {
      map['conversion_probability'] = Variable<double>(
        conversionProbability.value,
      );
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoctorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('specialization: $specialization, ')
          ..write('clinicAddress: $clinicAddress, ')
          ..write('phone: $phone, ')
          ..write('territory: $territory, ')
          ..write('classification: $classification, ')
          ..write('lastVisitDate: $lastVisitDate, ')
          ..write('visitFrequency: $visitFrequency, ')
          ..write('conversionProbability: $conversionProbability, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DcrsTable extends Dcrs with TableInfo<$DcrsTable, Dcr> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DcrsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _productsDiscussedMeta = const VerificationMeta(
    'productsDiscussed',
  );
  @override
  late final GeneratedColumn<String> productsDiscussed =
      GeneratedColumn<String>(
        'products_discussed',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _productsDetailedMeta = const VerificationMeta(
    'productsDetailed',
  );
  @override
  late final GeneratedColumn<String> productsDetailed = GeneratedColumn<String>(
    'products_detailed',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _samplesGivenMeta = const VerificationMeta(
    'samplesGiven',
  );
  @override
  late final GeneratedColumn<String> samplesGiven = GeneratedColumn<String>(
    'samples_given',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _giftsGivenMeta = const VerificationMeta(
    'giftsGiven',
  );
  @override
  late final GeneratedColumn<String> giftsGiven = GeneratedColumn<String>(
    'gifts_given',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _followUpDateMeta = const VerificationMeta(
    'followUpDate',
  );
  @override
  late final GeneratedColumn<DateTime> followUpDate = GeneratedColumn<DateTime>(
    'follow_up_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _callDurationMeta = const VerificationMeta(
    'callDuration',
  );
  @override
  late final GeneratedColumn<int> callDuration = GeneratedColumn<int>(
    'call_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _geoLatMeta = const VerificationMeta('geoLat');
  @override
  late final GeneratedColumn<double> geoLat = GeneratedColumn<double>(
    'geo_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _geoLngMeta = const VerificationMeta('geoLng');
  @override
  late final GeneratedColumn<double> geoLng = GeneratedColumn<double>(
    'geo_lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    doctorName,
    doctorId,
    productsDiscussed,
    productsDetailed,
    samplesGiven,
    giftsGiven,
    followUpDate,
    notes,
    callDuration,
    geoLat,
    geoLng,
    createdAt,
    mrId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dcrs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dcr> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorNameMeta);
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    }
    if (data.containsKey('products_discussed')) {
      context.handle(
        _productsDiscussedMeta,
        productsDiscussed.isAcceptableOrUnknown(
          data['products_discussed']!,
          _productsDiscussedMeta,
        ),
      );
    }
    if (data.containsKey('products_detailed')) {
      context.handle(
        _productsDetailedMeta,
        productsDetailed.isAcceptableOrUnknown(
          data['products_detailed']!,
          _productsDetailedMeta,
        ),
      );
    }
    if (data.containsKey('samples_given')) {
      context.handle(
        _samplesGivenMeta,
        samplesGiven.isAcceptableOrUnknown(
          data['samples_given']!,
          _samplesGivenMeta,
        ),
      );
    }
    if (data.containsKey('gifts_given')) {
      context.handle(
        _giftsGivenMeta,
        giftsGiven.isAcceptableOrUnknown(data['gifts_given']!, _giftsGivenMeta),
      );
    }
    if (data.containsKey('follow_up_date')) {
      context.handle(
        _followUpDateMeta,
        followUpDate.isAcceptableOrUnknown(
          data['follow_up_date']!,
          _followUpDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('call_duration')) {
      context.handle(
        _callDurationMeta,
        callDuration.isAcceptableOrUnknown(
          data['call_duration']!,
          _callDurationMeta,
        ),
      );
    }
    if (data.containsKey('geo_lat')) {
      context.handle(
        _geoLatMeta,
        geoLat.isAcceptableOrUnknown(data['geo_lat']!, _geoLatMeta),
      );
    }
    if (data.containsKey('geo_lng')) {
      context.handle(
        _geoLngMeta,
        geoLng.isAcceptableOrUnknown(data['geo_lng']!, _geoLngMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dcr map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dcr(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      )!,
      productsDiscussed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}products_discussed'],
      )!,
      productsDetailed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}products_detailed'],
      )!,
      samplesGiven: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}samples_given'],
      )!,
      giftsGiven: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gifts_given'],
      )!,
      followUpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}follow_up_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      callDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}call_duration'],
      )!,
      geoLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}geo_lat'],
      )!,
      geoLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}geo_lng'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
    );
  }

  @override
  $DcrsTable createAlias(String alias) {
    return $DcrsTable(attachedDatabase, alias);
  }
}

class Dcr extends DataClass implements Insertable<Dcr> {
  final String id;
  final String doctorName;
  final String doctorId;
  final String productsDiscussed;
  final String productsDetailed;
  final String samplesGiven;
  final String giftsGiven;
  final DateTime? followUpDate;
  final String notes;
  final int callDuration;
  final double geoLat;
  final double geoLng;
  final DateTime createdAt;
  final String mrId;
  const Dcr({
    required this.id,
    required this.doctorName,
    required this.doctorId,
    required this.productsDiscussed,
    required this.productsDetailed,
    required this.samplesGiven,
    required this.giftsGiven,
    this.followUpDate,
    required this.notes,
    required this.callDuration,
    required this.geoLat,
    required this.geoLng,
    required this.createdAt,
    required this.mrId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['doctor_name'] = Variable<String>(doctorName);
    map['doctor_id'] = Variable<String>(doctorId);
    map['products_discussed'] = Variable<String>(productsDiscussed);
    map['products_detailed'] = Variable<String>(productsDetailed);
    map['samples_given'] = Variable<String>(samplesGiven);
    map['gifts_given'] = Variable<String>(giftsGiven);
    if (!nullToAbsent || followUpDate != null) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate);
    }
    map['notes'] = Variable<String>(notes);
    map['call_duration'] = Variable<int>(callDuration);
    map['geo_lat'] = Variable<double>(geoLat);
    map['geo_lng'] = Variable<double>(geoLng);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['mr_id'] = Variable<String>(mrId);
    return map;
  }

  DcrsCompanion toCompanion(bool nullToAbsent) {
    return DcrsCompanion(
      id: Value(id),
      doctorName: Value(doctorName),
      doctorId: Value(doctorId),
      productsDiscussed: Value(productsDiscussed),
      productsDetailed: Value(productsDetailed),
      samplesGiven: Value(samplesGiven),
      giftsGiven: Value(giftsGiven),
      followUpDate: followUpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(followUpDate),
      notes: Value(notes),
      callDuration: Value(callDuration),
      geoLat: Value(geoLat),
      geoLng: Value(geoLng),
      createdAt: Value(createdAt),
      mrId: Value(mrId),
    );
  }

  factory Dcr.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dcr(
      id: serializer.fromJson<String>(json['id']),
      doctorName: serializer.fromJson<String>(json['doctorName']),
      doctorId: serializer.fromJson<String>(json['doctorId']),
      productsDiscussed: serializer.fromJson<String>(json['productsDiscussed']),
      productsDetailed: serializer.fromJson<String>(json['productsDetailed']),
      samplesGiven: serializer.fromJson<String>(json['samplesGiven']),
      giftsGiven: serializer.fromJson<String>(json['giftsGiven']),
      followUpDate: serializer.fromJson<DateTime?>(json['followUpDate']),
      notes: serializer.fromJson<String>(json['notes']),
      callDuration: serializer.fromJson<int>(json['callDuration']),
      geoLat: serializer.fromJson<double>(json['geoLat']),
      geoLng: serializer.fromJson<double>(json['geoLng']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      mrId: serializer.fromJson<String>(json['mrId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'doctorName': serializer.toJson<String>(doctorName),
      'doctorId': serializer.toJson<String>(doctorId),
      'productsDiscussed': serializer.toJson<String>(productsDiscussed),
      'productsDetailed': serializer.toJson<String>(productsDetailed),
      'samplesGiven': serializer.toJson<String>(samplesGiven),
      'giftsGiven': serializer.toJson<String>(giftsGiven),
      'followUpDate': serializer.toJson<DateTime?>(followUpDate),
      'notes': serializer.toJson<String>(notes),
      'callDuration': serializer.toJson<int>(callDuration),
      'geoLat': serializer.toJson<double>(geoLat),
      'geoLng': serializer.toJson<double>(geoLng),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'mrId': serializer.toJson<String>(mrId),
    };
  }

  Dcr copyWith({
    String? id,
    String? doctorName,
    String? doctorId,
    String? productsDiscussed,
    String? productsDetailed,
    String? samplesGiven,
    String? giftsGiven,
    Value<DateTime?> followUpDate = const Value.absent(),
    String? notes,
    int? callDuration,
    double? geoLat,
    double? geoLng,
    DateTime? createdAt,
    String? mrId,
  }) => Dcr(
    id: id ?? this.id,
    doctorName: doctorName ?? this.doctorName,
    doctorId: doctorId ?? this.doctorId,
    productsDiscussed: productsDiscussed ?? this.productsDiscussed,
    productsDetailed: productsDetailed ?? this.productsDetailed,
    samplesGiven: samplesGiven ?? this.samplesGiven,
    giftsGiven: giftsGiven ?? this.giftsGiven,
    followUpDate: followUpDate.present ? followUpDate.value : this.followUpDate,
    notes: notes ?? this.notes,
    callDuration: callDuration ?? this.callDuration,
    geoLat: geoLat ?? this.geoLat,
    geoLng: geoLng ?? this.geoLng,
    createdAt: createdAt ?? this.createdAt,
    mrId: mrId ?? this.mrId,
  );
  Dcr copyWithCompanion(DcrsCompanion data) {
    return Dcr(
      id: data.id.present ? data.id.value : this.id,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      productsDiscussed: data.productsDiscussed.present
          ? data.productsDiscussed.value
          : this.productsDiscussed,
      productsDetailed: data.productsDetailed.present
          ? data.productsDetailed.value
          : this.productsDetailed,
      samplesGiven: data.samplesGiven.present
          ? data.samplesGiven.value
          : this.samplesGiven,
      giftsGiven: data.giftsGiven.present
          ? data.giftsGiven.value
          : this.giftsGiven,
      followUpDate: data.followUpDate.present
          ? data.followUpDate.value
          : this.followUpDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      callDuration: data.callDuration.present
          ? data.callDuration.value
          : this.callDuration,
      geoLat: data.geoLat.present ? data.geoLat.value : this.geoLat,
      geoLng: data.geoLng.present ? data.geoLng.value : this.geoLng,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dcr(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('doctorId: $doctorId, ')
          ..write('productsDiscussed: $productsDiscussed, ')
          ..write('productsDetailed: $productsDetailed, ')
          ..write('samplesGiven: $samplesGiven, ')
          ..write('giftsGiven: $giftsGiven, ')
          ..write('followUpDate: $followUpDate, ')
          ..write('notes: $notes, ')
          ..write('callDuration: $callDuration, ')
          ..write('geoLat: $geoLat, ')
          ..write('geoLng: $geoLng, ')
          ..write('createdAt: $createdAt, ')
          ..write('mrId: $mrId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    doctorName,
    doctorId,
    productsDiscussed,
    productsDetailed,
    samplesGiven,
    giftsGiven,
    followUpDate,
    notes,
    callDuration,
    geoLat,
    geoLng,
    createdAt,
    mrId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dcr &&
          other.id == this.id &&
          other.doctorName == this.doctorName &&
          other.doctorId == this.doctorId &&
          other.productsDiscussed == this.productsDiscussed &&
          other.productsDetailed == this.productsDetailed &&
          other.samplesGiven == this.samplesGiven &&
          other.giftsGiven == this.giftsGiven &&
          other.followUpDate == this.followUpDate &&
          other.notes == this.notes &&
          other.callDuration == this.callDuration &&
          other.geoLat == this.geoLat &&
          other.geoLng == this.geoLng &&
          other.createdAt == this.createdAt &&
          other.mrId == this.mrId);
}

class DcrsCompanion extends UpdateCompanion<Dcr> {
  final Value<String> id;
  final Value<String> doctorName;
  final Value<String> doctorId;
  final Value<String> productsDiscussed;
  final Value<String> productsDetailed;
  final Value<String> samplesGiven;
  final Value<String> giftsGiven;
  final Value<DateTime?> followUpDate;
  final Value<String> notes;
  final Value<int> callDuration;
  final Value<double> geoLat;
  final Value<double> geoLng;
  final Value<DateTime> createdAt;
  final Value<String> mrId;
  final Value<int> rowid;
  const DcrsCompanion({
    this.id = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.productsDiscussed = const Value.absent(),
    this.productsDetailed = const Value.absent(),
    this.samplesGiven = const Value.absent(),
    this.giftsGiven = const Value.absent(),
    this.followUpDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.callDuration = const Value.absent(),
    this.geoLat = const Value.absent(),
    this.geoLng = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.mrId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DcrsCompanion.insert({
    required String id,
    required String doctorName,
    this.doctorId = const Value.absent(),
    this.productsDiscussed = const Value.absent(),
    this.productsDetailed = const Value.absent(),
    this.samplesGiven = const Value.absent(),
    this.giftsGiven = const Value.absent(),
    this.followUpDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.callDuration = const Value.absent(),
    this.geoLat = const Value.absent(),
    this.geoLng = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String mrId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       doctorName = Value(doctorName),
       mrId = Value(mrId);
  static Insertable<Dcr> custom({
    Expression<String>? id,
    Expression<String>? doctorName,
    Expression<String>? doctorId,
    Expression<String>? productsDiscussed,
    Expression<String>? productsDetailed,
    Expression<String>? samplesGiven,
    Expression<String>? giftsGiven,
    Expression<DateTime>? followUpDate,
    Expression<String>? notes,
    Expression<int>? callDuration,
    Expression<double>? geoLat,
    Expression<double>? geoLng,
    Expression<DateTime>? createdAt,
    Expression<String>? mrId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (doctorName != null) 'doctor_name': doctorName,
      if (doctorId != null) 'doctor_id': doctorId,
      if (productsDiscussed != null) 'products_discussed': productsDiscussed,
      if (productsDetailed != null) 'products_detailed': productsDetailed,
      if (samplesGiven != null) 'samples_given': samplesGiven,
      if (giftsGiven != null) 'gifts_given': giftsGiven,
      if (followUpDate != null) 'follow_up_date': followUpDate,
      if (notes != null) 'notes': notes,
      if (callDuration != null) 'call_duration': callDuration,
      if (geoLat != null) 'geo_lat': geoLat,
      if (geoLng != null) 'geo_lng': geoLng,
      if (createdAt != null) 'created_at': createdAt,
      if (mrId != null) 'mr_id': mrId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DcrsCompanion copyWith({
    Value<String>? id,
    Value<String>? doctorName,
    Value<String>? doctorId,
    Value<String>? productsDiscussed,
    Value<String>? productsDetailed,
    Value<String>? samplesGiven,
    Value<String>? giftsGiven,
    Value<DateTime?>? followUpDate,
    Value<String>? notes,
    Value<int>? callDuration,
    Value<double>? geoLat,
    Value<double>? geoLng,
    Value<DateTime>? createdAt,
    Value<String>? mrId,
    Value<int>? rowid,
  }) {
    return DcrsCompanion(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      doctorId: doctorId ?? this.doctorId,
      productsDiscussed: productsDiscussed ?? this.productsDiscussed,
      productsDetailed: productsDetailed ?? this.productsDetailed,
      samplesGiven: samplesGiven ?? this.samplesGiven,
      giftsGiven: giftsGiven ?? this.giftsGiven,
      followUpDate: followUpDate ?? this.followUpDate,
      notes: notes ?? this.notes,
      callDuration: callDuration ?? this.callDuration,
      geoLat: geoLat ?? this.geoLat,
      geoLng: geoLng ?? this.geoLng,
      createdAt: createdAt ?? this.createdAt,
      mrId: mrId ?? this.mrId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (productsDiscussed.present) {
      map['products_discussed'] = Variable<String>(productsDiscussed.value);
    }
    if (productsDetailed.present) {
      map['products_detailed'] = Variable<String>(productsDetailed.value);
    }
    if (samplesGiven.present) {
      map['samples_given'] = Variable<String>(samplesGiven.value);
    }
    if (giftsGiven.present) {
      map['gifts_given'] = Variable<String>(giftsGiven.value);
    }
    if (followUpDate.present) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (callDuration.present) {
      map['call_duration'] = Variable<int>(callDuration.value);
    }
    if (geoLat.present) {
      map['geo_lat'] = Variable<double>(geoLat.value);
    }
    if (geoLng.present) {
      map['geo_lng'] = Variable<double>(geoLng.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DcrsCompanion(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('doctorId: $doctorId, ')
          ..write('productsDiscussed: $productsDiscussed, ')
          ..write('productsDetailed: $productsDetailed, ')
          ..write('samplesGiven: $samplesGiven, ')
          ..write('giftsGiven: $giftsGiven, ')
          ..write('followUpDate: $followUpDate, ')
          ..write('notes: $notes, ')
          ..write('callDuration: $callDuration, ')
          ..write('geoLat: $geoLat, ')
          ..write('geoLng: $geoLng, ')
          ..write('createdAt: $createdAt, ')
          ..write('mrId: $mrId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseCategory, int> category =
      GeneratedColumn<int>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ExpenseCategory>($ExpensesTable.$convertercategory);
  static const VerificationMeta _receiptImagePathMeta = const VerificationMeta(
    'receiptImagePath',
  );
  @override
  late final GeneratedColumn<String> receiptImagePath = GeneratedColumn<String>(
    'receipt_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isApprovedMeta = const VerificationMeta(
    'isApproved',
  );
  @override
  late final GeneratedColumn<bool> isApproved = GeneratedColumn<bool>(
    'is_approved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_approved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _warningFlagMeta = const VerificationMeta(
    'warningFlag',
  );
  @override
  late final GeneratedColumn<bool> warningFlag = GeneratedColumn<bool>(
    'warning_flag',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warning_flag" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    date,
    category,
    receiptImagePath,
    isApproved,
    warningFlag,
    createdAt,
    mrId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('receipt_image_path')) {
      context.handle(
        _receiptImagePathMeta,
        receiptImagePath.isAcceptableOrUnknown(
          data['receipt_image_path']!,
          _receiptImagePathMeta,
        ),
      );
    }
    if (data.containsKey('is_approved')) {
      context.handle(
        _isApprovedMeta,
        isApproved.isAcceptableOrUnknown(data['is_approved']!, _isApprovedMeta),
      );
    }
    if (data.containsKey('warning_flag')) {
      context.handle(
        _warningFlagMeta,
        warningFlag.isAcceptableOrUnknown(
          data['warning_flag']!,
          _warningFlagMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      category: $ExpensesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        )!,
      ),
      receiptImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_image_path'],
      ),
      isApproved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_approved'],
      )!,
      warningFlag: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warning_flag'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExpenseCategory, int, int> $convertercategory =
      const EnumIndexConverter<ExpenseCategory>(ExpenseCategory.values);
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final String? receiptImagePath;
  final bool isApproved;
  final bool warningFlag;
  final DateTime createdAt;
  final String mrId;
  const Expense({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
    this.receiptImagePath,
    required this.isApproved,
    required this.warningFlag,
    required this.createdAt,
    required this.mrId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    {
      map['category'] = Variable<int>(
        $ExpensesTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || receiptImagePath != null) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath);
    }
    map['is_approved'] = Variable<bool>(isApproved);
    map['warning_flag'] = Variable<bool>(warningFlag);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['mr_id'] = Variable<String>(mrId);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      amount: Value(amount),
      date: Value(date),
      category: Value(category),
      receiptImagePath: receiptImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptImagePath),
      isApproved: Value(isApproved),
      warningFlag: Value(warningFlag),
      createdAt: Value(createdAt),
      mrId: Value(mrId),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: $ExpensesTable.$convertercategory.fromJson(
        serializer.fromJson<int>(json['category']),
      ),
      receiptImagePath: serializer.fromJson<String?>(json['receiptImagePath']),
      isApproved: serializer.fromJson<bool>(json['isApproved']),
      warningFlag: serializer.fromJson<bool>(json['warningFlag']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      mrId: serializer.fromJson<String>(json['mrId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<int>(
        $ExpensesTable.$convertercategory.toJson(category),
      ),
      'receiptImagePath': serializer.toJson<String?>(receiptImagePath),
      'isApproved': serializer.toJson<bool>(isApproved),
      'warningFlag': serializer.toJson<bool>(warningFlag),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'mrId': serializer.toJson<String>(mrId),
    };
  }

  Expense copyWith({
    String? id,
    double? amount,
    DateTime? date,
    ExpenseCategory? category,
    Value<String?> receiptImagePath = const Value.absent(),
    bool? isApproved,
    bool? warningFlag,
    DateTime? createdAt,
    String? mrId,
  }) => Expense(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    category: category ?? this.category,
    receiptImagePath: receiptImagePath.present
        ? receiptImagePath.value
        : this.receiptImagePath,
    isApproved: isApproved ?? this.isApproved,
    warningFlag: warningFlag ?? this.warningFlag,
    createdAt: createdAt ?? this.createdAt,
    mrId: mrId ?? this.mrId,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      receiptImagePath: data.receiptImagePath.present
          ? data.receiptImagePath.value
          : this.receiptImagePath,
      isApproved: data.isApproved.present
          ? data.isApproved.value
          : this.isApproved,
      warningFlag: data.warningFlag.present
          ? data.warningFlag.value
          : this.warningFlag,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('isApproved: $isApproved, ')
          ..write('warningFlag: $warningFlag, ')
          ..write('createdAt: $createdAt, ')
          ..write('mrId: $mrId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    date,
    category,
    receiptImagePath,
    isApproved,
    warningFlag,
    createdAt,
    mrId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.category == this.category &&
          other.receiptImagePath == this.receiptImagePath &&
          other.isApproved == this.isApproved &&
          other.warningFlag == this.warningFlag &&
          other.createdAt == this.createdAt &&
          other.mrId == this.mrId);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<ExpenseCategory> category;
  final Value<String?> receiptImagePath;
  final Value<bool> isApproved;
  final Value<bool> warningFlag;
  final Value<DateTime> createdAt;
  final Value<String> mrId;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.isApproved = const Value.absent(),
    this.warningFlag = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.mrId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required double amount,
    required DateTime date,
    required ExpenseCategory category,
    this.receiptImagePath = const Value.absent(),
    this.isApproved = const Value.absent(),
    this.warningFlag = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String mrId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       date = Value(date),
       category = Value(category),
       mrId = Value(mrId);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<int>? category,
    Expression<String>? receiptImagePath,
    Expression<bool>? isApproved,
    Expression<bool>? warningFlag,
    Expression<DateTime>? createdAt,
    Expression<String>? mrId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
      if (isApproved != null) 'is_approved': isApproved,
      if (warningFlag != null) 'warning_flag': warningFlag,
      if (createdAt != null) 'created_at': createdAt,
      if (mrId != null) 'mr_id': mrId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<ExpenseCategory>? category,
    Value<String?>? receiptImagePath,
    Value<bool>? isApproved,
    Value<bool>? warningFlag,
    Value<DateTime>? createdAt,
    Value<String>? mrId,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      isApproved: isApproved ?? this.isApproved,
      warningFlag: warningFlag ?? this.warningFlag,
      createdAt: createdAt ?? this.createdAt,
      mrId: mrId ?? this.mrId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $ExpensesTable.$convertercategory.toSql(category.value),
      );
    }
    if (receiptImagePath.present) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath.value);
    }
    if (isApproved.present) {
      map['is_approved'] = Variable<bool>(isApproved.value);
    }
    if (warningFlag.present) {
      map['warning_flag'] = Variable<bool>(warningFlag.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('isApproved: $isApproved, ')
          ..write('warningFlag: $warningFlag, ')
          ..write('createdAt: $createdAt, ')
          ..write('mrId: $mrId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitsTable extends Visits with TableInfo<$VisitsTable, Visit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES doctors (id)',
    ),
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitDateMeta = const VerificationMeta(
    'visitDate',
  );
  @override
  late final GeneratedColumn<DateTime> visitDate = GeneratedColumn<DateTime>(
    'visit_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    doctorId,
    mrId,
    visitDate,
    notes,
    outcome,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Visit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorIdMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('visit_date')) {
      context.handle(
        _visitDateMeta,
        visitDate.isAcceptableOrUnknown(data['visit_date']!, _visitDateMeta),
      );
    } else if (isInserting) {
      context.missing(_visitDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Visit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Visit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      visitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}visit_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $VisitsTable createAlias(String alias) {
    return $VisitsTable(attachedDatabase, alias);
  }
}

class Visit extends DataClass implements Insertable<Visit> {
  final String id;
  final String doctorId;
  final String mrId;
  final DateTime visitDate;
  final String notes;
  final String outcome;
  final bool isCompleted;
  const Visit({
    required this.id,
    required this.doctorId,
    required this.mrId,
    required this.visitDate,
    required this.notes,
    required this.outcome,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['doctor_id'] = Variable<String>(doctorId);
    map['mr_id'] = Variable<String>(mrId);
    map['visit_date'] = Variable<DateTime>(visitDate);
    map['notes'] = Variable<String>(notes);
    map['outcome'] = Variable<String>(outcome);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  VisitsCompanion toCompanion(bool nullToAbsent) {
    return VisitsCompanion(
      id: Value(id),
      doctorId: Value(doctorId),
      mrId: Value(mrId),
      visitDate: Value(visitDate),
      notes: Value(notes),
      outcome: Value(outcome),
      isCompleted: Value(isCompleted),
    );
  }

  factory Visit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Visit(
      id: serializer.fromJson<String>(json['id']),
      doctorId: serializer.fromJson<String>(json['doctorId']),
      mrId: serializer.fromJson<String>(json['mrId']),
      visitDate: serializer.fromJson<DateTime>(json['visitDate']),
      notes: serializer.fromJson<String>(json['notes']),
      outcome: serializer.fromJson<String>(json['outcome']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'doctorId': serializer.toJson<String>(doctorId),
      'mrId': serializer.toJson<String>(mrId),
      'visitDate': serializer.toJson<DateTime>(visitDate),
      'notes': serializer.toJson<String>(notes),
      'outcome': serializer.toJson<String>(outcome),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  Visit copyWith({
    String? id,
    String? doctorId,
    String? mrId,
    DateTime? visitDate,
    String? notes,
    String? outcome,
    bool? isCompleted,
  }) => Visit(
    id: id ?? this.id,
    doctorId: doctorId ?? this.doctorId,
    mrId: mrId ?? this.mrId,
    visitDate: visitDate ?? this.visitDate,
    notes: notes ?? this.notes,
    outcome: outcome ?? this.outcome,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  Visit copyWithCompanion(VisitsCompanion data) {
    return Visit(
      id: data.id.present ? data.id.value : this.id,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      visitDate: data.visitDate.present ? data.visitDate.value : this.visitDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Visit(')
          ..write('id: $id, ')
          ..write('doctorId: $doctorId, ')
          ..write('mrId: $mrId, ')
          ..write('visitDate: $visitDate, ')
          ..write('notes: $notes, ')
          ..write('outcome: $outcome, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, doctorId, mrId, visitDate, notes, outcome, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Visit &&
          other.id == this.id &&
          other.doctorId == this.doctorId &&
          other.mrId == this.mrId &&
          other.visitDate == this.visitDate &&
          other.notes == this.notes &&
          other.outcome == this.outcome &&
          other.isCompleted == this.isCompleted);
}

class VisitsCompanion extends UpdateCompanion<Visit> {
  final Value<String> id;
  final Value<String> doctorId;
  final Value<String> mrId;
  final Value<DateTime> visitDate;
  final Value<String> notes;
  final Value<String> outcome;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const VisitsCompanion({
    this.id = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.mrId = const Value.absent(),
    this.visitDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.outcome = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitsCompanion.insert({
    required String id,
    required String doctorId,
    required String mrId,
    required DateTime visitDate,
    this.notes = const Value.absent(),
    this.outcome = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       doctorId = Value(doctorId),
       mrId = Value(mrId),
       visitDate = Value(visitDate);
  static Insertable<Visit> custom({
    Expression<String>? id,
    Expression<String>? doctorId,
    Expression<String>? mrId,
    Expression<DateTime>? visitDate,
    Expression<String>? notes,
    Expression<String>? outcome,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (doctorId != null) 'doctor_id': doctorId,
      if (mrId != null) 'mr_id': mrId,
      if (visitDate != null) 'visit_date': visitDate,
      if (notes != null) 'notes': notes,
      if (outcome != null) 'outcome': outcome,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitsCompanion copyWith({
    Value<String>? id,
    Value<String>? doctorId,
    Value<String>? mrId,
    Value<DateTime>? visitDate,
    Value<String>? notes,
    Value<String>? outcome,
    Value<bool>? isCompleted,
    Value<int>? rowid,
  }) {
    return VisitsCompanion(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      mrId: mrId ?? this.mrId,
      visitDate: visitDate ?? this.visitDate,
      notes: notes ?? this.notes,
      outcome: outcome ?? this.outcome,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (visitDate.present) {
      map['visit_date'] = Variable<DateTime>(visitDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitsCompanion(')
          ..write('id: $id, ')
          ..write('doctorId: $doctorId, ')
          ..write('mrId: $mrId, ')
          ..write('visitDate: $visitDate, ')
          ..write('notes: $notes, ')
          ..write('outcome: $outcome, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecommendationsTable extends Recommendations
    with TableInfo<$RecommendationsTable, Recommendation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecommendationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specializationMeta = const VerificationMeta(
    'specialization',
  );
  @override
  late final GeneratedColumn<String> specialization = GeneratedColumn<String>(
    'specialization',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    doctorName,
    specialization,
    address,
    score,
    reason,
    fetchedAt,
    mrId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recommendations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recommendation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorNameMeta);
    }
    if (data.containsKey('specialization')) {
      context.handle(
        _specializationMeta,
        specialization.isAcceptableOrUnknown(
          data['specialization']!,
          _specializationMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recommendation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recommendation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      )!,
      specialization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialization'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
    );
  }

  @override
  $RecommendationsTable createAlias(String alias) {
    return $RecommendationsTable(attachedDatabase, alias);
  }
}

class Recommendation extends DataClass implements Insertable<Recommendation> {
  final int id;
  final String doctorName;
  final String specialization;
  final String address;
  final double score;
  final String reason;
  final DateTime fetchedAt;
  final String mrId;
  const Recommendation({
    required this.id,
    required this.doctorName,
    required this.specialization,
    required this.address,
    required this.score,
    required this.reason,
    required this.fetchedAt,
    required this.mrId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['doctor_name'] = Variable<String>(doctorName);
    map['specialization'] = Variable<String>(specialization);
    map['address'] = Variable<String>(address);
    map['score'] = Variable<double>(score);
    map['reason'] = Variable<String>(reason);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['mr_id'] = Variable<String>(mrId);
    return map;
  }

  RecommendationsCompanion toCompanion(bool nullToAbsent) {
    return RecommendationsCompanion(
      id: Value(id),
      doctorName: Value(doctorName),
      specialization: Value(specialization),
      address: Value(address),
      score: Value(score),
      reason: Value(reason),
      fetchedAt: Value(fetchedAt),
      mrId: Value(mrId),
    );
  }

  factory Recommendation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recommendation(
      id: serializer.fromJson<int>(json['id']),
      doctorName: serializer.fromJson<String>(json['doctorName']),
      specialization: serializer.fromJson<String>(json['specialization']),
      address: serializer.fromJson<String>(json['address']),
      score: serializer.fromJson<double>(json['score']),
      reason: serializer.fromJson<String>(json['reason']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      mrId: serializer.fromJson<String>(json['mrId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'doctorName': serializer.toJson<String>(doctorName),
      'specialization': serializer.toJson<String>(specialization),
      'address': serializer.toJson<String>(address),
      'score': serializer.toJson<double>(score),
      'reason': serializer.toJson<String>(reason),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'mrId': serializer.toJson<String>(mrId),
    };
  }

  Recommendation copyWith({
    int? id,
    String? doctorName,
    String? specialization,
    String? address,
    double? score,
    String? reason,
    DateTime? fetchedAt,
    String? mrId,
  }) => Recommendation(
    id: id ?? this.id,
    doctorName: doctorName ?? this.doctorName,
    specialization: specialization ?? this.specialization,
    address: address ?? this.address,
    score: score ?? this.score,
    reason: reason ?? this.reason,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    mrId: mrId ?? this.mrId,
  );
  Recommendation copyWithCompanion(RecommendationsCompanion data) {
    return Recommendation(
      id: data.id.present ? data.id.value : this.id,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      specialization: data.specialization.present
          ? data.specialization.value
          : this.specialization,
      address: data.address.present ? data.address.value : this.address,
      score: data.score.present ? data.score.value : this.score,
      reason: data.reason.present ? data.reason.value : this.reason,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recommendation(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialization: $specialization, ')
          ..write('address: $address, ')
          ..write('score: $score, ')
          ..write('reason: $reason, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('mrId: $mrId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    doctorName,
    specialization,
    address,
    score,
    reason,
    fetchedAt,
    mrId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recommendation &&
          other.id == this.id &&
          other.doctorName == this.doctorName &&
          other.specialization == this.specialization &&
          other.address == this.address &&
          other.score == this.score &&
          other.reason == this.reason &&
          other.fetchedAt == this.fetchedAt &&
          other.mrId == this.mrId);
}

class RecommendationsCompanion extends UpdateCompanion<Recommendation> {
  final Value<int> id;
  final Value<String> doctorName;
  final Value<String> specialization;
  final Value<String> address;
  final Value<double> score;
  final Value<String> reason;
  final Value<DateTime> fetchedAt;
  final Value<String> mrId;
  const RecommendationsCompanion({
    this.id = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.specialization = const Value.absent(),
    this.address = const Value.absent(),
    this.score = const Value.absent(),
    this.reason = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.mrId = const Value.absent(),
  });
  RecommendationsCompanion.insert({
    this.id = const Value.absent(),
    required String doctorName,
    this.specialization = const Value.absent(),
    this.address = const Value.absent(),
    this.score = const Value.absent(),
    this.reason = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    required String mrId,
  }) : doctorName = Value(doctorName),
       mrId = Value(mrId);
  static Insertable<Recommendation> custom({
    Expression<int>? id,
    Expression<String>? doctorName,
    Expression<String>? specialization,
    Expression<String>? address,
    Expression<double>? score,
    Expression<String>? reason,
    Expression<DateTime>? fetchedAt,
    Expression<String>? mrId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (doctorName != null) 'doctor_name': doctorName,
      if (specialization != null) 'specialization': specialization,
      if (address != null) 'address': address,
      if (score != null) 'score': score,
      if (reason != null) 'reason': reason,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (mrId != null) 'mr_id': mrId,
    });
  }

  RecommendationsCompanion copyWith({
    Value<int>? id,
    Value<String>? doctorName,
    Value<String>? specialization,
    Value<String>? address,
    Value<double>? score,
    Value<String>? reason,
    Value<DateTime>? fetchedAt,
    Value<String>? mrId,
  }) {
    return RecommendationsCompanion(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      address: address ?? this.address,
      score: score ?? this.score,
      reason: reason ?? this.reason,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      mrId: mrId ?? this.mrId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (specialization.present) {
      map['specialization'] = Variable<String>(specialization.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationsCompanion(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialization: $specialization, ')
          ..write('address: $address, ')
          ..write('score: $score, ')
          ..write('reason: $reason, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('mrId: $mrId')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mr'),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _territoryIdMeta = const VerificationMeta(
    'territoryId',
  );
  @override
  late final GeneratedColumn<String> territoryId = GeneratedColumn<String>(
    'territory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    name,
    role,
    parentId,
    territoryId,
    isActive,
    phone,
    profileImageUrl,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('territory_id')) {
      context.handle(
        _territoryIdMeta,
        territoryId.isAcceptableOrUnknown(
          data['territory_id']!,
          _territoryIdMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      )!,
      territoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}territory_id'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String email;
  final String name;
  final String role;
  final String parentId;
  final String territoryId;
  final bool isActive;
  final String phone;
  final String profileImageUrl;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.parentId,
    required this.territoryId,
    required this.isActive,
    required this.phone,
    required this.profileImageUrl,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['parent_id'] = Variable<String>(parentId);
    map['territory_id'] = Variable<String>(territoryId);
    map['is_active'] = Variable<bool>(isActive);
    map['phone'] = Variable<String>(phone);
    map['profile_image_url'] = Variable<String>(profileImageUrl);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      name: Value(name),
      role: Value(role),
      parentId: Value(parentId),
      territoryId: Value(territoryId),
      isActive: Value(isActive),
      phone: Value(phone),
      profileImageUrl: Value(profileImageUrl),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      parentId: serializer.fromJson<String>(json['parentId']),
      territoryId: serializer.fromJson<String>(json['territoryId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      phone: serializer.fromJson<String>(json['phone']),
      profileImageUrl: serializer.fromJson<String>(json['profileImageUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'parentId': serializer.toJson<String>(parentId),
      'territoryId': serializer.toJson<String>(territoryId),
      'isActive': serializer.toJson<bool>(isActive),
      'phone': serializer.toJson<String>(phone),
      'profileImageUrl': serializer.toJson<String>(profileImageUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? parentId,
    String? territoryId,
    bool? isActive,
    String? phone,
    String? profileImageUrl,
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    role: role ?? this.role,
    parentId: parentId ?? this.parentId,
    territoryId: territoryId ?? this.territoryId,
    isActive: isActive ?? this.isActive,
    phone: phone ?? this.phone,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      territoryId: data.territoryId.present
          ? data.territoryId.value
          : this.territoryId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      phone: data.phone.present ? data.phone.value : this.phone,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('parentId: $parentId, ')
          ..write('territoryId: $territoryId, ')
          ..write('isActive: $isActive, ')
          ..write('phone: $phone, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    name,
    role,
    parentId,
    territoryId,
    isActive,
    phone,
    profileImageUrl,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.name == this.name &&
          other.role == this.role &&
          other.parentId == this.parentId &&
          other.territoryId == this.territoryId &&
          other.isActive == this.isActive &&
          other.phone == this.phone &&
          other.profileImageUrl == this.profileImageUrl &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> name;
  final Value<String> role;
  final Value<String> parentId;
  final Value<String> territoryId;
  final Value<bool> isActive;
  final Value<String> phone;
  final Value<String> profileImageUrl;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.parentId = const Value.absent(),
    this.territoryId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.phone = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String name,
    this.role = const Value.absent(),
    this.parentId = const Value.absent(),
    this.territoryId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.phone = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       name = Value(name);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? parentId,
    Expression<String>? territoryId,
    Expression<bool>? isActive,
    Expression<String>? phone,
    Expression<String>? profileImageUrl,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (parentId != null) 'parent_id': parentId,
      if (territoryId != null) 'territory_id': territoryId,
      if (isActive != null) 'is_active': isActive,
      if (phone != null) 'phone': phone,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? name,
    Value<String>? role,
    Value<String>? parentId,
    Value<String>? territoryId,
    Value<bool>? isActive,
    Value<String>? phone,
    Value<String>? profileImageUrl,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      parentId: parentId ?? this.parentId,
      territoryId: territoryId ?? this.territoryId,
      isActive: isActive ?? this.isActive,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (territoryId.present) {
      map['territory_id'] = Variable<String>(territoryId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('parentId: $parentId, ')
          ..write('territoryId: $territoryId, ')
          ..write('isActive: $isActive, ')
          ..write('phone: $phone, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _divisionMeta = const VerificationMeta(
    'division',
  );
  @override
  late final GeneratedColumn<String> division = GeneratedColumn<String>(
    'division',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sku,
    category,
    division,
    price,
    description,
    imageUrl,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('division')) {
      context.handle(
        _divisionMeta,
        division.isAcceptableOrUnknown(data['division']!, _divisionMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      division: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}division'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String sku;
  final String category;
  final String division;
  final double price;
  final String description;
  final String imageUrl;
  final bool isActive;
  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.division,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sku'] = Variable<String>(sku);
    map['category'] = Variable<String>(category);
    map['division'] = Variable<String>(division);
    map['price'] = Variable<double>(price);
    map['description'] = Variable<String>(description);
    map['image_url'] = Variable<String>(imageUrl);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      sku: Value(sku),
      category: Value(category),
      division: Value(division),
      price: Value(price),
      description: Value(description),
      imageUrl: Value(imageUrl),
      isActive: Value(isActive),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String>(json['sku']),
      category: serializer.fromJson<String>(json['category']),
      division: serializer.fromJson<String>(json['division']),
      price: serializer.fromJson<double>(json['price']),
      description: serializer.fromJson<String>(json['description']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String>(sku),
      'category': serializer.toJson<String>(category),
      'division': serializer.toJson<String>(division),
      'price': serializer.toJson<double>(price),
      'description': serializer.toJson<String>(description),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    String? division,
    double? price,
    String? description,
    String? imageUrl,
    bool? isActive,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    sku: sku ?? this.sku,
    category: category ?? this.category,
    division: division ?? this.division,
    price: price ?? this.price,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
    isActive: isActive ?? this.isActive,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sku: data.sku.present ? data.sku.value : this.sku,
      category: data.category.present ? data.category.value : this.category,
      division: data.division.present ? data.division.value : this.division,
      price: data.price.present ? data.price.value : this.price,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('category: $category, ')
          ..write('division: $division, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sku,
    category,
    division,
    price,
    description,
    imageUrl,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.category == this.category &&
          other.division == this.division &&
          other.price == this.price &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.isActive == this.isActive);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> sku;
  final Value<String> category;
  final Value<String> division;
  final Value<double> price;
  final Value<String> description;
  final Value<String> imageUrl;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.category = const Value.absent(),
    this.division = const Value.absent(),
    this.price = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    this.sku = const Value.absent(),
    this.category = const Value.absent(),
    this.division = const Value.absent(),
    this.price = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sku,
    Expression<String>? category,
    Expression<String>? division,
    Expression<double>? price,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (category != null) 'category': category,
      if (division != null) 'division': division,
      if (price != null) 'price': price,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? sku,
    Value<String>? category,
    Value<String>? division,
    Value<double>? price,
    Value<String>? description,
    Value<String>? imageUrl,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      division: division ?? this.division,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (division.present) {
      map['division'] = Variable<String>(division.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('category: $category, ')
          ..write('division: $division, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SamplesTable extends Samples with TableInfo<$SamplesTable, Sample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchNoMeta = const VerificationMeta(
    'batchNo',
  );
  @override
  late final GeneratedColumn<String> batchNo = GeneratedColumn<String>(
    'batch_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sample'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    mrId,
    doctorId,
    quantity,
    date,
    batchNo,
    expiryDate,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('batch_no')) {
      context.handle(
        _batchNoMeta,
        batchNo.isAcceptableOrUnknown(data['batch_no']!, _batchNoMeta),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      batchNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_no'],
      )!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $SamplesTable createAlias(String alias) {
    return $SamplesTable(attachedDatabase, alias);
  }
}

class Sample extends DataClass implements Insertable<Sample> {
  final String id;
  final String productId;
  final String mrId;
  final String doctorId;
  final int quantity;
  final DateTime date;
  final String batchNo;
  final DateTime? expiryDate;
  final String type;
  const Sample({
    required this.id,
    required this.productId,
    required this.mrId,
    required this.doctorId,
    required this.quantity,
    required this.date,
    required this.batchNo,
    this.expiryDate,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['mr_id'] = Variable<String>(mrId);
    map['doctor_id'] = Variable<String>(doctorId);
    map['quantity'] = Variable<int>(quantity);
    map['date'] = Variable<DateTime>(date);
    map['batch_no'] = Variable<String>(batchNo);
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['type'] = Variable<String>(type);
    return map;
  }

  SamplesCompanion toCompanion(bool nullToAbsent) {
    return SamplesCompanion(
      id: Value(id),
      productId: Value(productId),
      mrId: Value(mrId),
      doctorId: Value(doctorId),
      quantity: Value(quantity),
      date: Value(date),
      batchNo: Value(batchNo),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      type: Value(type),
    );
  }

  factory Sample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sample(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      mrId: serializer.fromJson<String>(json['mrId']),
      doctorId: serializer.fromJson<String>(json['doctorId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      date: serializer.fromJson<DateTime>(json['date']),
      batchNo: serializer.fromJson<String>(json['batchNo']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'mrId': serializer.toJson<String>(mrId),
      'doctorId': serializer.toJson<String>(doctorId),
      'quantity': serializer.toJson<int>(quantity),
      'date': serializer.toJson<DateTime>(date),
      'batchNo': serializer.toJson<String>(batchNo),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'type': serializer.toJson<String>(type),
    };
  }

  Sample copyWith({
    String? id,
    String? productId,
    String? mrId,
    String? doctorId,
    int? quantity,
    DateTime? date,
    String? batchNo,
    Value<DateTime?> expiryDate = const Value.absent(),
    String? type,
  }) => Sample(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    mrId: mrId ?? this.mrId,
    doctorId: doctorId ?? this.doctorId,
    quantity: quantity ?? this.quantity,
    date: date ?? this.date,
    batchNo: batchNo ?? this.batchNo,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    type: type ?? this.type,
  );
  Sample copyWithCompanion(SamplesCompanion data) {
    return Sample(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      date: data.date.present ? data.date.value : this.date,
      batchNo: data.batchNo.present ? data.batchNo.value : this.batchNo,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sample(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mrId: $mrId, ')
          ..write('doctorId: $doctorId, ')
          ..write('quantity: $quantity, ')
          ..write('date: $date, ')
          ..write('batchNo: $batchNo, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    mrId,
    doctorId,
    quantity,
    date,
    batchNo,
    expiryDate,
    type,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sample &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.mrId == this.mrId &&
          other.doctorId == this.doctorId &&
          other.quantity == this.quantity &&
          other.date == this.date &&
          other.batchNo == this.batchNo &&
          other.expiryDate == this.expiryDate &&
          other.type == this.type);
}

class SamplesCompanion extends UpdateCompanion<Sample> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> mrId;
  final Value<String> doctorId;
  final Value<int> quantity;
  final Value<DateTime> date;
  final Value<String> batchNo;
  final Value<DateTime?> expiryDate;
  final Value<String> type;
  final Value<int> rowid;
  const SamplesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.mrId = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.date = const Value.absent(),
    this.batchNo = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SamplesCompanion.insert({
    required String id,
    required String productId,
    required String mrId,
    required String doctorId,
    required int quantity,
    required DateTime date,
    this.batchNo = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       mrId = Value(mrId),
       doctorId = Value(doctorId),
       quantity = Value(quantity),
       date = Value(date);
  static Insertable<Sample> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? mrId,
    Expression<String>? doctorId,
    Expression<int>? quantity,
    Expression<DateTime>? date,
    Expression<String>? batchNo,
    Expression<DateTime>? expiryDate,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (mrId != null) 'mr_id': mrId,
      if (doctorId != null) 'doctor_id': doctorId,
      if (quantity != null) 'quantity': quantity,
      if (date != null) 'date': date,
      if (batchNo != null) 'batch_no': batchNo,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SamplesCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? mrId,
    Value<String>? doctorId,
    Value<int>? quantity,
    Value<DateTime>? date,
    Value<String>? batchNo,
    Value<DateTime?>? expiryDate,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return SamplesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      mrId: mrId ?? this.mrId,
      doctorId: doctorId ?? this.doctorId,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      batchNo: batchNo ?? this.batchNo,
      expiryDate: expiryDate ?? this.expiryDate,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (batchNo.present) {
      map['batch_no'] = Variable<String>(batchNo.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SamplesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mrId: $mrId, ')
          ..write('doctorId: $doctorId, ')
          ..write('quantity: $quantity, ')
          ..write('date: $date, ')
          ..write('batchNo: $batchNo, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OrderStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<OrderStatus>($OrdersTable.$converterstatus);
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _orderDateMeta = const VerificationMeta(
    'orderDate',
  );
  @override
  late final GeneratedColumn<DateTime> orderDate = GeneratedColumn<DateTime>(
    'order_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryDateMeta = const VerificationMeta(
    'deliveryDate',
  );
  @override
  late final GeneratedColumn<DateTime> deliveryDate = GeneratedColumn<DateTime>(
    'delivery_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mrId,
    doctorId,
    status,
    totalAmount,
    orderDate,
    deliveryDate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorIdMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('order_date')) {
      context.handle(
        _orderDateMeta,
        orderDate.isAcceptableOrUnknown(data['order_date']!, _orderDateMeta),
      );
    } else if (isInserting) {
      context.missing(_orderDateMeta);
    }
    if (data.containsKey('delivery_date')) {
      context.handle(
        _deliveryDateMeta,
        deliveryDate.isAcceptableOrUnknown(
          data['delivery_date']!,
          _deliveryDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      )!,
      status: $OrdersTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      orderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}order_date'],
      )!,
      deliveryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivery_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrderStatus, int, int> $converterstatus =
      const EnumIndexConverter<OrderStatus>(OrderStatus.values);
}

class Order extends DataClass implements Insertable<Order> {
  final String id;
  final String mrId;
  final String doctorId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String notes;
  const Order({
    required this.id,
    required this.mrId,
    required this.doctorId,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.deliveryDate,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mr_id'] = Variable<String>(mrId);
    map['doctor_id'] = Variable<String>(doctorId);
    {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status),
      );
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['order_date'] = Variable<DateTime>(orderDate);
    if (!nullToAbsent || deliveryDate != null) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate);
    }
    map['notes'] = Variable<String>(notes);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      mrId: Value(mrId),
      doctorId: Value(doctorId),
      status: Value(status),
      totalAmount: Value(totalAmount),
      orderDate: Value(orderDate),
      deliveryDate: deliveryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryDate),
      notes: Value(notes),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<String>(json['id']),
      mrId: serializer.fromJson<String>(json['mrId']),
      doctorId: serializer.fromJson<String>(json['doctorId']),
      status: $OrdersTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      orderDate: serializer.fromJson<DateTime>(json['orderDate']),
      deliveryDate: serializer.fromJson<DateTime?>(json['deliveryDate']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mrId': serializer.toJson<String>(mrId),
      'doctorId': serializer.toJson<String>(doctorId),
      'status': serializer.toJson<int>(
        $OrdersTable.$converterstatus.toJson(status),
      ),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'orderDate': serializer.toJson<DateTime>(orderDate),
      'deliveryDate': serializer.toJson<DateTime?>(deliveryDate),
      'notes': serializer.toJson<String>(notes),
    };
  }

  Order copyWith({
    String? id,
    String? mrId,
    String? doctorId,
    OrderStatus? status,
    double? totalAmount,
    DateTime? orderDate,
    Value<DateTime?> deliveryDate = const Value.absent(),
    String? notes,
  }) => Order(
    id: id ?? this.id,
    mrId: mrId ?? this.mrId,
    doctorId: doctorId ?? this.doctorId,
    status: status ?? this.status,
    totalAmount: totalAmount ?? this.totalAmount,
    orderDate: orderDate ?? this.orderDate,
    deliveryDate: deliveryDate.present ? deliveryDate.value : this.deliveryDate,
    notes: notes ?? this.notes,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      status: data.status.present ? data.status.value : this.status,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      orderDate: data.orderDate.present ? data.orderDate.value : this.orderDate,
      deliveryDate: data.deliveryDate.present
          ? data.deliveryDate.value
          : this.deliveryDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('doctorId: $doctorId, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('orderDate: $orderDate, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mrId,
    doctorId,
    status,
    totalAmount,
    orderDate,
    deliveryDate,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.mrId == this.mrId &&
          other.doctorId == this.doctorId &&
          other.status == this.status &&
          other.totalAmount == this.totalAmount &&
          other.orderDate == this.orderDate &&
          other.deliveryDate == this.deliveryDate &&
          other.notes == this.notes);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> id;
  final Value<String> mrId;
  final Value<String> doctorId;
  final Value<OrderStatus> status;
  final Value<double> totalAmount;
  final Value<DateTime> orderDate;
  final Value<DateTime?> deliveryDate;
  final Value<String> notes;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.mrId = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.status = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.orderDate = const Value.absent(),
    this.deliveryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String id,
    required String mrId,
    required String doctorId,
    required OrderStatus status,
    this.totalAmount = const Value.absent(),
    required DateTime orderDate,
    this.deliveryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mrId = Value(mrId),
       doctorId = Value(doctorId),
       status = Value(status),
       orderDate = Value(orderDate);
  static Insertable<Order> custom({
    Expression<String>? id,
    Expression<String>? mrId,
    Expression<String>? doctorId,
    Expression<int>? status,
    Expression<double>? totalAmount,
    Expression<DateTime>? orderDate,
    Expression<DateTime>? deliveryDate,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mrId != null) 'mr_id': mrId,
      if (doctorId != null) 'doctor_id': doctorId,
      if (status != null) 'status': status,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (orderDate != null) 'order_date': orderDate,
      if (deliveryDate != null) 'delivery_date': deliveryDate,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? mrId,
    Value<String>? doctorId,
    Value<OrderStatus>? status,
    Value<double>? totalAmount,
    Value<DateTime>? orderDate,
    Value<DateTime?>? deliveryDate,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status.value),
      );
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (orderDate.present) {
      map['order_date'] = Variable<DateTime>(orderDate.value);
    }
    if (deliveryDate.present) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('doctorId: $doctorId, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('orderDate: $orderDate, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    quantity,
    price,
    discount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount'],
      )!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double price;
  final double discount;
  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.discount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    map['discount'] = Variable<double>(discount);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      quantity: Value(quantity),
      price: Value(price),
      discount: Value(discount),
    );
  }

  factory OrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      discount: serializer.fromJson<double>(json['discount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
      'discount': serializer.toJson<double>(discount),
    };
  }

  OrderItem copyWith({
    String? id,
    String? orderId,
    String? productId,
    int? quantity,
    double? price,
    double? discount,
  }) => OrderItem(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    discount: discount ?? this.discount,
  );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      discount: data.discount.present ? data.discount.value : this.discount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('discount: $discount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, productId, quantity, price, discount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.discount == this.discount);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<int> quantity;
  final Value<double> price;
  final Value<double> discount;
  final Value<int> rowid;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.discount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    required String id,
    required String orderId,
    required String productId,
    required int quantity,
    required double price,
    this.discount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderId = Value(orderId),
       productId = Value(productId),
       quantity = Value(quantity),
       price = Value(price);
  static Insertable<OrderItem> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<double>? price,
    Expression<double>? discount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (discount != null) 'discount': discount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? productId,
    Value<int>? quantity,
    Value<double>? price,
    Value<double>? discount,
    Value<int>? rowid,
  }) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('discount: $discount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TourPlansTable extends TourPlans
    with TableInfo<$TourPlansTable, TourPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TourPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mrId,
    month,
    year,
    status,
    approvedBy,
    submittedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tour_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<TourPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TourPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TourPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TourPlansTable createAlias(String alias) {
    return $TourPlansTable(attachedDatabase, alias);
  }
}

class TourPlan extends DataClass implements Insertable<TourPlan> {
  final String id;
  final String mrId;
  final int month;
  final int year;
  final String status;
  final String approvedBy;
  final DateTime? submittedAt;
  final DateTime createdAt;
  const TourPlan({
    required this.id,
    required this.mrId,
    required this.month,
    required this.year,
    required this.status,
    required this.approvedBy,
    this.submittedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mr_id'] = Variable<String>(mrId);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['status'] = Variable<String>(status);
    map['approved_by'] = Variable<String>(approvedBy);
    if (!nullToAbsent || submittedAt != null) {
      map['submitted_at'] = Variable<DateTime>(submittedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TourPlansCompanion toCompanion(bool nullToAbsent) {
    return TourPlansCompanion(
      id: Value(id),
      mrId: Value(mrId),
      month: Value(month),
      year: Value(year),
      status: Value(status),
      approvedBy: Value(approvedBy),
      submittedAt: submittedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedAt),
      createdAt: Value(createdAt),
    );
  }

  factory TourPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TourPlan(
      id: serializer.fromJson<String>(json['id']),
      mrId: serializer.fromJson<String>(json['mrId']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      status: serializer.fromJson<String>(json['status']),
      approvedBy: serializer.fromJson<String>(json['approvedBy']),
      submittedAt: serializer.fromJson<DateTime?>(json['submittedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mrId': serializer.toJson<String>(mrId),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'status': serializer.toJson<String>(status),
      'approvedBy': serializer.toJson<String>(approvedBy),
      'submittedAt': serializer.toJson<DateTime?>(submittedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TourPlan copyWith({
    String? id,
    String? mrId,
    int? month,
    int? year,
    String? status,
    String? approvedBy,
    Value<DateTime?> submittedAt = const Value.absent(),
    DateTime? createdAt,
  }) => TourPlan(
    id: id ?? this.id,
    mrId: mrId ?? this.mrId,
    month: month ?? this.month,
    year: year ?? this.year,
    status: status ?? this.status,
    approvedBy: approvedBy ?? this.approvedBy,
    submittedAt: submittedAt.present ? submittedAt.value : this.submittedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  TourPlan copyWithCompanion(TourPlansCompanion data) {
    return TourPlan(
      id: data.id.present ? data.id.value : this.id,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      status: data.status.present ? data.status.value : this.status,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TourPlan(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mrId,
    month,
    year,
    status,
    approvedBy,
    submittedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TourPlan &&
          other.id == this.id &&
          other.mrId == this.mrId &&
          other.month == this.month &&
          other.year == this.year &&
          other.status == this.status &&
          other.approvedBy == this.approvedBy &&
          other.submittedAt == this.submittedAt &&
          other.createdAt == this.createdAt);
}

class TourPlansCompanion extends UpdateCompanion<TourPlan> {
  final Value<String> id;
  final Value<String> mrId;
  final Value<int> month;
  final Value<int> year;
  final Value<String> status;
  final Value<String> approvedBy;
  final Value<DateTime?> submittedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TourPlansCompanion({
    this.id = const Value.absent(),
    this.mrId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.status = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TourPlansCompanion.insert({
    required String id,
    required String mrId,
    required int month,
    required int year,
    this.status = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mrId = Value(mrId),
       month = Value(month),
       year = Value(year);
  static Insertable<TourPlan> custom({
    Expression<String>? id,
    Expression<String>? mrId,
    Expression<int>? month,
    Expression<int>? year,
    Expression<String>? status,
    Expression<String>? approvedBy,
    Expression<DateTime>? submittedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mrId != null) 'mr_id': mrId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (status != null) 'status': status,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TourPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? mrId,
    Value<int>? month,
    Value<int>? year,
    Value<String>? status,
    Value<String>? approvedBy,
    Value<DateTime?>? submittedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TourPlansCompanion(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      month: month ?? this.month,
      year: year ?? this.year,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      submittedAt: submittedAt ?? this.submittedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TourPlansCompanion(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TourPlanDaysTable extends TourPlanDays
    with TableInfo<$TourPlanDaysTable, TourPlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TourPlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tourPlanIdMeta = const VerificationMeta(
    'tourPlanId',
  );
  @override
  late final GeneratedColumn<String> tourPlanId = GeneratedColumn<String>(
    'tour_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorIdsMeta = const VerificationMeta(
    'doctorIds',
  );
  @override
  late final GeneratedColumn<String> doctorIds = GeneratedColumn<String>(
    'doctor_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tourPlanId,
    date,
    doctorIds,
    notes,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tour_plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<TourPlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tour_plan_id')) {
      context.handle(
        _tourPlanIdMeta,
        tourPlanId.isAcceptableOrUnknown(
          data['tour_plan_id']!,
          _tourPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tourPlanIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('doctor_ids')) {
      context.handle(
        _doctorIdsMeta,
        doctorIds.isAcceptableOrUnknown(data['doctor_ids']!, _doctorIdsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TourPlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TourPlanDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tourPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tour_plan_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      doctorIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_ids'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $TourPlanDaysTable createAlias(String alias) {
    return $TourPlanDaysTable(attachedDatabase, alias);
  }
}

class TourPlanDay extends DataClass implements Insertable<TourPlanDay> {
  final String id;
  final String tourPlanId;
  final DateTime date;
  final String doctorIds;
  final String notes;
  final bool isCompleted;
  const TourPlanDay({
    required this.id,
    required this.tourPlanId,
    required this.date,
    required this.doctorIds,
    required this.notes,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tour_plan_id'] = Variable<String>(tourPlanId);
    map['date'] = Variable<DateTime>(date);
    map['doctor_ids'] = Variable<String>(doctorIds);
    map['notes'] = Variable<String>(notes);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  TourPlanDaysCompanion toCompanion(bool nullToAbsent) {
    return TourPlanDaysCompanion(
      id: Value(id),
      tourPlanId: Value(tourPlanId),
      date: Value(date),
      doctorIds: Value(doctorIds),
      notes: Value(notes),
      isCompleted: Value(isCompleted),
    );
  }

  factory TourPlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TourPlanDay(
      id: serializer.fromJson<String>(json['id']),
      tourPlanId: serializer.fromJson<String>(json['tourPlanId']),
      date: serializer.fromJson<DateTime>(json['date']),
      doctorIds: serializer.fromJson<String>(json['doctorIds']),
      notes: serializer.fromJson<String>(json['notes']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tourPlanId': serializer.toJson<String>(tourPlanId),
      'date': serializer.toJson<DateTime>(date),
      'doctorIds': serializer.toJson<String>(doctorIds),
      'notes': serializer.toJson<String>(notes),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  TourPlanDay copyWith({
    String? id,
    String? tourPlanId,
    DateTime? date,
    String? doctorIds,
    String? notes,
    bool? isCompleted,
  }) => TourPlanDay(
    id: id ?? this.id,
    tourPlanId: tourPlanId ?? this.tourPlanId,
    date: date ?? this.date,
    doctorIds: doctorIds ?? this.doctorIds,
    notes: notes ?? this.notes,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  TourPlanDay copyWithCompanion(TourPlanDaysCompanion data) {
    return TourPlanDay(
      id: data.id.present ? data.id.value : this.id,
      tourPlanId: data.tourPlanId.present
          ? data.tourPlanId.value
          : this.tourPlanId,
      date: data.date.present ? data.date.value : this.date,
      doctorIds: data.doctorIds.present ? data.doctorIds.value : this.doctorIds,
      notes: data.notes.present ? data.notes.value : this.notes,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TourPlanDay(')
          ..write('id: $id, ')
          ..write('tourPlanId: $tourPlanId, ')
          ..write('date: $date, ')
          ..write('doctorIds: $doctorIds, ')
          ..write('notes: $notes, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tourPlanId, date, doctorIds, notes, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TourPlanDay &&
          other.id == this.id &&
          other.tourPlanId == this.tourPlanId &&
          other.date == this.date &&
          other.doctorIds == this.doctorIds &&
          other.notes == this.notes &&
          other.isCompleted == this.isCompleted);
}

class TourPlanDaysCompanion extends UpdateCompanion<TourPlanDay> {
  final Value<String> id;
  final Value<String> tourPlanId;
  final Value<DateTime> date;
  final Value<String> doctorIds;
  final Value<String> notes;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const TourPlanDaysCompanion({
    this.id = const Value.absent(),
    this.tourPlanId = const Value.absent(),
    this.date = const Value.absent(),
    this.doctorIds = const Value.absent(),
    this.notes = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TourPlanDaysCompanion.insert({
    required String id,
    required String tourPlanId,
    required DateTime date,
    this.doctorIds = const Value.absent(),
    this.notes = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tourPlanId = Value(tourPlanId),
       date = Value(date);
  static Insertable<TourPlanDay> custom({
    Expression<String>? id,
    Expression<String>? tourPlanId,
    Expression<DateTime>? date,
    Expression<String>? doctorIds,
    Expression<String>? notes,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tourPlanId != null) 'tour_plan_id': tourPlanId,
      if (date != null) 'date': date,
      if (doctorIds != null) 'doctor_ids': doctorIds,
      if (notes != null) 'notes': notes,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TourPlanDaysCompanion copyWith({
    Value<String>? id,
    Value<String>? tourPlanId,
    Value<DateTime>? date,
    Value<String>? doctorIds,
    Value<String>? notes,
    Value<bool>? isCompleted,
    Value<int>? rowid,
  }) {
    return TourPlanDaysCompanion(
      id: id ?? this.id,
      tourPlanId: tourPlanId ?? this.tourPlanId,
      date: date ?? this.date,
      doctorIds: doctorIds ?? this.doctorIds,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tourPlanId.present) {
      map['tour_plan_id'] = Variable<String>(tourPlanId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (doctorIds.present) {
      map['doctor_ids'] = Variable<String>(doctorIds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TourPlanDaysCompanion(')
          ..write('id: $id, ')
          ..write('tourPlanId: $tourPlanId, ')
          ..write('date: $date, ')
          ..write('doctorIds: $doctorIds, ')
          ..write('notes: $notes, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendancesTable extends Attendances
    with TableInfo<$AttendancesTable, Attendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _punchInTimeMeta = const VerificationMeta(
    'punchInTime',
  );
  @override
  late final GeneratedColumn<DateTime> punchInTime = GeneratedColumn<DateTime>(
    'punch_in_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _punchInLatMeta = const VerificationMeta(
    'punchInLat',
  );
  @override
  late final GeneratedColumn<double> punchInLat = GeneratedColumn<double>(
    'punch_in_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _punchInLngMeta = const VerificationMeta(
    'punchInLng',
  );
  @override
  late final GeneratedColumn<double> punchInLng = GeneratedColumn<double>(
    'punch_in_lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _punchInSelfieMeta = const VerificationMeta(
    'punchInSelfie',
  );
  @override
  late final GeneratedColumn<String> punchInSelfie = GeneratedColumn<String>(
    'punch_in_selfie',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _punchOutTimeMeta = const VerificationMeta(
    'punchOutTime',
  );
  @override
  late final GeneratedColumn<DateTime> punchOutTime = GeneratedColumn<DateTime>(
    'punch_out_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _punchOutLatMeta = const VerificationMeta(
    'punchOutLat',
  );
  @override
  late final GeneratedColumn<double> punchOutLat = GeneratedColumn<double>(
    'punch_out_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _punchOutLngMeta = const VerificationMeta(
    'punchOutLng',
  );
  @override
  late final GeneratedColumn<double> punchOutLng = GeneratedColumn<double>(
    'punch_out_lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AttendanceStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AttendanceStatus>($AttendancesTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mrId,
    date,
    punchInTime,
    punchInLat,
    punchInLng,
    punchInSelfie,
    punchOutTime,
    punchOutLat,
    punchOutLng,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attendance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('punch_in_time')) {
      context.handle(
        _punchInTimeMeta,
        punchInTime.isAcceptableOrUnknown(
          data['punch_in_time']!,
          _punchInTimeMeta,
        ),
      );
    }
    if (data.containsKey('punch_in_lat')) {
      context.handle(
        _punchInLatMeta,
        punchInLat.isAcceptableOrUnknown(
          data['punch_in_lat']!,
          _punchInLatMeta,
        ),
      );
    }
    if (data.containsKey('punch_in_lng')) {
      context.handle(
        _punchInLngMeta,
        punchInLng.isAcceptableOrUnknown(
          data['punch_in_lng']!,
          _punchInLngMeta,
        ),
      );
    }
    if (data.containsKey('punch_in_selfie')) {
      context.handle(
        _punchInSelfieMeta,
        punchInSelfie.isAcceptableOrUnknown(
          data['punch_in_selfie']!,
          _punchInSelfieMeta,
        ),
      );
    }
    if (data.containsKey('punch_out_time')) {
      context.handle(
        _punchOutTimeMeta,
        punchOutTime.isAcceptableOrUnknown(
          data['punch_out_time']!,
          _punchOutTimeMeta,
        ),
      );
    }
    if (data.containsKey('punch_out_lat')) {
      context.handle(
        _punchOutLatMeta,
        punchOutLat.isAcceptableOrUnknown(
          data['punch_out_lat']!,
          _punchOutLatMeta,
        ),
      );
    }
    if (data.containsKey('punch_out_lng')) {
      context.handle(
        _punchOutLngMeta,
        punchOutLng.isAcceptableOrUnknown(
          data['punch_out_lng']!,
          _punchOutLngMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attendance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      punchInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}punch_in_time'],
      ),
      punchInLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}punch_in_lat'],
      )!,
      punchInLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}punch_in_lng'],
      )!,
      punchInSelfie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}punch_in_selfie'],
      )!,
      punchOutTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}punch_out_time'],
      ),
      punchOutLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}punch_out_lat'],
      )!,
      punchOutLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}punch_out_lng'],
      )!,
      status: $AttendancesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $AttendancesTable createAlias(String alias) {
    return $AttendancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AttendanceStatus, int, int> $converterstatus =
      const EnumIndexConverter<AttendanceStatus>(AttendanceStatus.values);
}

class Attendance extends DataClass implements Insertable<Attendance> {
  final String id;
  final String mrId;
  final DateTime date;
  final DateTime? punchInTime;
  final double punchInLat;
  final double punchInLng;
  final String punchInSelfie;
  final DateTime? punchOutTime;
  final double punchOutLat;
  final double punchOutLng;
  final AttendanceStatus status;
  const Attendance({
    required this.id,
    required this.mrId,
    required this.date,
    this.punchInTime,
    required this.punchInLat,
    required this.punchInLng,
    required this.punchInSelfie,
    this.punchOutTime,
    required this.punchOutLat,
    required this.punchOutLng,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mr_id'] = Variable<String>(mrId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || punchInTime != null) {
      map['punch_in_time'] = Variable<DateTime>(punchInTime);
    }
    map['punch_in_lat'] = Variable<double>(punchInLat);
    map['punch_in_lng'] = Variable<double>(punchInLng);
    map['punch_in_selfie'] = Variable<String>(punchInSelfie);
    if (!nullToAbsent || punchOutTime != null) {
      map['punch_out_time'] = Variable<DateTime>(punchOutTime);
    }
    map['punch_out_lat'] = Variable<double>(punchOutLat);
    map['punch_out_lng'] = Variable<double>(punchOutLng);
    {
      map['status'] = Variable<int>(
        $AttendancesTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  AttendancesCompanion toCompanion(bool nullToAbsent) {
    return AttendancesCompanion(
      id: Value(id),
      mrId: Value(mrId),
      date: Value(date),
      punchInTime: punchInTime == null && nullToAbsent
          ? const Value.absent()
          : Value(punchInTime),
      punchInLat: Value(punchInLat),
      punchInLng: Value(punchInLng),
      punchInSelfie: Value(punchInSelfie),
      punchOutTime: punchOutTime == null && nullToAbsent
          ? const Value.absent()
          : Value(punchOutTime),
      punchOutLat: Value(punchOutLat),
      punchOutLng: Value(punchOutLng),
      status: Value(status),
    );
  }

  factory Attendance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attendance(
      id: serializer.fromJson<String>(json['id']),
      mrId: serializer.fromJson<String>(json['mrId']),
      date: serializer.fromJson<DateTime>(json['date']),
      punchInTime: serializer.fromJson<DateTime?>(json['punchInTime']),
      punchInLat: serializer.fromJson<double>(json['punchInLat']),
      punchInLng: serializer.fromJson<double>(json['punchInLng']),
      punchInSelfie: serializer.fromJson<String>(json['punchInSelfie']),
      punchOutTime: serializer.fromJson<DateTime?>(json['punchOutTime']),
      punchOutLat: serializer.fromJson<double>(json['punchOutLat']),
      punchOutLng: serializer.fromJson<double>(json['punchOutLng']),
      status: $AttendancesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mrId': serializer.toJson<String>(mrId),
      'date': serializer.toJson<DateTime>(date),
      'punchInTime': serializer.toJson<DateTime?>(punchInTime),
      'punchInLat': serializer.toJson<double>(punchInLat),
      'punchInLng': serializer.toJson<double>(punchInLng),
      'punchInSelfie': serializer.toJson<String>(punchInSelfie),
      'punchOutTime': serializer.toJson<DateTime?>(punchOutTime),
      'punchOutLat': serializer.toJson<double>(punchOutLat),
      'punchOutLng': serializer.toJson<double>(punchOutLng),
      'status': serializer.toJson<int>(
        $AttendancesTable.$converterstatus.toJson(status),
      ),
    };
  }

  Attendance copyWith({
    String? id,
    String? mrId,
    DateTime? date,
    Value<DateTime?> punchInTime = const Value.absent(),
    double? punchInLat,
    double? punchInLng,
    String? punchInSelfie,
    Value<DateTime?> punchOutTime = const Value.absent(),
    double? punchOutLat,
    double? punchOutLng,
    AttendanceStatus? status,
  }) => Attendance(
    id: id ?? this.id,
    mrId: mrId ?? this.mrId,
    date: date ?? this.date,
    punchInTime: punchInTime.present ? punchInTime.value : this.punchInTime,
    punchInLat: punchInLat ?? this.punchInLat,
    punchInLng: punchInLng ?? this.punchInLng,
    punchInSelfie: punchInSelfie ?? this.punchInSelfie,
    punchOutTime: punchOutTime.present ? punchOutTime.value : this.punchOutTime,
    punchOutLat: punchOutLat ?? this.punchOutLat,
    punchOutLng: punchOutLng ?? this.punchOutLng,
    status: status ?? this.status,
  );
  Attendance copyWithCompanion(AttendancesCompanion data) {
    return Attendance(
      id: data.id.present ? data.id.value : this.id,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      date: data.date.present ? data.date.value : this.date,
      punchInTime: data.punchInTime.present
          ? data.punchInTime.value
          : this.punchInTime,
      punchInLat: data.punchInLat.present
          ? data.punchInLat.value
          : this.punchInLat,
      punchInLng: data.punchInLng.present
          ? data.punchInLng.value
          : this.punchInLng,
      punchInSelfie: data.punchInSelfie.present
          ? data.punchInSelfie.value
          : this.punchInSelfie,
      punchOutTime: data.punchOutTime.present
          ? data.punchOutTime.value
          : this.punchOutTime,
      punchOutLat: data.punchOutLat.present
          ? data.punchOutLat.value
          : this.punchOutLat,
      punchOutLng: data.punchOutLng.present
          ? data.punchOutLng.value
          : this.punchOutLng,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attendance(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('date: $date, ')
          ..write('punchInTime: $punchInTime, ')
          ..write('punchInLat: $punchInLat, ')
          ..write('punchInLng: $punchInLng, ')
          ..write('punchInSelfie: $punchInSelfie, ')
          ..write('punchOutTime: $punchOutTime, ')
          ..write('punchOutLat: $punchOutLat, ')
          ..write('punchOutLng: $punchOutLng, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mrId,
    date,
    punchInTime,
    punchInLat,
    punchInLng,
    punchInSelfie,
    punchOutTime,
    punchOutLat,
    punchOutLng,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attendance &&
          other.id == this.id &&
          other.mrId == this.mrId &&
          other.date == this.date &&
          other.punchInTime == this.punchInTime &&
          other.punchInLat == this.punchInLat &&
          other.punchInLng == this.punchInLng &&
          other.punchInSelfie == this.punchInSelfie &&
          other.punchOutTime == this.punchOutTime &&
          other.punchOutLat == this.punchOutLat &&
          other.punchOutLng == this.punchOutLng &&
          other.status == this.status);
}

class AttendancesCompanion extends UpdateCompanion<Attendance> {
  final Value<String> id;
  final Value<String> mrId;
  final Value<DateTime> date;
  final Value<DateTime?> punchInTime;
  final Value<double> punchInLat;
  final Value<double> punchInLng;
  final Value<String> punchInSelfie;
  final Value<DateTime?> punchOutTime;
  final Value<double> punchOutLat;
  final Value<double> punchOutLng;
  final Value<AttendanceStatus> status;
  final Value<int> rowid;
  const AttendancesCompanion({
    this.id = const Value.absent(),
    this.mrId = const Value.absent(),
    this.date = const Value.absent(),
    this.punchInTime = const Value.absent(),
    this.punchInLat = const Value.absent(),
    this.punchInLng = const Value.absent(),
    this.punchInSelfie = const Value.absent(),
    this.punchOutTime = const Value.absent(),
    this.punchOutLat = const Value.absent(),
    this.punchOutLng = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendancesCompanion.insert({
    required String id,
    required String mrId,
    required DateTime date,
    this.punchInTime = const Value.absent(),
    this.punchInLat = const Value.absent(),
    this.punchInLng = const Value.absent(),
    this.punchInSelfie = const Value.absent(),
    this.punchOutTime = const Value.absent(),
    this.punchOutLat = const Value.absent(),
    this.punchOutLng = const Value.absent(),
    required AttendanceStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mrId = Value(mrId),
       date = Value(date),
       status = Value(status);
  static Insertable<Attendance> custom({
    Expression<String>? id,
    Expression<String>? mrId,
    Expression<DateTime>? date,
    Expression<DateTime>? punchInTime,
    Expression<double>? punchInLat,
    Expression<double>? punchInLng,
    Expression<String>? punchInSelfie,
    Expression<DateTime>? punchOutTime,
    Expression<double>? punchOutLat,
    Expression<double>? punchOutLng,
    Expression<int>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mrId != null) 'mr_id': mrId,
      if (date != null) 'date': date,
      if (punchInTime != null) 'punch_in_time': punchInTime,
      if (punchInLat != null) 'punch_in_lat': punchInLat,
      if (punchInLng != null) 'punch_in_lng': punchInLng,
      if (punchInSelfie != null) 'punch_in_selfie': punchInSelfie,
      if (punchOutTime != null) 'punch_out_time': punchOutTime,
      if (punchOutLat != null) 'punch_out_lat': punchOutLat,
      if (punchOutLng != null) 'punch_out_lng': punchOutLng,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendancesCompanion copyWith({
    Value<String>? id,
    Value<String>? mrId,
    Value<DateTime>? date,
    Value<DateTime?>? punchInTime,
    Value<double>? punchInLat,
    Value<double>? punchInLng,
    Value<String>? punchInSelfie,
    Value<DateTime?>? punchOutTime,
    Value<double>? punchOutLat,
    Value<double>? punchOutLng,
    Value<AttendanceStatus>? status,
    Value<int>? rowid,
  }) {
    return AttendancesCompanion(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      date: date ?? this.date,
      punchInTime: punchInTime ?? this.punchInTime,
      punchInLat: punchInLat ?? this.punchInLat,
      punchInLng: punchInLng ?? this.punchInLng,
      punchInSelfie: punchInSelfie ?? this.punchInSelfie,
      punchOutTime: punchOutTime ?? this.punchOutTime,
      punchOutLat: punchOutLat ?? this.punchOutLat,
      punchOutLng: punchOutLng ?? this.punchOutLng,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (punchInTime.present) {
      map['punch_in_time'] = Variable<DateTime>(punchInTime.value);
    }
    if (punchInLat.present) {
      map['punch_in_lat'] = Variable<double>(punchInLat.value);
    }
    if (punchInLng.present) {
      map['punch_in_lng'] = Variable<double>(punchInLng.value);
    }
    if (punchInSelfie.present) {
      map['punch_in_selfie'] = Variable<String>(punchInSelfie.value);
    }
    if (punchOutTime.present) {
      map['punch_out_time'] = Variable<DateTime>(punchOutTime.value);
    }
    if (punchOutLat.present) {
      map['punch_out_lat'] = Variable<double>(punchOutLat.value);
    }
    if (punchOutLng.present) {
      map['punch_out_lng'] = Variable<double>(punchOutLng.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $AttendancesTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesCompanion(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('date: $date, ')
          ..write('punchInTime: $punchInTime, ')
          ..write('punchInLat: $punchInLat, ')
          ..write('punchInLng: $punchInLng, ')
          ..write('punchInSelfie: $punchInSelfie, ')
          ..write('punchOutTime: $punchOutTime, ')
          ..write('punchOutLat: $punchOutLat, ')
          ..write('punchOutLng: $punchOutLng, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaveRequestsTable extends LeaveRequests
    with TableInfo<$LeaveRequestsTable, LeaveRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeaveType, int> leaveType =
      GeneratedColumn<int>(
        'leave_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LeaveType>($LeaveRequestsTable.$converterleaveType);
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ApprovalStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<ApprovalStatus>($LeaveRequestsTable.$converterstatus);
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _commentsMeta = const VerificationMeta(
    'comments',
  );
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
    'comments',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mrId,
    leaveType,
    startDate,
    endDate,
    reason,
    status,
    approvedBy,
    comments,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('comments')) {
      context.handle(
        _commentsMeta,
        comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      leaveType: $LeaveRequestsTable.$converterleaveType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}leave_type'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      status: $LeaveRequestsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      )!,
      comments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comments'],
      )!,
    );
  }

  @override
  $LeaveRequestsTable createAlias(String alias) {
    return $LeaveRequestsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeaveType, int, int> $converterleaveType =
      const EnumIndexConverter<LeaveType>(LeaveType.values);
  static JsonTypeConverter2<ApprovalStatus, int, int> $converterstatus =
      const EnumIndexConverter<ApprovalStatus>(ApprovalStatus.values);
}

class LeaveRequest extends DataClass implements Insertable<LeaveRequest> {
  final String id;
  final String mrId;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final ApprovalStatus status;
  final String approvedBy;
  final String comments;
  const LeaveRequest({
    required this.id,
    required this.mrId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.approvedBy,
    required this.comments,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mr_id'] = Variable<String>(mrId);
    {
      map['leave_type'] = Variable<int>(
        $LeaveRequestsTable.$converterleaveType.toSql(leaveType),
      );
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['reason'] = Variable<String>(reason);
    {
      map['status'] = Variable<int>(
        $LeaveRequestsTable.$converterstatus.toSql(status),
      );
    }
    map['approved_by'] = Variable<String>(approvedBy);
    map['comments'] = Variable<String>(comments);
    return map;
  }

  LeaveRequestsCompanion toCompanion(bool nullToAbsent) {
    return LeaveRequestsCompanion(
      id: Value(id),
      mrId: Value(mrId),
      leaveType: Value(leaveType),
      startDate: Value(startDate),
      endDate: Value(endDate),
      reason: Value(reason),
      status: Value(status),
      approvedBy: Value(approvedBy),
      comments: Value(comments),
    );
  }

  factory LeaveRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRequest(
      id: serializer.fromJson<String>(json['id']),
      mrId: serializer.fromJson<String>(json['mrId']),
      leaveType: $LeaveRequestsTable.$converterleaveType.fromJson(
        serializer.fromJson<int>(json['leaveType']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      reason: serializer.fromJson<String>(json['reason']),
      status: $LeaveRequestsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      approvedBy: serializer.fromJson<String>(json['approvedBy']),
      comments: serializer.fromJson<String>(json['comments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mrId': serializer.toJson<String>(mrId),
      'leaveType': serializer.toJson<int>(
        $LeaveRequestsTable.$converterleaveType.toJson(leaveType),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<int>(
        $LeaveRequestsTable.$converterstatus.toJson(status),
      ),
      'approvedBy': serializer.toJson<String>(approvedBy),
      'comments': serializer.toJson<String>(comments),
    };
  }

  LeaveRequest copyWith({
    String? id,
    String? mrId,
    LeaveType? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    ApprovalStatus? status,
    String? approvedBy,
    String? comments,
  }) => LeaveRequest(
    id: id ?? this.id,
    mrId: mrId ?? this.mrId,
    leaveType: leaveType ?? this.leaveType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    approvedBy: approvedBy ?? this.approvedBy,
    comments: comments ?? this.comments,
  );
  LeaveRequest copyWithCompanion(LeaveRequestsCompanion data) {
    return LeaveRequest(
      id: data.id.present ? data.id.value : this.id,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      leaveType: data.leaveType.present ? data.leaveType.value : this.leaveType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      comments: data.comments.present ? data.comments.value : this.comments,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRequest(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('comments: $comments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mrId,
    leaveType,
    startDate,
    endDate,
    reason,
    status,
    approvedBy,
    comments,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRequest &&
          other.id == this.id &&
          other.mrId == this.mrId &&
          other.leaveType == this.leaveType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.approvedBy == this.approvedBy &&
          other.comments == this.comments);
}

class LeaveRequestsCompanion extends UpdateCompanion<LeaveRequest> {
  final Value<String> id;
  final Value<String> mrId;
  final Value<LeaveType> leaveType;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> reason;
  final Value<ApprovalStatus> status;
  final Value<String> approvedBy;
  final Value<String> comments;
  final Value<int> rowid;
  const LeaveRequestsCompanion({
    this.id = const Value.absent(),
    this.mrId = const Value.absent(),
    this.leaveType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.comments = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeaveRequestsCompanion.insert({
    required String id,
    required String mrId,
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.comments = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mrId = Value(mrId),
       leaveType = Value(leaveType),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<LeaveRequest> custom({
    Expression<String>? id,
    Expression<String>? mrId,
    Expression<int>? leaveType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? reason,
    Expression<int>? status,
    Expression<String>? approvedBy,
    Expression<String>? comments,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mrId != null) 'mr_id': mrId,
      if (leaveType != null) 'leave_type': leaveType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (comments != null) 'comments': comments,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeaveRequestsCompanion copyWith({
    Value<String>? id,
    Value<String>? mrId,
    Value<LeaveType>? leaveType,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? reason,
    Value<ApprovalStatus>? status,
    Value<String>? approvedBy,
    Value<String>? comments,
    Value<int>? rowid,
  }) {
    return LeaveRequestsCompanion(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      comments: comments ?? this.comments,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (leaveType.present) {
      map['leave_type'] = Variable<int>(
        $LeaveRequestsTable.$converterleaveType.toSql(leaveType.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $LeaveRequestsTable.$converterstatus.toSql(status.value),
      );
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRequestsCompanion(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('comments: $comments, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaveBalancesTable extends LeaveBalances
    with TableInfo<$LeaveBalancesTable, LeaveBalance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveBalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeaveType, int> leaveType =
      GeneratedColumn<int>(
        'leave_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LeaveType>($LeaveBalancesTable.$converterleaveType);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _usedMeta = const VerificationMeta('used');
  @override
  late final GeneratedColumn<int> used = GeneratedColumn<int>(
    'used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remainingMeta = const VerificationMeta(
    'remaining',
  );
  @override
  late final GeneratedColumn<int> remaining = GeneratedColumn<int>(
    'remaining',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mrId,
    leaveType,
    total,
    used,
    remaining,
    year,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_balances';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveBalance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('used')) {
      context.handle(
        _usedMeta,
        used.isAcceptableOrUnknown(data['used']!, _usedMeta),
      );
    }
    if (data.containsKey('remaining')) {
      context.handle(
        _remainingMeta,
        remaining.isAcceptableOrUnknown(data['remaining']!, _remainingMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveBalance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveBalance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      leaveType: $LeaveBalancesTable.$converterleaveType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}leave_type'],
        )!,
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      used: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}used'],
      )!,
      remaining: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
    );
  }

  @override
  $LeaveBalancesTable createAlias(String alias) {
    return $LeaveBalancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeaveType, int, int> $converterleaveType =
      const EnumIndexConverter<LeaveType>(LeaveType.values);
}

class LeaveBalance extends DataClass implements Insertable<LeaveBalance> {
  final String id;
  final String mrId;
  final LeaveType leaveType;
  final int total;
  final int used;
  final int remaining;
  final int year;
  const LeaveBalance({
    required this.id,
    required this.mrId,
    required this.leaveType,
    required this.total,
    required this.used,
    required this.remaining,
    required this.year,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mr_id'] = Variable<String>(mrId);
    {
      map['leave_type'] = Variable<int>(
        $LeaveBalancesTable.$converterleaveType.toSql(leaveType),
      );
    }
    map['total'] = Variable<int>(total);
    map['used'] = Variable<int>(used);
    map['remaining'] = Variable<int>(remaining);
    map['year'] = Variable<int>(year);
    return map;
  }

  LeaveBalancesCompanion toCompanion(bool nullToAbsent) {
    return LeaveBalancesCompanion(
      id: Value(id),
      mrId: Value(mrId),
      leaveType: Value(leaveType),
      total: Value(total),
      used: Value(used),
      remaining: Value(remaining),
      year: Value(year),
    );
  }

  factory LeaveBalance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveBalance(
      id: serializer.fromJson<String>(json['id']),
      mrId: serializer.fromJson<String>(json['mrId']),
      leaveType: $LeaveBalancesTable.$converterleaveType.fromJson(
        serializer.fromJson<int>(json['leaveType']),
      ),
      total: serializer.fromJson<int>(json['total']),
      used: serializer.fromJson<int>(json['used']),
      remaining: serializer.fromJson<int>(json['remaining']),
      year: serializer.fromJson<int>(json['year']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mrId': serializer.toJson<String>(mrId),
      'leaveType': serializer.toJson<int>(
        $LeaveBalancesTable.$converterleaveType.toJson(leaveType),
      ),
      'total': serializer.toJson<int>(total),
      'used': serializer.toJson<int>(used),
      'remaining': serializer.toJson<int>(remaining),
      'year': serializer.toJson<int>(year),
    };
  }

  LeaveBalance copyWith({
    String? id,
    String? mrId,
    LeaveType? leaveType,
    int? total,
    int? used,
    int? remaining,
    int? year,
  }) => LeaveBalance(
    id: id ?? this.id,
    mrId: mrId ?? this.mrId,
    leaveType: leaveType ?? this.leaveType,
    total: total ?? this.total,
    used: used ?? this.used,
    remaining: remaining ?? this.remaining,
    year: year ?? this.year,
  );
  LeaveBalance copyWithCompanion(LeaveBalancesCompanion data) {
    return LeaveBalance(
      id: data.id.present ? data.id.value : this.id,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      leaveType: data.leaveType.present ? data.leaveType.value : this.leaveType,
      total: data.total.present ? data.total.value : this.total,
      used: data.used.present ? data.used.value : this.used,
      remaining: data.remaining.present ? data.remaining.value : this.remaining,
      year: data.year.present ? data.year.value : this.year,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveBalance(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('leaveType: $leaveType, ')
          ..write('total: $total, ')
          ..write('used: $used, ')
          ..write('remaining: $remaining, ')
          ..write('year: $year')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mrId, leaveType, total, used, remaining, year);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveBalance &&
          other.id == this.id &&
          other.mrId == this.mrId &&
          other.leaveType == this.leaveType &&
          other.total == this.total &&
          other.used == this.used &&
          other.remaining == this.remaining &&
          other.year == this.year);
}

class LeaveBalancesCompanion extends UpdateCompanion<LeaveBalance> {
  final Value<String> id;
  final Value<String> mrId;
  final Value<LeaveType> leaveType;
  final Value<int> total;
  final Value<int> used;
  final Value<int> remaining;
  final Value<int> year;
  final Value<int> rowid;
  const LeaveBalancesCompanion({
    this.id = const Value.absent(),
    this.mrId = const Value.absent(),
    this.leaveType = const Value.absent(),
    this.total = const Value.absent(),
    this.used = const Value.absent(),
    this.remaining = const Value.absent(),
    this.year = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeaveBalancesCompanion.insert({
    required String id,
    required String mrId,
    required LeaveType leaveType,
    this.total = const Value.absent(),
    this.used = const Value.absent(),
    this.remaining = const Value.absent(),
    required int year,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mrId = Value(mrId),
       leaveType = Value(leaveType),
       year = Value(year);
  static Insertable<LeaveBalance> custom({
    Expression<String>? id,
    Expression<String>? mrId,
    Expression<int>? leaveType,
    Expression<int>? total,
    Expression<int>? used,
    Expression<int>? remaining,
    Expression<int>? year,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mrId != null) 'mr_id': mrId,
      if (leaveType != null) 'leave_type': leaveType,
      if (total != null) 'total': total,
      if (used != null) 'used': used,
      if (remaining != null) 'remaining': remaining,
      if (year != null) 'year': year,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeaveBalancesCompanion copyWith({
    Value<String>? id,
    Value<String>? mrId,
    Value<LeaveType>? leaveType,
    Value<int>? total,
    Value<int>? used,
    Value<int>? remaining,
    Value<int>? year,
    Value<int>? rowid,
  }) {
    return LeaveBalancesCompanion(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      leaveType: leaveType ?? this.leaveType,
      total: total ?? this.total,
      used: used ?? this.used,
      remaining: remaining ?? this.remaining,
      year: year ?? this.year,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (leaveType.present) {
      map['leave_type'] = Variable<int>(
        $LeaveBalancesTable.$converterleaveType.toSql(leaveType.value),
      );
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (used.present) {
      map['used'] = Variable<int>(used.value);
    }
    if (remaining.present) {
      map['remaining'] = Variable<int>(remaining.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveBalancesCompanion(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('leaveType: $leaveType, ')
          ..write('total: $total, ')
          ..write('used: $used, ')
          ..write('remaining: $remaining, ')
          ..write('year: $year, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ApprovalsTable extends Approvals
    with TableInfo<$ApprovalsTable, Approval> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApprovalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ApprovalEntityType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ApprovalEntityType>($ApprovalsTable.$convertertype);
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requesterIdMeta = const VerificationMeta(
    'requesterId',
  );
  @override
  late final GeneratedColumn<String> requesterId = GeneratedColumn<String>(
    'requester_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approverIdMeta = const VerificationMeta(
    'approverId',
  );
  @override
  late final GeneratedColumn<String> approverId = GeneratedColumn<String>(
    'approver_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ApprovalStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<ApprovalStatus>($ApprovalsTable.$converterstatus);
  static const VerificationMeta _commentsMeta = const VerificationMeta(
    'comments',
  );
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
    'comments',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    referenceId,
    requesterId,
    approverId,
    status,
    comments,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'approvals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Approval> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('requester_id')) {
      context.handle(
        _requesterIdMeta,
        requesterId.isAcceptableOrUnknown(
          data['requester_id']!,
          _requesterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requesterIdMeta);
    }
    if (data.containsKey('approver_id')) {
      context.handle(
        _approverIdMeta,
        approverId.isAcceptableOrUnknown(data['approver_id']!, _approverIdMeta),
      );
    }
    if (data.containsKey('comments')) {
      context.handle(
        _commentsMeta,
        comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Approval map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Approval(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: $ApprovalsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      requesterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester_id'],
      )!,
      approverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approver_id'],
      )!,
      status: $ApprovalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      comments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comments'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ApprovalsTable createAlias(String alias) {
    return $ApprovalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ApprovalEntityType, int, int> $convertertype =
      const EnumIndexConverter<ApprovalEntityType>(ApprovalEntityType.values);
  static JsonTypeConverter2<ApprovalStatus, int, int> $converterstatus =
      const EnumIndexConverter<ApprovalStatus>(ApprovalStatus.values);
}

class Approval extends DataClass implements Insertable<Approval> {
  final String id;
  final ApprovalEntityType type;
  final String referenceId;
  final String requesterId;
  final String approverId;
  final ApprovalStatus status;
  final String comments;
  final DateTime createdAt;
  const Approval({
    required this.id,
    required this.type,
    required this.referenceId,
    required this.requesterId,
    required this.approverId,
    required this.status,
    required this.comments,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['type'] = Variable<int>($ApprovalsTable.$convertertype.toSql(type));
    }
    map['reference_id'] = Variable<String>(referenceId);
    map['requester_id'] = Variable<String>(requesterId);
    map['approver_id'] = Variable<String>(approverId);
    {
      map['status'] = Variable<int>(
        $ApprovalsTable.$converterstatus.toSql(status),
      );
    }
    map['comments'] = Variable<String>(comments);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ApprovalsCompanion toCompanion(bool nullToAbsent) {
    return ApprovalsCompanion(
      id: Value(id),
      type: Value(type),
      referenceId: Value(referenceId),
      requesterId: Value(requesterId),
      approverId: Value(approverId),
      status: Value(status),
      comments: Value(comments),
      createdAt: Value(createdAt),
    );
  }

  factory Approval.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Approval(
      id: serializer.fromJson<String>(json['id']),
      type: $ApprovalsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      requesterId: serializer.fromJson<String>(json['requesterId']),
      approverId: serializer.fromJson<String>(json['approverId']),
      status: $ApprovalsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      comments: serializer.fromJson<String>(json['comments']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<int>(
        $ApprovalsTable.$convertertype.toJson(type),
      ),
      'referenceId': serializer.toJson<String>(referenceId),
      'requesterId': serializer.toJson<String>(requesterId),
      'approverId': serializer.toJson<String>(approverId),
      'status': serializer.toJson<int>(
        $ApprovalsTable.$converterstatus.toJson(status),
      ),
      'comments': serializer.toJson<String>(comments),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Approval copyWith({
    String? id,
    ApprovalEntityType? type,
    String? referenceId,
    String? requesterId,
    String? approverId,
    ApprovalStatus? status,
    String? comments,
    DateTime? createdAt,
  }) => Approval(
    id: id ?? this.id,
    type: type ?? this.type,
    referenceId: referenceId ?? this.referenceId,
    requesterId: requesterId ?? this.requesterId,
    approverId: approverId ?? this.approverId,
    status: status ?? this.status,
    comments: comments ?? this.comments,
    createdAt: createdAt ?? this.createdAt,
  );
  Approval copyWithCompanion(ApprovalsCompanion data) {
    return Approval(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      requesterId: data.requesterId.present
          ? data.requesterId.value
          : this.requesterId,
      approverId: data.approverId.present
          ? data.approverId.value
          : this.approverId,
      status: data.status.present ? data.status.value : this.status,
      comments: data.comments.present ? data.comments.value : this.comments,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Approval(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('requesterId: $requesterId, ')
          ..write('approverId: $approverId, ')
          ..write('status: $status, ')
          ..write('comments: $comments, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    referenceId,
    requesterId,
    approverId,
    status,
    comments,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Approval &&
          other.id == this.id &&
          other.type == this.type &&
          other.referenceId == this.referenceId &&
          other.requesterId == this.requesterId &&
          other.approverId == this.approverId &&
          other.status == this.status &&
          other.comments == this.comments &&
          other.createdAt == this.createdAt);
}

class ApprovalsCompanion extends UpdateCompanion<Approval> {
  final Value<String> id;
  final Value<ApprovalEntityType> type;
  final Value<String> referenceId;
  final Value<String> requesterId;
  final Value<String> approverId;
  final Value<ApprovalStatus> status;
  final Value<String> comments;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ApprovalsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.requesterId = const Value.absent(),
    this.approverId = const Value.absent(),
    this.status = const Value.absent(),
    this.comments = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ApprovalsCompanion.insert({
    required String id,
    required ApprovalEntityType type,
    required String referenceId,
    required String requesterId,
    this.approverId = const Value.absent(),
    this.status = const Value.absent(),
    this.comments = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       referenceId = Value(referenceId),
       requesterId = Value(requesterId);
  static Insertable<Approval> custom({
    Expression<String>? id,
    Expression<int>? type,
    Expression<String>? referenceId,
    Expression<String>? requesterId,
    Expression<String>? approverId,
    Expression<int>? status,
    Expression<String>? comments,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (referenceId != null) 'reference_id': referenceId,
      if (requesterId != null) 'requester_id': requesterId,
      if (approverId != null) 'approver_id': approverId,
      if (status != null) 'status': status,
      if (comments != null) 'comments': comments,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ApprovalsCompanion copyWith({
    Value<String>? id,
    Value<ApprovalEntityType>? type,
    Value<String>? referenceId,
    Value<String>? requesterId,
    Value<String>? approverId,
    Value<ApprovalStatus>? status,
    Value<String>? comments,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ApprovalsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      requesterId: requesterId ?? this.requesterId,
      approverId: approverId ?? this.approverId,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $ApprovalsTable.$convertertype.toSql(type.value),
      );
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (requesterId.present) {
      map['requester_id'] = Variable<String>(requesterId.value);
    }
    if (approverId.present) {
      map['approver_id'] = Variable<String>(approverId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $ApprovalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApprovalsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('requesterId: $requesterId, ')
          ..write('approverId: $approverId, ')
          ..write('status: $status, ')
          ..write('comments: $comments, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, Notification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<NotificationType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<NotificationType>($NotificationsTable.$convertertype);
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    body,
    type,
    referenceId,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Notification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      type: $NotificationsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationType, int, int> $convertertype =
      const EnumIndexConverter<NotificationType>(NotificationType.values);
}

class Notification extends DataClass implements Insertable<Notification> {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final String referenceId;
  final bool isRead;
  final DateTime createdAt;
  const Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.referenceId,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    {
      map['type'] = Variable<int>(
        $NotificationsTable.$convertertype.toSql(type),
      );
    }
    map['reference_id'] = Variable<String>(referenceId);
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      body: Value(body),
      type: Value(type),
      referenceId: Value(referenceId),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory Notification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notification(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      type: $NotificationsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'type': serializer.toJson<int>(
        $NotificationsTable.$convertertype.toJson(type),
      ),
      'referenceId': serializer.toJson<String>(referenceId),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    String? referenceId,
    bool? isRead,
    DateTime? createdAt,
  }) => Notification(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    body: body ?? this.body,
    type: type ?? this.type,
    referenceId: referenceId ?? this.referenceId,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  Notification copyWithCompanion(NotificationsCompanion data) {
    return Notification(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      type: data.type.present ? data.type.value : this.type,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Notification(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    body,
    type,
    referenceId,
    isRead,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.body == this.body &&
          other.type == this.type &&
          other.referenceId == this.referenceId &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class NotificationsCompanion extends UpdateCompanion<Notification> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> body;
  final Value<NotificationType> type;
  final Value<String> referenceId;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.type = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    this.referenceId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       body = Value(body),
       type = Value(type);
  static Insertable<Notification> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? type,
    Expression<String>? referenceId,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (type != null) 'type': type,
      if (referenceId != null) 'reference_id': referenceId,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? body,
    Value<NotificationType>? type,
    Value<String>? referenceId,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NotificationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $NotificationsTable.$convertertype.toSql(type.value),
      );
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CampaignsTable extends Campaigns
    with TableInfo<$CampaignsTable, Campaign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CampaignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _targetDoctorsMeta = const VerificationMeta(
    'targetDoctors',
  );
  @override
  late final GeneratedColumn<String> targetDoctors = GeneratedColumn<String>(
    'target_doctors',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startDate,
    endDate,
    description,
    targetDoctors,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'campaigns';
  @override
  VerificationContext validateIntegrity(
    Insertable<Campaign> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('target_doctors')) {
      context.handle(
        _targetDoctorsMeta,
        targetDoctors.isAcceptableOrUnknown(
          data['target_doctors']!,
          _targetDoctorsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Campaign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Campaign(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      targetDoctors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_doctors'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $CampaignsTable createAlias(String alias) {
    return $CampaignsTable(attachedDatabase, alias);
  }
}

class Campaign extends DataClass implements Insertable<Campaign> {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String targetDoctors;
  final String status;
  const Campaign({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.targetDoctors,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['description'] = Variable<String>(description);
    map['target_doctors'] = Variable<String>(targetDoctors);
    map['status'] = Variable<String>(status);
    return map;
  }

  CampaignsCompanion toCompanion(bool nullToAbsent) {
    return CampaignsCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      description: Value(description),
      targetDoctors: Value(targetDoctors),
      status: Value(status),
    );
  }

  factory Campaign.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Campaign(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      description: serializer.fromJson<String>(json['description']),
      targetDoctors: serializer.fromJson<String>(json['targetDoctors']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'description': serializer.toJson<String>(description),
      'targetDoctors': serializer.toJson<String>(targetDoctors),
      'status': serializer.toJson<String>(status),
    };
  }

  Campaign copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? targetDoctors,
    String? status,
  }) => Campaign(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    description: description ?? this.description,
    targetDoctors: targetDoctors ?? this.targetDoctors,
    status: status ?? this.status,
  );
  Campaign copyWithCompanion(CampaignsCompanion data) {
    return Campaign(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      description: data.description.present
          ? data.description.value
          : this.description,
      targetDoctors: data.targetDoctors.present
          ? data.targetDoctors.value
          : this.targetDoctors,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Campaign(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('description: $description, ')
          ..write('targetDoctors: $targetDoctors, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    startDate,
    endDate,
    description,
    targetDoctors,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Campaign &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.description == this.description &&
          other.targetDoctors == this.targetDoctors &&
          other.status == this.status);
}

class CampaignsCompanion extends UpdateCompanion<Campaign> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> description;
  final Value<String> targetDoctors;
  final Value<String> status;
  final Value<int> rowid;
  const CampaignsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.description = const Value.absent(),
    this.targetDoctors = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CampaignsCompanion.insert({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    this.description = const Value.absent(),
    this.targetDoctors = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Campaign> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? description,
    Expression<String>? targetDoctors,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (description != null) 'description': description,
      if (targetDoctors != null) 'target_doctors': targetDoctors,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CampaignsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? description,
    Value<String>? targetDoctors,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return CampaignsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      targetDoctors: targetDoctors ?? this.targetDoctors,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (targetDoctors.present) {
      map['target_doctors'] = Variable<String>(targetDoctors.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CampaignsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('description: $description, ')
          ..write('targetDoctors: $targetDoctors, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EDetailContentsTable extends EDetailContents
    with TableInfo<$EDetailContentsTable, EDetailContent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EDetailContentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pdf'),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1.0'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    title,
    type,
    url,
    version,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'e_detail_contents';
  @override
  VerificationContext validateIntegrity(
    Insertable<EDetailContent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EDetailContent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EDetailContent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $EDetailContentsTable createAlias(String alias) {
    return $EDetailContentsTable(attachedDatabase, alias);
  }
}

class EDetailContent extends DataClass implements Insertable<EDetailContent> {
  final String id;
  final String productId;
  final String title;
  final String type;
  final String url;
  final String version;
  final bool isActive;
  const EDetailContent({
    required this.id,
    required this.productId,
    required this.title,
    required this.type,
    required this.url,
    required this.version,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['url'] = Variable<String>(url);
    map['version'] = Variable<String>(version);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  EDetailContentsCompanion toCompanion(bool nullToAbsent) {
    return EDetailContentsCompanion(
      id: Value(id),
      productId: Value(productId),
      title: Value(title),
      type: Value(type),
      url: Value(url),
      version: Value(version),
      isActive: Value(isActive),
    );
  }

  factory EDetailContent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EDetailContent(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      url: serializer.fromJson<String>(json['url']),
      version: serializer.fromJson<String>(json['version']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'url': serializer.toJson<String>(url),
      'version': serializer.toJson<String>(version),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  EDetailContent copyWith({
    String? id,
    String? productId,
    String? title,
    String? type,
    String? url,
    String? version,
    bool? isActive,
  }) => EDetailContent(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    title: title ?? this.title,
    type: type ?? this.type,
    url: url ?? this.url,
    version: version ?? this.version,
    isActive: isActive ?? this.isActive,
  );
  EDetailContent copyWithCompanion(EDetailContentsCompanion data) {
    return EDetailContent(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      url: data.url.present ? data.url.value : this.url,
      version: data.version.present ? data.version.value : this.version,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EDetailContent(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('version: $version, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, title, type, url, version, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EDetailContent &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.title == this.title &&
          other.type == this.type &&
          other.url == this.url &&
          other.version == this.version &&
          other.isActive == this.isActive);
}

class EDetailContentsCompanion extends UpdateCompanion<EDetailContent> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> title;
  final Value<String> type;
  final Value<String> url;
  final Value<String> version;
  final Value<bool> isActive;
  final Value<int> rowid;
  const EDetailContentsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.url = const Value.absent(),
    this.version = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EDetailContentsCompanion.insert({
    required String id,
    required String productId,
    required String title,
    this.type = const Value.absent(),
    this.url = const Value.absent(),
    this.version = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       title = Value(title);
  static Insertable<EDetailContent> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? url,
    Expression<String>? version,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (url != null) 'url': url,
      if (version != null) 'version': version,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EDetailContentsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? title,
    Value<String>? type,
    Value<String>? url,
    Value<String>? version,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return EDetailContentsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      type: type ?? this.type,
      url: url ?? this.url,
      version: version ?? this.version,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EDetailContentsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('version: $version, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TargetsTable extends Targets with TableInfo<$TargetsTable, Target> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TargetType, int> targetType =
      GeneratedColumn<int>(
        'target_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TargetType>($TargetsTable.$convertertargetType);
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _achievedValueMeta = const VerificationMeta(
    'achievedValue',
  );
  @override
  late final GeneratedColumn<double> achievedValue = GeneratedColumn<double>(
    'achieved_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mrId,
    productId,
    targetType,
    targetValue,
    achievedValue,
    period,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Target> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('achieved_value')) {
      context.handle(
        _achievedValueMeta,
        achievedValue.isAcceptableOrUnknown(
          data['achieved_value']!,
          _achievedValueMeta,
        ),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Target map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Target(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      targetType: $TargetsTable.$convertertargetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}target_type'],
        )!,
      ),
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      achievedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}achieved_value'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
    );
  }

  @override
  $TargetsTable createAlias(String alias) {
    return $TargetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TargetType, int, int> $convertertargetType =
      const EnumIndexConverter<TargetType>(TargetType.values);
}

class Target extends DataClass implements Insertable<Target> {
  final String id;
  final String mrId;
  final String productId;
  final TargetType targetType;
  final double targetValue;
  final double achievedValue;
  final String period;
  const Target({
    required this.id,
    required this.mrId,
    required this.productId,
    required this.targetType,
    required this.targetValue,
    required this.achievedValue,
    required this.period,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mr_id'] = Variable<String>(mrId);
    map['product_id'] = Variable<String>(productId);
    {
      map['target_type'] = Variable<int>(
        $TargetsTable.$convertertargetType.toSql(targetType),
      );
    }
    map['target_value'] = Variable<double>(targetValue);
    map['achieved_value'] = Variable<double>(achievedValue);
    map['period'] = Variable<String>(period);
    return map;
  }

  TargetsCompanion toCompanion(bool nullToAbsent) {
    return TargetsCompanion(
      id: Value(id),
      mrId: Value(mrId),
      productId: Value(productId),
      targetType: Value(targetType),
      targetValue: Value(targetValue),
      achievedValue: Value(achievedValue),
      period: Value(period),
    );
  }

  factory Target.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Target(
      id: serializer.fromJson<String>(json['id']),
      mrId: serializer.fromJson<String>(json['mrId']),
      productId: serializer.fromJson<String>(json['productId']),
      targetType: $TargetsTable.$convertertargetType.fromJson(
        serializer.fromJson<int>(json['targetType']),
      ),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      achievedValue: serializer.fromJson<double>(json['achievedValue']),
      period: serializer.fromJson<String>(json['period']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mrId': serializer.toJson<String>(mrId),
      'productId': serializer.toJson<String>(productId),
      'targetType': serializer.toJson<int>(
        $TargetsTable.$convertertargetType.toJson(targetType),
      ),
      'targetValue': serializer.toJson<double>(targetValue),
      'achievedValue': serializer.toJson<double>(achievedValue),
      'period': serializer.toJson<String>(period),
    };
  }

  Target copyWith({
    String? id,
    String? mrId,
    String? productId,
    TargetType? targetType,
    double? targetValue,
    double? achievedValue,
    String? period,
  }) => Target(
    id: id ?? this.id,
    mrId: mrId ?? this.mrId,
    productId: productId ?? this.productId,
    targetType: targetType ?? this.targetType,
    targetValue: targetValue ?? this.targetValue,
    achievedValue: achievedValue ?? this.achievedValue,
    period: period ?? this.period,
  );
  Target copyWithCompanion(TargetsCompanion data) {
    return Target(
      id: data.id.present ? data.id.value : this.id,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      productId: data.productId.present ? data.productId.value : this.productId,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      achievedValue: data.achievedValue.present
          ? data.achievedValue.value
          : this.achievedValue,
      period: data.period.present ? data.period.value : this.period,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Target(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('productId: $productId, ')
          ..write('targetType: $targetType, ')
          ..write('targetValue: $targetValue, ')
          ..write('achievedValue: $achievedValue, ')
          ..write('period: $period')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mrId,
    productId,
    targetType,
    targetValue,
    achievedValue,
    period,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Target &&
          other.id == this.id &&
          other.mrId == this.mrId &&
          other.productId == this.productId &&
          other.targetType == this.targetType &&
          other.targetValue == this.targetValue &&
          other.achievedValue == this.achievedValue &&
          other.period == this.period);
}

class TargetsCompanion extends UpdateCompanion<Target> {
  final Value<String> id;
  final Value<String> mrId;
  final Value<String> productId;
  final Value<TargetType> targetType;
  final Value<double> targetValue;
  final Value<double> achievedValue;
  final Value<String> period;
  final Value<int> rowid;
  const TargetsCompanion({
    this.id = const Value.absent(),
    this.mrId = const Value.absent(),
    this.productId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.achievedValue = const Value.absent(),
    this.period = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TargetsCompanion.insert({
    required String id,
    required String mrId,
    this.productId = const Value.absent(),
    required TargetType targetType,
    this.targetValue = const Value.absent(),
    this.achievedValue = const Value.absent(),
    required String period,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mrId = Value(mrId),
       targetType = Value(targetType),
       period = Value(period);
  static Insertable<Target> custom({
    Expression<String>? id,
    Expression<String>? mrId,
    Expression<String>? productId,
    Expression<int>? targetType,
    Expression<double>? targetValue,
    Expression<double>? achievedValue,
    Expression<String>? period,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mrId != null) 'mr_id': mrId,
      if (productId != null) 'product_id': productId,
      if (targetType != null) 'target_type': targetType,
      if (targetValue != null) 'target_value': targetValue,
      if (achievedValue != null) 'achieved_value': achievedValue,
      if (period != null) 'period': period,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TargetsCompanion copyWith({
    Value<String>? id,
    Value<String>? mrId,
    Value<String>? productId,
    Value<TargetType>? targetType,
    Value<double>? targetValue,
    Value<double>? achievedValue,
    Value<String>? period,
    Value<int>? rowid,
  }) {
    return TargetsCompanion(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      productId: productId ?? this.productId,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      achievedValue: achievedValue ?? this.achievedValue,
      period: period ?? this.period,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<int>(
        $TargetsTable.$convertertargetType.toSql(targetType.value),
      );
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (achievedValue.present) {
      map['achieved_value'] = Variable<double>(achievedValue.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetsCompanion(')
          ..write('id: $id, ')
          ..write('mrId: $mrId, ')
          ..write('productId: $productId, ')
          ..write('targetType: $targetType, ')
          ..write('targetValue: $targetValue, ')
          ..write('achievedValue: $achievedValue, ')
          ..write('period: $period, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    action,
    entityType,
    entityId,
    details,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }
}

class ActivityLog extends DataClass implements Insertable<ActivityLog> {
  final String id;
  final String userId;
  final String action;
  final String entityType;
  final String entityId;
  final String details;
  final DateTime timestamp;
  const ActivityLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.details,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['details'] = Variable<String>(details);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      action: Value(action),
      entityType: Value(entityType),
      entityId: Value(entityId),
      details: Value(details),
      timestamp: Value(timestamp),
    );
  }

  factory ActivityLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      details: serializer.fromJson<String>(json['details']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'details': serializer.toJson<String>(details),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ActivityLog copyWith({
    String? id,
    String? userId,
    String? action,
    String? entityType,
    String? entityId,
    String? details,
    DateTime? timestamp,
  }) => ActivityLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    action: action ?? this.action,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    details: details ?? this.details,
    timestamp: timestamp ?? this.timestamp,
  );
  ActivityLog copyWithCompanion(ActivityLogsCompanion data) {
    return ActivityLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      details: data.details.present ? data.details.value : this.details,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, action, entityType, entityId, details, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.details == this.details &&
          other.timestamp == this.timestamp);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> action;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> details;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    required String id,
    required String userId,
    required String action,
    required String entityType,
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       action = Value(action),
       entityType = Value(entityType);
  static Insertable<ActivityLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? details,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (details != null) 'details': details,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? action,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? details,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TerritoriesTable extends Territories
    with TableInfo<$TerritoriesTable, Territory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TerritoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _boundariesMeta = const VerificationMeta(
    'boundaries',
  );
  @override
  late final GeneratedColumn<String> boundaries = GeneratedColumn<String>(
    'boundaries',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId, level, boundaries];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'territories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Territory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('boundaries')) {
      context.handle(
        _boundariesMeta,
        boundaries.isAcceptableOrUnknown(data['boundaries']!, _boundariesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Territory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Territory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      boundaries: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}boundaries'],
      )!,
    );
  }

  @override
  $TerritoriesTable createAlias(String alias) {
    return $TerritoriesTable(attachedDatabase, alias);
  }
}

class Territory extends DataClass implements Insertable<Territory> {
  final String id;
  final String name;
  final String parentId;
  final int level;
  final String boundaries;
  const Territory({
    required this.id,
    required this.name,
    required this.parentId,
    required this.level,
    required this.boundaries,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['parent_id'] = Variable<String>(parentId);
    map['level'] = Variable<int>(level);
    map['boundaries'] = Variable<String>(boundaries);
    return map;
  }

  TerritoriesCompanion toCompanion(bool nullToAbsent) {
    return TerritoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: Value(parentId),
      level: Value(level),
      boundaries: Value(boundaries),
    );
  }

  factory Territory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Territory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String>(json['parentId']),
      level: serializer.fromJson<int>(json['level']),
      boundaries: serializer.fromJson<String>(json['boundaries']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String>(parentId),
      'level': serializer.toJson<int>(level),
      'boundaries': serializer.toJson<String>(boundaries),
    };
  }

  Territory copyWith({
    String? id,
    String? name,
    String? parentId,
    int? level,
    String? boundaries,
  }) => Territory(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId ?? this.parentId,
    level: level ?? this.level,
    boundaries: boundaries ?? this.boundaries,
  );
  Territory copyWithCompanion(TerritoriesCompanion data) {
    return Territory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      level: data.level.present ? data.level.value : this.level,
      boundaries: data.boundaries.present
          ? data.boundaries.value
          : this.boundaries,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Territory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('boundaries: $boundaries')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, level, boundaries);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Territory &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.level == this.level &&
          other.boundaries == this.boundaries);
}

class TerritoriesCompanion extends UpdateCompanion<Territory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> parentId;
  final Value<int> level;
  final Value<String> boundaries;
  final Value<int> rowid;
  const TerritoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.level = const Value.absent(),
    this.boundaries = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TerritoriesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.level = const Value.absent(),
    this.boundaries = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Territory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<int>? level,
    Expression<String>? boundaries,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (level != null) 'level': level,
      if (boundaries != null) 'boundaries': boundaries,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TerritoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? parentId,
    Value<int>? level,
    Value<String>? boundaries,
    Value<int>? rowid,
  }) {
    return TerritoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      boundaries: boundaries ?? this.boundaries,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (boundaries.present) {
      map['boundaries'] = Variable<String>(boundaries.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TerritoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('boundaries: $boundaries, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockLedgersTable extends StockLedgers
    with TableInfo<$StockLedgersTable, StockLedger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockLedgersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrIdMeta = const VerificationMeta('mrId');
  @override
  late final GeneratedColumn<String> mrId = GeneratedColumn<String>(
    'mr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingStockMeta = const VerificationMeta(
    'openingStock',
  );
  @override
  late final GeneratedColumn<int> openingStock = GeneratedColumn<int>(
    'opening_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receivedMeta = const VerificationMeta(
    'received',
  );
  @override
  late final GeneratedColumn<int> received = GeneratedColumn<int>(
    'received',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distributedMeta = const VerificationMeta(
    'distributed',
  );
  @override
  late final GeneratedColumn<int> distributed = GeneratedColumn<int>(
    'distributed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _closingStockMeta = const VerificationMeta(
    'closingStock',
  );
  @override
  late final GeneratedColumn<int> closingStock = GeneratedColumn<int>(
    'closing_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    mrId,
    openingStock,
    received,
    distributed,
    closingStock,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_ledgers';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockLedger> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('mr_id')) {
      context.handle(
        _mrIdMeta,
        mrId.isAcceptableOrUnknown(data['mr_id']!, _mrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mrIdMeta);
    }
    if (data.containsKey('opening_stock')) {
      context.handle(
        _openingStockMeta,
        openingStock.isAcceptableOrUnknown(
          data['opening_stock']!,
          _openingStockMeta,
        ),
      );
    }
    if (data.containsKey('received')) {
      context.handle(
        _receivedMeta,
        received.isAcceptableOrUnknown(data['received']!, _receivedMeta),
      );
    }
    if (data.containsKey('distributed')) {
      context.handle(
        _distributedMeta,
        distributed.isAcceptableOrUnknown(
          data['distributed']!,
          _distributedMeta,
        ),
      );
    }
    if (data.containsKey('closing_stock')) {
      context.handle(
        _closingStockMeta,
        closingStock.isAcceptableOrUnknown(
          data['closing_stock']!,
          _closingStockMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockLedger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockLedger(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      mrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mr_id'],
      )!,
      openingStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_stock'],
      )!,
      received: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received'],
      )!,
      distributed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distributed'],
      )!,
      closingStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closing_stock'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $StockLedgersTable createAlias(String alias) {
    return $StockLedgersTable(attachedDatabase, alias);
  }
}

class StockLedger extends DataClass implements Insertable<StockLedger> {
  final String id;
  final String productId;
  final String mrId;
  final int openingStock;
  final int received;
  final int distributed;
  final int closingStock;
  final DateTime date;
  const StockLedger({
    required this.id,
    required this.productId,
    required this.mrId,
    required this.openingStock,
    required this.received,
    required this.distributed,
    required this.closingStock,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['mr_id'] = Variable<String>(mrId);
    map['opening_stock'] = Variable<int>(openingStock);
    map['received'] = Variable<int>(received);
    map['distributed'] = Variable<int>(distributed);
    map['closing_stock'] = Variable<int>(closingStock);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  StockLedgersCompanion toCompanion(bool nullToAbsent) {
    return StockLedgersCompanion(
      id: Value(id),
      productId: Value(productId),
      mrId: Value(mrId),
      openingStock: Value(openingStock),
      received: Value(received),
      distributed: Value(distributed),
      closingStock: Value(closingStock),
      date: Value(date),
    );
  }

  factory StockLedger.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockLedger(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      mrId: serializer.fromJson<String>(json['mrId']),
      openingStock: serializer.fromJson<int>(json['openingStock']),
      received: serializer.fromJson<int>(json['received']),
      distributed: serializer.fromJson<int>(json['distributed']),
      closingStock: serializer.fromJson<int>(json['closingStock']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'mrId': serializer.toJson<String>(mrId),
      'openingStock': serializer.toJson<int>(openingStock),
      'received': serializer.toJson<int>(received),
      'distributed': serializer.toJson<int>(distributed),
      'closingStock': serializer.toJson<int>(closingStock),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  StockLedger copyWith({
    String? id,
    String? productId,
    String? mrId,
    int? openingStock,
    int? received,
    int? distributed,
    int? closingStock,
    DateTime? date,
  }) => StockLedger(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    mrId: mrId ?? this.mrId,
    openingStock: openingStock ?? this.openingStock,
    received: received ?? this.received,
    distributed: distributed ?? this.distributed,
    closingStock: closingStock ?? this.closingStock,
    date: date ?? this.date,
  );
  StockLedger copyWithCompanion(StockLedgersCompanion data) {
    return StockLedger(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      mrId: data.mrId.present ? data.mrId.value : this.mrId,
      openingStock: data.openingStock.present
          ? data.openingStock.value
          : this.openingStock,
      received: data.received.present ? data.received.value : this.received,
      distributed: data.distributed.present
          ? data.distributed.value
          : this.distributed,
      closingStock: data.closingStock.present
          ? data.closingStock.value
          : this.closingStock,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockLedger(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mrId: $mrId, ')
          ..write('openingStock: $openingStock, ')
          ..write('received: $received, ')
          ..write('distributed: $distributed, ')
          ..write('closingStock: $closingStock, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    mrId,
    openingStock,
    received,
    distributed,
    closingStock,
    date,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockLedger &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.mrId == this.mrId &&
          other.openingStock == this.openingStock &&
          other.received == this.received &&
          other.distributed == this.distributed &&
          other.closingStock == this.closingStock &&
          other.date == this.date);
}

class StockLedgersCompanion extends UpdateCompanion<StockLedger> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> mrId;
  final Value<int> openingStock;
  final Value<int> received;
  final Value<int> distributed;
  final Value<int> closingStock;
  final Value<DateTime> date;
  final Value<int> rowid;
  const StockLedgersCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.mrId = const Value.absent(),
    this.openingStock = const Value.absent(),
    this.received = const Value.absent(),
    this.distributed = const Value.absent(),
    this.closingStock = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockLedgersCompanion.insert({
    required String id,
    required String productId,
    required String mrId,
    this.openingStock = const Value.absent(),
    this.received = const Value.absent(),
    this.distributed = const Value.absent(),
    this.closingStock = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       mrId = Value(mrId),
       date = Value(date);
  static Insertable<StockLedger> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? mrId,
    Expression<int>? openingStock,
    Expression<int>? received,
    Expression<int>? distributed,
    Expression<int>? closingStock,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (mrId != null) 'mr_id': mrId,
      if (openingStock != null) 'opening_stock': openingStock,
      if (received != null) 'received': received,
      if (distributed != null) 'distributed': distributed,
      if (closingStock != null) 'closing_stock': closingStock,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockLedgersCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? mrId,
    Value<int>? openingStock,
    Value<int>? received,
    Value<int>? distributed,
    Value<int>? closingStock,
    Value<DateTime>? date,
    Value<int>? rowid,
  }) {
    return StockLedgersCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      mrId: mrId ?? this.mrId,
      openingStock: openingStock ?? this.openingStock,
      received: received ?? this.received,
      distributed: distributed ?? this.distributed,
      closingStock: closingStock ?? this.closingStock,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (mrId.present) {
      map['mr_id'] = Variable<String>(mrId.value);
    }
    if (openingStock.present) {
      map['opening_stock'] = Variable<int>(openingStock.value);
    }
    if (received.present) {
      map['received'] = Variable<int>(received.value);
    }
    if (distributed.present) {
      map['distributed'] = Variable<int>(distributed.value);
    }
    if (closingStock.present) {
      map['closing_stock'] = Variable<int>(closingStock.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockLedgersCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mrId: $mrId, ')
          ..write('openingStock: $openingStock, ')
          ..write('received: $received, ')
          ..write('distributed: $distributed, ')
          ..write('closingStock: $closingStock, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  late final $DoctorsTable doctors = $DoctorsTable(this);
  late final $DcrsTable dcrs = $DcrsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $VisitsTable visits = $VisitsTable(this);
  late final $RecommendationsTable recommendations = $RecommendationsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $SamplesTable samples = $SamplesTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $TourPlansTable tourPlans = $TourPlansTable(this);
  late final $TourPlanDaysTable tourPlanDays = $TourPlanDaysTable(this);
  late final $AttendancesTable attendances = $AttendancesTable(this);
  late final $LeaveRequestsTable leaveRequests = $LeaveRequestsTable(this);
  late final $LeaveBalancesTable leaveBalances = $LeaveBalancesTable(this);
  late final $ApprovalsTable approvals = $ApprovalsTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final $CampaignsTable campaigns = $CampaignsTable(this);
  late final $EDetailContentsTable eDetailContents = $EDetailContentsTable(
    this,
  );
  late final $TargetsTable targets = $TargetsTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $TerritoriesTable territories = $TerritoriesTable(this);
  late final $StockLedgersTable stockLedgers = $StockLedgersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncQueueItems,
    doctors,
    dcrs,
    expenses,
    visits,
    recommendations,
    appSettings,
    users,
    products,
    samples,
    orders,
    orderItems,
    tourPlans,
    tourPlanDays,
    attendances,
    leaveRequests,
    leaveBalances,
    approvals,
    notifications,
    campaigns,
    eDetailContents,
    targets,
    activityLogs,
    territories,
    stockLedgers,
  ];
}

typedef $$SyncQueueItemsTableCreateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<int> id,
      required String collectionName,
      required String documentId,
      required OperationType operationType,
      required String payload,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
    });
typedef $$SyncQueueItemsTableUpdateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<int> id,
      Value<String> collectionName,
      Value<String> documentId,
      Value<OperationType> operationType,
      Value<String> payload,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
    });

class $$SyncQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectionName => $composableBuilder(
    column: $table.collectionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OperationType, OperationType, int>
  get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectionName => $composableBuilder(
    column: $table.collectionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get collectionName => $composableBuilder(
    column: $table.collectionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<OperationType, int> get operationType =>
      $composableBuilder(
        column: $table.operationType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueItemsTable,
          SyncQueueItem,
          $$SyncQueueItemsTableFilterComposer,
          $$SyncQueueItemsTableOrderingComposer,
          $$SyncQueueItemsTableAnnotationComposer,
          $$SyncQueueItemsTableCreateCompanionBuilder,
          $$SyncQueueItemsTableUpdateCompanionBuilder,
          (
            SyncQueueItem,
            BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
          ),
          SyncQueueItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueItemsTableTableManager(
    _$AppDatabase db,
    $SyncQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> collectionName = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<OperationType> operationType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => SyncQueueItemsCompanion(
                id: id,
                collectionName: collectionName,
                documentId: documentId,
                operationType: operationType,
                payload: payload,
                isSynced: isSynced,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String collectionName,
                required String documentId,
                required OperationType operationType,
                required String payload,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => SyncQueueItemsCompanion.insert(
                id: id,
                collectionName: collectionName,
                documentId: documentId,
                operationType: operationType,
                payload: payload,
                isSynced: isSynced,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueItemsTable,
      SyncQueueItem,
      $$SyncQueueItemsTableFilterComposer,
      $$SyncQueueItemsTableOrderingComposer,
      $$SyncQueueItemsTableAnnotationComposer,
      $$SyncQueueItemsTableCreateCompanionBuilder,
      $$SyncQueueItemsTableUpdateCompanionBuilder,
      (
        SyncQueueItem,
        BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
      ),
      SyncQueueItem,
      PrefetchHooks Function()
    >;
typedef $$DoctorsTableCreateCompanionBuilder =
    DoctorsCompanion Function({
      required String id,
      required String name,
      Value<String> specialization,
      Value<String> clinicAddress,
      Value<String> phone,
      Value<String> territory,
      Value<String> classification,
      Value<DateTime?> lastVisitDate,
      Value<int> visitFrequency,
      Value<double> conversionProbability,
      Value<double> latitude,
      Value<double> longitude,
      Value<int> rowid,
    });
typedef $$DoctorsTableUpdateCompanionBuilder =
    DoctorsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> specialization,
      Value<String> clinicAddress,
      Value<String> phone,
      Value<String> territory,
      Value<String> classification,
      Value<DateTime?> lastVisitDate,
      Value<int> visitFrequency,
      Value<double> conversionProbability,
      Value<double> latitude,
      Value<double> longitude,
      Value<int> rowid,
    });

final class $$DoctorsTableReferences
    extends BaseReferences<_$AppDatabase, $DoctorsTable, Doctor> {
  $$DoctorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VisitsTable, List<Visit>> _visitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.visits,
    aliasName: $_aliasNameGenerator(db.doctors.id, db.visits.doctorId),
  );

  $$VisitsTableProcessedTableManager get visitsRefs {
    final manager = $$VisitsTableTableManager(
      $_db,
      $_db.visits,
    ).filter((f) => f.doctorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DoctorsTableFilterComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clinicAddress => $composableBuilder(
    column: $table.clinicAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get territory => $composableBuilder(
    column: $table.territory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVisitDate => $composableBuilder(
    column: $table.lastVisitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visitFrequency => $composableBuilder(
    column: $table.visitFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionProbability => $composableBuilder(
    column: $table.conversionProbability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> visitsRefs(
    Expression<bool> Function($$VisitsTableFilterComposer f) f,
  ) {
    final $$VisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableFilterComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DoctorsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clinicAddress => $composableBuilder(
    column: $table.clinicAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get territory => $composableBuilder(
    column: $table.territory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVisitDate => $composableBuilder(
    column: $table.lastVisitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visitFrequency => $composableBuilder(
    column: $table.visitFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionProbability => $composableBuilder(
    column: $table.conversionProbability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoctorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clinicAddress => $composableBuilder(
    column: $table.clinicAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get territory =>
      $composableBuilder(column: $table.territory, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVisitDate => $composableBuilder(
    column: $table.lastVisitDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get visitFrequency => $composableBuilder(
    column: $table.visitFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<double> get conversionProbability => $composableBuilder(
    column: $table.conversionProbability,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  Expression<T> visitsRefs<T extends Object>(
    Expression<T> Function($$VisitsTableAnnotationComposer a) f,
  ) {
    final $$VisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DoctorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoctorsTable,
          Doctor,
          $$DoctorsTableFilterComposer,
          $$DoctorsTableOrderingComposer,
          $$DoctorsTableAnnotationComposer,
          $$DoctorsTableCreateCompanionBuilder,
          $$DoctorsTableUpdateCompanionBuilder,
          (Doctor, $$DoctorsTableReferences),
          Doctor,
          PrefetchHooks Function({bool visitsRefs})
        > {
  $$DoctorsTableTableManager(_$AppDatabase db, $DoctorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> specialization = const Value.absent(),
                Value<String> clinicAddress = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> territory = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<DateTime?> lastVisitDate = const Value.absent(),
                Value<int> visitFrequency = const Value.absent(),
                Value<double> conversionProbability = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorsCompanion(
                id: id,
                name: name,
                specialization: specialization,
                clinicAddress: clinicAddress,
                phone: phone,
                territory: territory,
                classification: classification,
                lastVisitDate: lastVisitDate,
                visitFrequency: visitFrequency,
                conversionProbability: conversionProbability,
                latitude: latitude,
                longitude: longitude,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> specialization = const Value.absent(),
                Value<String> clinicAddress = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> territory = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<DateTime?> lastVisitDate = const Value.absent(),
                Value<int> visitFrequency = const Value.absent(),
                Value<double> conversionProbability = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorsCompanion.insert(
                id: id,
                name: name,
                specialization: specialization,
                clinicAddress: clinicAddress,
                phone: phone,
                territory: territory,
                classification: classification,
                lastVisitDate: lastVisitDate,
                visitFrequency: visitFrequency,
                conversionProbability: conversionProbability,
                latitude: latitude,
                longitude: longitude,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DoctorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({visitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (visitsRefs) db.visits],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (visitsRefs)
                    await $_getPrefetchedData<Doctor, $DoctorsTable, Visit>(
                      currentTable: table,
                      referencedTable: $$DoctorsTableReferences
                          ._visitsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DoctorsTableReferences(db, table, p0).visitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.doctorId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DoctorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoctorsTable,
      Doctor,
      $$DoctorsTableFilterComposer,
      $$DoctorsTableOrderingComposer,
      $$DoctorsTableAnnotationComposer,
      $$DoctorsTableCreateCompanionBuilder,
      $$DoctorsTableUpdateCompanionBuilder,
      (Doctor, $$DoctorsTableReferences),
      Doctor,
      PrefetchHooks Function({bool visitsRefs})
    >;
typedef $$DcrsTableCreateCompanionBuilder =
    DcrsCompanion Function({
      required String id,
      required String doctorName,
      Value<String> doctorId,
      Value<String> productsDiscussed,
      Value<String> productsDetailed,
      Value<String> samplesGiven,
      Value<String> giftsGiven,
      Value<DateTime?> followUpDate,
      Value<String> notes,
      Value<int> callDuration,
      Value<double> geoLat,
      Value<double> geoLng,
      Value<DateTime> createdAt,
      required String mrId,
      Value<int> rowid,
    });
typedef $$DcrsTableUpdateCompanionBuilder =
    DcrsCompanion Function({
      Value<String> id,
      Value<String> doctorName,
      Value<String> doctorId,
      Value<String> productsDiscussed,
      Value<String> productsDetailed,
      Value<String> samplesGiven,
      Value<String> giftsGiven,
      Value<DateTime?> followUpDate,
      Value<String> notes,
      Value<int> callDuration,
      Value<double> geoLat,
      Value<double> geoLng,
      Value<DateTime> createdAt,
      Value<String> mrId,
      Value<int> rowid,
    });

class $$DcrsTableFilterComposer extends Composer<_$AppDatabase, $DcrsTable> {
  $$DcrsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productsDiscussed => $composableBuilder(
    column: $table.productsDiscussed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productsDetailed => $composableBuilder(
    column: $table.productsDetailed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get samplesGiven => $composableBuilder(
    column: $table.samplesGiven,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get giftsGiven => $composableBuilder(
    column: $table.giftsGiven,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get callDuration => $composableBuilder(
    column: $table.callDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get geoLat => $composableBuilder(
    column: $table.geoLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get geoLng => $composableBuilder(
    column: $table.geoLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DcrsTableOrderingComposer extends Composer<_$AppDatabase, $DcrsTable> {
  $$DcrsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productsDiscussed => $composableBuilder(
    column: $table.productsDiscussed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productsDetailed => $composableBuilder(
    column: $table.productsDetailed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get samplesGiven => $composableBuilder(
    column: $table.samplesGiven,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get giftsGiven => $composableBuilder(
    column: $table.giftsGiven,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get callDuration => $composableBuilder(
    column: $table.callDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get geoLat => $composableBuilder(
    column: $table.geoLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get geoLng => $composableBuilder(
    column: $table.geoLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DcrsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DcrsTable> {
  $$DcrsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumn<String> get productsDiscussed => $composableBuilder(
    column: $table.productsDiscussed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productsDetailed => $composableBuilder(
    column: $table.productsDetailed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get samplesGiven => $composableBuilder(
    column: $table.samplesGiven,
    builder: (column) => column,
  );

  GeneratedColumn<String> get giftsGiven => $composableBuilder(
    column: $table.giftsGiven,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get callDuration => $composableBuilder(
    column: $table.callDuration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get geoLat =>
      $composableBuilder(column: $table.geoLat, builder: (column) => column);

  GeneratedColumn<double> get geoLng =>
      $composableBuilder(column: $table.geoLng, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);
}

class $$DcrsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DcrsTable,
          Dcr,
          $$DcrsTableFilterComposer,
          $$DcrsTableOrderingComposer,
          $$DcrsTableAnnotationComposer,
          $$DcrsTableCreateCompanionBuilder,
          $$DcrsTableUpdateCompanionBuilder,
          (Dcr, BaseReferences<_$AppDatabase, $DcrsTable, Dcr>),
          Dcr,
          PrefetchHooks Function()
        > {
  $$DcrsTableTableManager(_$AppDatabase db, $DcrsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DcrsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DcrsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DcrsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> doctorName = const Value.absent(),
                Value<String> doctorId = const Value.absent(),
                Value<String> productsDiscussed = const Value.absent(),
                Value<String> productsDetailed = const Value.absent(),
                Value<String> samplesGiven = const Value.absent(),
                Value<String> giftsGiven = const Value.absent(),
                Value<DateTime?> followUpDate = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> callDuration = const Value.absent(),
                Value<double> geoLat = const Value.absent(),
                Value<double> geoLng = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DcrsCompanion(
                id: id,
                doctorName: doctorName,
                doctorId: doctorId,
                productsDiscussed: productsDiscussed,
                productsDetailed: productsDetailed,
                samplesGiven: samplesGiven,
                giftsGiven: giftsGiven,
                followUpDate: followUpDate,
                notes: notes,
                callDuration: callDuration,
                geoLat: geoLat,
                geoLng: geoLng,
                createdAt: createdAt,
                mrId: mrId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String doctorName,
                Value<String> doctorId = const Value.absent(),
                Value<String> productsDiscussed = const Value.absent(),
                Value<String> productsDetailed = const Value.absent(),
                Value<String> samplesGiven = const Value.absent(),
                Value<String> giftsGiven = const Value.absent(),
                Value<DateTime?> followUpDate = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> callDuration = const Value.absent(),
                Value<double> geoLat = const Value.absent(),
                Value<double> geoLng = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String mrId,
                Value<int> rowid = const Value.absent(),
              }) => DcrsCompanion.insert(
                id: id,
                doctorName: doctorName,
                doctorId: doctorId,
                productsDiscussed: productsDiscussed,
                productsDetailed: productsDetailed,
                samplesGiven: samplesGiven,
                giftsGiven: giftsGiven,
                followUpDate: followUpDate,
                notes: notes,
                callDuration: callDuration,
                geoLat: geoLat,
                geoLng: geoLng,
                createdAt: createdAt,
                mrId: mrId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DcrsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DcrsTable,
      Dcr,
      $$DcrsTableFilterComposer,
      $$DcrsTableOrderingComposer,
      $$DcrsTableAnnotationComposer,
      $$DcrsTableCreateCompanionBuilder,
      $$DcrsTableUpdateCompanionBuilder,
      (Dcr, BaseReferences<_$AppDatabase, $DcrsTable, Dcr>),
      Dcr,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required double amount,
      required DateTime date,
      required ExpenseCategory category,
      Value<String?> receiptImagePath,
      Value<bool> isApproved,
      Value<bool> warningFlag,
      Value<DateTime> createdAt,
      required String mrId,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<double> amount,
      Value<DateTime> date,
      Value<ExpenseCategory> category,
      Value<String?> receiptImagePath,
      Value<bool> isApproved,
      Value<bool> warningFlag,
      Value<DateTime> createdAt,
      Value<String> mrId,
      Value<int> rowid,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpenseCategory, ExpenseCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isApproved => $composableBuilder(
    column: $table.isApproved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warningFlag => $composableBuilder(
    column: $table.warningFlag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isApproved => $composableBuilder(
    column: $table.isApproved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warningFlag => $composableBuilder(
    column: $table.warningFlag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExpenseCategory, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isApproved => $composableBuilder(
    column: $table.isApproved,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get warningFlag => $composableBuilder(
    column: $table.warningFlag,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<ExpenseCategory> category = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
                Value<bool> isApproved = const Value.absent(),
                Value<bool> warningFlag = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                amount: amount,
                date: date,
                category: category,
                receiptImagePath: receiptImagePath,
                isApproved: isApproved,
                warningFlag: warningFlag,
                createdAt: createdAt,
                mrId: mrId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double amount,
                required DateTime date,
                required ExpenseCategory category,
                Value<String?> receiptImagePath = const Value.absent(),
                Value<bool> isApproved = const Value.absent(),
                Value<bool> warningFlag = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String mrId,
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                amount: amount,
                date: date,
                category: category,
                receiptImagePath: receiptImagePath,
                isApproved: isApproved,
                warningFlag: warningFlag,
                createdAt: createdAt,
                mrId: mrId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$VisitsTableCreateCompanionBuilder =
    VisitsCompanion Function({
      required String id,
      required String doctorId,
      required String mrId,
      required DateTime visitDate,
      Value<String> notes,
      Value<String> outcome,
      Value<bool> isCompleted,
      Value<int> rowid,
    });
typedef $$VisitsTableUpdateCompanionBuilder =
    VisitsCompanion Function({
      Value<String> id,
      Value<String> doctorId,
      Value<String> mrId,
      Value<DateTime> visitDate,
      Value<String> notes,
      Value<String> outcome,
      Value<bool> isCompleted,
      Value<int> rowid,
    });

final class $$VisitsTableReferences
    extends BaseReferences<_$AppDatabase, $VisitsTable, Visit> {
  $$VisitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DoctorsTable _doctorIdTable(_$AppDatabase db) => db.doctors
      .createAlias($_aliasNameGenerator(db.visits.doctorId, db.doctors.id));

  $$DoctorsTableProcessedTableManager get doctorId {
    final $_column = $_itemColumn<String>('doctor_id')!;

    final manager = $$DoctorsTableTableManager(
      $_db,
      $_db.doctors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_doctorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisitsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  $$DoctorsTableFilterComposer get doctorId {
    final $$DoctorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doctorId,
      referencedTable: $db.doctors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorsTableFilterComposer(
            $db: $db,
            $table: $db.doctors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$DoctorsTableOrderingComposer get doctorId {
    final $$DoctorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doctorId,
      referencedTable: $db.doctors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorsTableOrderingComposer(
            $db: $db,
            $table: $db.doctors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumn<DateTime> get visitDate =>
      $composableBuilder(column: $table.visitDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  $$DoctorsTableAnnotationComposer get doctorId {
    final $$DoctorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doctorId,
      referencedTable: $db.doctors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorsTableAnnotationComposer(
            $db: $db,
            $table: $db.doctors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitsTable,
          Visit,
          $$VisitsTableFilterComposer,
          $$VisitsTableOrderingComposer,
          $$VisitsTableAnnotationComposer,
          $$VisitsTableCreateCompanionBuilder,
          $$VisitsTableUpdateCompanionBuilder,
          (Visit, $$VisitsTableReferences),
          Visit,
          PrefetchHooks Function({bool doctorId})
        > {
  $$VisitsTableTableManager(_$AppDatabase db, $VisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> doctorId = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<DateTime> visitDate = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitsCompanion(
                id: id,
                doctorId: doctorId,
                mrId: mrId,
                visitDate: visitDate,
                notes: notes,
                outcome: outcome,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String doctorId,
                required String mrId,
                required DateTime visitDate,
                Value<String> notes = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitsCompanion.insert(
                id: id,
                doctorId: doctorId,
                mrId: mrId,
                visitDate: visitDate,
                notes: notes,
                outcome: outcome,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VisitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({doctorId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (doctorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.doctorId,
                                referencedTable: $$VisitsTableReferences
                                    ._doctorIdTable(db),
                                referencedColumn: $$VisitsTableReferences
                                    ._doctorIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitsTable,
      Visit,
      $$VisitsTableFilterComposer,
      $$VisitsTableOrderingComposer,
      $$VisitsTableAnnotationComposer,
      $$VisitsTableCreateCompanionBuilder,
      $$VisitsTableUpdateCompanionBuilder,
      (Visit, $$VisitsTableReferences),
      Visit,
      PrefetchHooks Function({bool doctorId})
    >;
typedef $$RecommendationsTableCreateCompanionBuilder =
    RecommendationsCompanion Function({
      Value<int> id,
      required String doctorName,
      Value<String> specialization,
      Value<String> address,
      Value<double> score,
      Value<String> reason,
      Value<DateTime> fetchedAt,
      required String mrId,
    });
typedef $$RecommendationsTableUpdateCompanionBuilder =
    RecommendationsCompanion Function({
      Value<int> id,
      Value<String> doctorName,
      Value<String> specialization,
      Value<String> address,
      Value<double> score,
      Value<String> reason,
      Value<DateTime> fetchedAt,
      Value<String> mrId,
    });

class $$RecommendationsTableFilterComposer
    extends Composer<_$AppDatabase, $RecommendationsTable> {
  $$RecommendationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecommendationsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecommendationsTable> {
  $$RecommendationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecommendationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecommendationsTable> {
  $$RecommendationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);
}

class $$RecommendationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecommendationsTable,
          Recommendation,
          $$RecommendationsTableFilterComposer,
          $$RecommendationsTableOrderingComposer,
          $$RecommendationsTableAnnotationComposer,
          $$RecommendationsTableCreateCompanionBuilder,
          $$RecommendationsTableUpdateCompanionBuilder,
          (
            Recommendation,
            BaseReferences<
              _$AppDatabase,
              $RecommendationsTable,
              Recommendation
            >,
          ),
          Recommendation,
          PrefetchHooks Function()
        > {
  $$RecommendationsTableTableManager(
    _$AppDatabase db,
    $RecommendationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecommendationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecommendationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecommendationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> doctorName = const Value.absent(),
                Value<String> specialization = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<String> mrId = const Value.absent(),
              }) => RecommendationsCompanion(
                id: id,
                doctorName: doctorName,
                specialization: specialization,
                address: address,
                score: score,
                reason: reason,
                fetchedAt: fetchedAt,
                mrId: mrId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String doctorName,
                Value<String> specialization = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                required String mrId,
              }) => RecommendationsCompanion.insert(
                id: id,
                doctorName: doctorName,
                specialization: specialization,
                address: address,
                score: score,
                reason: reason,
                fetchedAt: fetchedAt,
                mrId: mrId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecommendationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecommendationsTable,
      Recommendation,
      $$RecommendationsTableFilterComposer,
      $$RecommendationsTableOrderingComposer,
      $$RecommendationsTableAnnotationComposer,
      $$RecommendationsTableCreateCompanionBuilder,
      $$RecommendationsTableUpdateCompanionBuilder,
      (
        Recommendation,
        BaseReferences<_$AppDatabase, $RecommendationsTable, Recommendation>,
      ),
      Recommendation,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String email,
      required String name,
      Value<String> role,
      Value<String> parentId,
      Value<String> territoryId,
      Value<bool> isActive,
      Value<String> phone,
      Value<String> profileImageUrl,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> name,
      Value<String> role,
      Value<String> parentId,
      Value<String> territoryId,
      Value<bool> isActive,
      Value<String> phone,
      Value<String> profileImageUrl,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get territoryId => $composableBuilder(
    column: $table.territoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get territoryId => $composableBuilder(
    column: $table.territoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get territoryId => $composableBuilder(
    column: $table.territoryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<String> territoryId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> profileImageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                name: name,
                role: role,
                parentId: parentId,
                territoryId: territoryId,
                isActive: isActive,
                phone: phone,
                profileImageUrl: profileImageUrl,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String name,
                Value<String> role = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<String> territoryId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> profileImageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                name: name,
                role: role,
                parentId: parentId,
                territoryId: territoryId,
                isActive: isActive,
                phone: phone,
                profileImageUrl: profileImageUrl,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      Value<String> sku,
      Value<String> category,
      Value<String> division,
      Value<double> price,
      Value<String> description,
      Value<String> imageUrl,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> sku,
      Value<String> category,
      Value<String> division,
      Value<double> price,
      Value<String> description,
      Value<String> imageUrl,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get division => $composableBuilder(
    column: $table.division,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get division => $composableBuilder(
    column: $table.division,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get division =>
      $composableBuilder(column: $table.division, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sku = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> division = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                sku: sku,
                category: category,
                division: division,
                price: price,
                description: description,
                imageUrl: imageUrl,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> sku = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> division = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                sku: sku,
                category: category,
                division: division,
                price: price,
                description: description,
                imageUrl: imageUrl,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$SamplesTableCreateCompanionBuilder =
    SamplesCompanion Function({
      required String id,
      required String productId,
      required String mrId,
      required String doctorId,
      required int quantity,
      required DateTime date,
      Value<String> batchNo,
      Value<DateTime?> expiryDate,
      Value<String> type,
      Value<int> rowid,
    });
typedef $$SamplesTableUpdateCompanionBuilder =
    SamplesCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> mrId,
      Value<String> doctorId,
      Value<int> quantity,
      Value<DateTime> date,
      Value<String> batchNo,
      Value<DateTime?> expiryDate,
      Value<String> type,
      Value<int> rowid,
    });

class $$SamplesTableFilterComposer
    extends Composer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get batchNo =>
      $composableBuilder(column: $table.batchNo, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$SamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SamplesTable,
          Sample,
          $$SamplesTableFilterComposer,
          $$SamplesTableOrderingComposer,
          $$SamplesTableAnnotationComposer,
          $$SamplesTableCreateCompanionBuilder,
          $$SamplesTableUpdateCompanionBuilder,
          (Sample, BaseReferences<_$AppDatabase, $SamplesTable, Sample>),
          Sample,
          PrefetchHooks Function()
        > {
  $$SamplesTableTableManager(_$AppDatabase db, $SamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<String> doctorId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> batchNo = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SamplesCompanion(
                id: id,
                productId: productId,
                mrId: mrId,
                doctorId: doctorId,
                quantity: quantity,
                date: date,
                batchNo: batchNo,
                expiryDate: expiryDate,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String mrId,
                required String doctorId,
                required int quantity,
                required DateTime date,
                Value<String> batchNo = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SamplesCompanion.insert(
                id: id,
                productId: productId,
                mrId: mrId,
                doctorId: doctorId,
                quantity: quantity,
                date: date,
                batchNo: batchNo,
                expiryDate: expiryDate,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SamplesTable,
      Sample,
      $$SamplesTableFilterComposer,
      $$SamplesTableOrderingComposer,
      $$SamplesTableAnnotationComposer,
      $$SamplesTableCreateCompanionBuilder,
      $$SamplesTableUpdateCompanionBuilder,
      (Sample, BaseReferences<_$AppDatabase, $SamplesTable, Sample>),
      Sample,
      PrefetchHooks Function()
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      required String id,
      required String mrId,
      required String doctorId,
      required OrderStatus status,
      Value<double> totalAmount,
      required DateTime orderDate,
      Value<DateTime?> deliveryDate,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<String> id,
      Value<String> mrId,
      Value<String> doctorId,
      Value<OrderStatus> status,
      Value<double> totalAmount,
      Value<DateTime> orderDate,
      Value<DateTime?> deliveryDate,
      Value<String> notes,
      Value<int> rowid,
    });

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrderStatus, OrderStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get orderDate => $composableBuilder(
    column: $table.orderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get orderDate => $composableBuilder(
    column: $table.orderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrderStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get orderDate =>
      $composableBuilder(column: $table.orderDate, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
          Order,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<String> doctorId = const Value.absent(),
                Value<OrderStatus> status = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime> orderDate = const Value.absent(),
                Value<DateTime?> deliveryDate = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                mrId: mrId,
                doctorId: doctorId,
                status: status,
                totalAmount: totalAmount,
                orderDate: orderDate,
                deliveryDate: deliveryDate,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mrId,
                required String doctorId,
                required OrderStatus status,
                Value<double> totalAmount = const Value.absent(),
                required DateTime orderDate,
                Value<DateTime?> deliveryDate = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                mrId: mrId,
                doctorId: doctorId,
                status: status,
                totalAmount: totalAmount,
                orderDate: orderDate,
                deliveryDate: deliveryDate,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
      Order,
      PrefetchHooks Function()
    >;
typedef $$OrderItemsTableCreateCompanionBuilder =
    OrderItemsCompanion Function({
      required String id,
      required String orderId,
      required String productId,
      required int quantity,
      required double price,
      Value<double> discount,
      Value<int> rowid,
    });
typedef $$OrderItemsTableUpdateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> productId,
      Value<int> quantity,
      Value<double> price,
      Value<double> discount,
      Value<int> rowid,
    });

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItem,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (
            OrderItem,
            BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem>,
          ),
          OrderItem,
          PrefetchHooks Function()
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                price: price,
                discount: discount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderId,
                required String productId,
                required int quantity,
                required double price,
                Value<double> discount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                price: price,
                discount: discount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItem,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItem, BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem>),
      OrderItem,
      PrefetchHooks Function()
    >;
typedef $$TourPlansTableCreateCompanionBuilder =
    TourPlansCompanion Function({
      required String id,
      required String mrId,
      required int month,
      required int year,
      Value<String> status,
      Value<String> approvedBy,
      Value<DateTime?> submittedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TourPlansTableUpdateCompanionBuilder =
    TourPlansCompanion Function({
      Value<String> id,
      Value<String> mrId,
      Value<int> month,
      Value<int> year,
      Value<String> status,
      Value<String> approvedBy,
      Value<DateTime?> submittedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TourPlansTableFilterComposer
    extends Composer<_$AppDatabase, $TourPlansTable> {
  $$TourPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TourPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $TourPlansTable> {
  $$TourPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TourPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $TourPlansTable> {
  $$TourPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TourPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TourPlansTable,
          TourPlan,
          $$TourPlansTableFilterComposer,
          $$TourPlansTableOrderingComposer,
          $$TourPlansTableAnnotationComposer,
          $$TourPlansTableCreateCompanionBuilder,
          $$TourPlansTableUpdateCompanionBuilder,
          (TourPlan, BaseReferences<_$AppDatabase, $TourPlansTable, TourPlan>),
          TourPlan,
          PrefetchHooks Function()
        > {
  $$TourPlansTableTableManager(_$AppDatabase db, $TourPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TourPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TourPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TourPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> approvedBy = const Value.absent(),
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TourPlansCompanion(
                id: id,
                mrId: mrId,
                month: month,
                year: year,
                status: status,
                approvedBy: approvedBy,
                submittedAt: submittedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mrId,
                required int month,
                required int year,
                Value<String> status = const Value.absent(),
                Value<String> approvedBy = const Value.absent(),
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TourPlansCompanion.insert(
                id: id,
                mrId: mrId,
                month: month,
                year: year,
                status: status,
                approvedBy: approvedBy,
                submittedAt: submittedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TourPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TourPlansTable,
      TourPlan,
      $$TourPlansTableFilterComposer,
      $$TourPlansTableOrderingComposer,
      $$TourPlansTableAnnotationComposer,
      $$TourPlansTableCreateCompanionBuilder,
      $$TourPlansTableUpdateCompanionBuilder,
      (TourPlan, BaseReferences<_$AppDatabase, $TourPlansTable, TourPlan>),
      TourPlan,
      PrefetchHooks Function()
    >;
typedef $$TourPlanDaysTableCreateCompanionBuilder =
    TourPlanDaysCompanion Function({
      required String id,
      required String tourPlanId,
      required DateTime date,
      Value<String> doctorIds,
      Value<String> notes,
      Value<bool> isCompleted,
      Value<int> rowid,
    });
typedef $$TourPlanDaysTableUpdateCompanionBuilder =
    TourPlanDaysCompanion Function({
      Value<String> id,
      Value<String> tourPlanId,
      Value<DateTime> date,
      Value<String> doctorIds,
      Value<String> notes,
      Value<bool> isCompleted,
      Value<int> rowid,
    });

class $$TourPlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $TourPlanDaysTable> {
  $$TourPlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tourPlanId => $composableBuilder(
    column: $table.tourPlanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorIds => $composableBuilder(
    column: $table.doctorIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TourPlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $TourPlanDaysTable> {
  $$TourPlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tourPlanId => $composableBuilder(
    column: $table.tourPlanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorIds => $composableBuilder(
    column: $table.doctorIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TourPlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $TourPlanDaysTable> {
  $$TourPlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tourPlanId => $composableBuilder(
    column: $table.tourPlanId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get doctorIds =>
      $composableBuilder(column: $table.doctorIds, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );
}

class $$TourPlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TourPlanDaysTable,
          TourPlanDay,
          $$TourPlanDaysTableFilterComposer,
          $$TourPlanDaysTableOrderingComposer,
          $$TourPlanDaysTableAnnotationComposer,
          $$TourPlanDaysTableCreateCompanionBuilder,
          $$TourPlanDaysTableUpdateCompanionBuilder,
          (
            TourPlanDay,
            BaseReferences<_$AppDatabase, $TourPlanDaysTable, TourPlanDay>,
          ),
          TourPlanDay,
          PrefetchHooks Function()
        > {
  $$TourPlanDaysTableTableManager(_$AppDatabase db, $TourPlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TourPlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TourPlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TourPlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tourPlanId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> doctorIds = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TourPlanDaysCompanion(
                id: id,
                tourPlanId: tourPlanId,
                date: date,
                doctorIds: doctorIds,
                notes: notes,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tourPlanId,
                required DateTime date,
                Value<String> doctorIds = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TourPlanDaysCompanion.insert(
                id: id,
                tourPlanId: tourPlanId,
                date: date,
                doctorIds: doctorIds,
                notes: notes,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TourPlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TourPlanDaysTable,
      TourPlanDay,
      $$TourPlanDaysTableFilterComposer,
      $$TourPlanDaysTableOrderingComposer,
      $$TourPlanDaysTableAnnotationComposer,
      $$TourPlanDaysTableCreateCompanionBuilder,
      $$TourPlanDaysTableUpdateCompanionBuilder,
      (
        TourPlanDay,
        BaseReferences<_$AppDatabase, $TourPlanDaysTable, TourPlanDay>,
      ),
      TourPlanDay,
      PrefetchHooks Function()
    >;
typedef $$AttendancesTableCreateCompanionBuilder =
    AttendancesCompanion Function({
      required String id,
      required String mrId,
      required DateTime date,
      Value<DateTime?> punchInTime,
      Value<double> punchInLat,
      Value<double> punchInLng,
      Value<String> punchInSelfie,
      Value<DateTime?> punchOutTime,
      Value<double> punchOutLat,
      Value<double> punchOutLng,
      required AttendanceStatus status,
      Value<int> rowid,
    });
typedef $$AttendancesTableUpdateCompanionBuilder =
    AttendancesCompanion Function({
      Value<String> id,
      Value<String> mrId,
      Value<DateTime> date,
      Value<DateTime?> punchInTime,
      Value<double> punchInLat,
      Value<double> punchInLng,
      Value<String> punchInSelfie,
      Value<DateTime?> punchOutTime,
      Value<double> punchOutLat,
      Value<double> punchOutLng,
      Value<AttendanceStatus> status,
      Value<int> rowid,
    });

class $$AttendancesTableFilterComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get punchInTime => $composableBuilder(
    column: $table.punchInTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get punchInLat => $composableBuilder(
    column: $table.punchInLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get punchInLng => $composableBuilder(
    column: $table.punchInLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get punchInSelfie => $composableBuilder(
    column: $table.punchInSelfie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get punchOutTime => $composableBuilder(
    column: $table.punchOutTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get punchOutLat => $composableBuilder(
    column: $table.punchOutLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get punchOutLng => $composableBuilder(
    column: $table.punchOutLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AttendanceStatus, AttendanceStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$AttendancesTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get punchInTime => $composableBuilder(
    column: $table.punchInTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get punchInLat => $composableBuilder(
    column: $table.punchInLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get punchInLng => $composableBuilder(
    column: $table.punchInLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get punchInSelfie => $composableBuilder(
    column: $table.punchInSelfie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get punchOutTime => $composableBuilder(
    column: $table.punchOutTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get punchOutLat => $composableBuilder(
    column: $table.punchOutLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get punchOutLng => $composableBuilder(
    column: $table.punchOutLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get punchInTime => $composableBuilder(
    column: $table.punchInTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get punchInLat => $composableBuilder(
    column: $table.punchInLat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get punchInLng => $composableBuilder(
    column: $table.punchInLng,
    builder: (column) => column,
  );

  GeneratedColumn<String> get punchInSelfie => $composableBuilder(
    column: $table.punchInSelfie,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get punchOutTime => $composableBuilder(
    column: $table.punchOutTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get punchOutLat => $composableBuilder(
    column: $table.punchOutLat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get punchOutLng => $composableBuilder(
    column: $table.punchOutLng,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AttendanceStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$AttendancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendancesTable,
          Attendance,
          $$AttendancesTableFilterComposer,
          $$AttendancesTableOrderingComposer,
          $$AttendancesTableAnnotationComposer,
          $$AttendancesTableCreateCompanionBuilder,
          $$AttendancesTableUpdateCompanionBuilder,
          (
            Attendance,
            BaseReferences<_$AppDatabase, $AttendancesTable, Attendance>,
          ),
          Attendance,
          PrefetchHooks Function()
        > {
  $$AttendancesTableTableManager(_$AppDatabase db, $AttendancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> punchInTime = const Value.absent(),
                Value<double> punchInLat = const Value.absent(),
                Value<double> punchInLng = const Value.absent(),
                Value<String> punchInSelfie = const Value.absent(),
                Value<DateTime?> punchOutTime = const Value.absent(),
                Value<double> punchOutLat = const Value.absent(),
                Value<double> punchOutLng = const Value.absent(),
                Value<AttendanceStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesCompanion(
                id: id,
                mrId: mrId,
                date: date,
                punchInTime: punchInTime,
                punchInLat: punchInLat,
                punchInLng: punchInLng,
                punchInSelfie: punchInSelfie,
                punchOutTime: punchOutTime,
                punchOutLat: punchOutLat,
                punchOutLng: punchOutLng,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mrId,
                required DateTime date,
                Value<DateTime?> punchInTime = const Value.absent(),
                Value<double> punchInLat = const Value.absent(),
                Value<double> punchInLng = const Value.absent(),
                Value<String> punchInSelfie = const Value.absent(),
                Value<DateTime?> punchOutTime = const Value.absent(),
                Value<double> punchOutLat = const Value.absent(),
                Value<double> punchOutLng = const Value.absent(),
                required AttendanceStatus status,
                Value<int> rowid = const Value.absent(),
              }) => AttendancesCompanion.insert(
                id: id,
                mrId: mrId,
                date: date,
                punchInTime: punchInTime,
                punchInLat: punchInLat,
                punchInLng: punchInLng,
                punchInSelfie: punchInSelfie,
                punchOutTime: punchOutTime,
                punchOutLat: punchOutLat,
                punchOutLng: punchOutLng,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendancesTable,
      Attendance,
      $$AttendancesTableFilterComposer,
      $$AttendancesTableOrderingComposer,
      $$AttendancesTableAnnotationComposer,
      $$AttendancesTableCreateCompanionBuilder,
      $$AttendancesTableUpdateCompanionBuilder,
      (
        Attendance,
        BaseReferences<_$AppDatabase, $AttendancesTable, Attendance>,
      ),
      Attendance,
      PrefetchHooks Function()
    >;
typedef $$LeaveRequestsTableCreateCompanionBuilder =
    LeaveRequestsCompanion Function({
      required String id,
      required String mrId,
      required LeaveType leaveType,
      required DateTime startDate,
      required DateTime endDate,
      Value<String> reason,
      Value<ApprovalStatus> status,
      Value<String> approvedBy,
      Value<String> comments,
      Value<int> rowid,
    });
typedef $$LeaveRequestsTableUpdateCompanionBuilder =
    LeaveRequestsCompanion Function({
      Value<String> id,
      Value<String> mrId,
      Value<LeaveType> leaveType,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> reason,
      Value<ApprovalStatus> status,
      Value<String> approvedBy,
      Value<String> comments,
      Value<int> rowid,
    });

class $$LeaveRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveRequestsTable> {
  $$LeaveRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeaveType, LeaveType, int> get leaveType =>
      $composableBuilder(
        column: $table.leaveType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ApprovalStatus, ApprovalStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveRequestsTable> {
  $$LeaveRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveRequestsTable> {
  $$LeaveRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveType, int> get leaveType =>
      $composableBuilder(column: $table.leaveType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ApprovalStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);
}

class $$LeaveRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveRequestsTable,
          LeaveRequest,
          $$LeaveRequestsTableFilterComposer,
          $$LeaveRequestsTableOrderingComposer,
          $$LeaveRequestsTableAnnotationComposer,
          $$LeaveRequestsTableCreateCompanionBuilder,
          $$LeaveRequestsTableUpdateCompanionBuilder,
          (
            LeaveRequest,
            BaseReferences<_$AppDatabase, $LeaveRequestsTable, LeaveRequest>,
          ),
          LeaveRequest,
          PrefetchHooks Function()
        > {
  $$LeaveRequestsTableTableManager(_$AppDatabase db, $LeaveRequestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<LeaveType> leaveType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<ApprovalStatus> status = const Value.absent(),
                Value<String> approvedBy = const Value.absent(),
                Value<String> comments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveRequestsCompanion(
                id: id,
                mrId: mrId,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                reason: reason,
                status: status,
                approvedBy: approvedBy,
                comments: comments,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mrId,
                required LeaveType leaveType,
                required DateTime startDate,
                required DateTime endDate,
                Value<String> reason = const Value.absent(),
                Value<ApprovalStatus> status = const Value.absent(),
                Value<String> approvedBy = const Value.absent(),
                Value<String> comments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveRequestsCompanion.insert(
                id: id,
                mrId: mrId,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                reason: reason,
                status: status,
                approvedBy: approvedBy,
                comments: comments,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveRequestsTable,
      LeaveRequest,
      $$LeaveRequestsTableFilterComposer,
      $$LeaveRequestsTableOrderingComposer,
      $$LeaveRequestsTableAnnotationComposer,
      $$LeaveRequestsTableCreateCompanionBuilder,
      $$LeaveRequestsTableUpdateCompanionBuilder,
      (
        LeaveRequest,
        BaseReferences<_$AppDatabase, $LeaveRequestsTable, LeaveRequest>,
      ),
      LeaveRequest,
      PrefetchHooks Function()
    >;
typedef $$LeaveBalancesTableCreateCompanionBuilder =
    LeaveBalancesCompanion Function({
      required String id,
      required String mrId,
      required LeaveType leaveType,
      Value<int> total,
      Value<int> used,
      Value<int> remaining,
      required int year,
      Value<int> rowid,
    });
typedef $$LeaveBalancesTableUpdateCompanionBuilder =
    LeaveBalancesCompanion Function({
      Value<String> id,
      Value<String> mrId,
      Value<LeaveType> leaveType,
      Value<int> total,
      Value<int> used,
      Value<int> remaining,
      Value<int> year,
      Value<int> rowid,
    });

class $$LeaveBalancesTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveBalancesTable> {
  $$LeaveBalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeaveType, LeaveType, int> get leaveType =>
      $composableBuilder(
        column: $table.leaveType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get used => $composableBuilder(
    column: $table.used,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveBalancesTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveBalancesTable> {
  $$LeaveBalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get used => $composableBuilder(
    column: $table.used,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveBalancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveBalancesTable> {
  $$LeaveBalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveType, int> get leaveType =>
      $composableBuilder(column: $table.leaveType, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get used =>
      $composableBuilder(column: $table.used, builder: (column) => column);

  GeneratedColumn<int> get remaining =>
      $composableBuilder(column: $table.remaining, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);
}

class $$LeaveBalancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveBalancesTable,
          LeaveBalance,
          $$LeaveBalancesTableFilterComposer,
          $$LeaveBalancesTableOrderingComposer,
          $$LeaveBalancesTableAnnotationComposer,
          $$LeaveBalancesTableCreateCompanionBuilder,
          $$LeaveBalancesTableUpdateCompanionBuilder,
          (
            LeaveBalance,
            BaseReferences<_$AppDatabase, $LeaveBalancesTable, LeaveBalance>,
          ),
          LeaveBalance,
          PrefetchHooks Function()
        > {
  $$LeaveBalancesTableTableManager(_$AppDatabase db, $LeaveBalancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveBalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveBalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveBalancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<LeaveType> leaveType = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> used = const Value.absent(),
                Value<int> remaining = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveBalancesCompanion(
                id: id,
                mrId: mrId,
                leaveType: leaveType,
                total: total,
                used: used,
                remaining: remaining,
                year: year,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mrId,
                required LeaveType leaveType,
                Value<int> total = const Value.absent(),
                Value<int> used = const Value.absent(),
                Value<int> remaining = const Value.absent(),
                required int year,
                Value<int> rowid = const Value.absent(),
              }) => LeaveBalancesCompanion.insert(
                id: id,
                mrId: mrId,
                leaveType: leaveType,
                total: total,
                used: used,
                remaining: remaining,
                year: year,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveBalancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveBalancesTable,
      LeaveBalance,
      $$LeaveBalancesTableFilterComposer,
      $$LeaveBalancesTableOrderingComposer,
      $$LeaveBalancesTableAnnotationComposer,
      $$LeaveBalancesTableCreateCompanionBuilder,
      $$LeaveBalancesTableUpdateCompanionBuilder,
      (
        LeaveBalance,
        BaseReferences<_$AppDatabase, $LeaveBalancesTable, LeaveBalance>,
      ),
      LeaveBalance,
      PrefetchHooks Function()
    >;
typedef $$ApprovalsTableCreateCompanionBuilder =
    ApprovalsCompanion Function({
      required String id,
      required ApprovalEntityType type,
      required String referenceId,
      required String requesterId,
      Value<String> approverId,
      Value<ApprovalStatus> status,
      Value<String> comments,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ApprovalsTableUpdateCompanionBuilder =
    ApprovalsCompanion Function({
      Value<String> id,
      Value<ApprovalEntityType> type,
      Value<String> referenceId,
      Value<String> requesterId,
      Value<String> approverId,
      Value<ApprovalStatus> status,
      Value<String> comments,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ApprovalsTableFilterComposer
    extends Composer<_$AppDatabase, $ApprovalsTable> {
  $$ApprovalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ApprovalEntityType, ApprovalEntityType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requesterId => $composableBuilder(
    column: $table.requesterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approverId => $composableBuilder(
    column: $table.approverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ApprovalStatus, ApprovalStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ApprovalsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApprovalsTable> {
  $$ApprovalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requesterId => $composableBuilder(
    column: $table.requesterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approverId => $composableBuilder(
    column: $table.approverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApprovalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApprovalsTable> {
  $$ApprovalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ApprovalEntityType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requesterId => $composableBuilder(
    column: $table.requesterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approverId => $composableBuilder(
    column: $table.approverId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ApprovalStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ApprovalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApprovalsTable,
          Approval,
          $$ApprovalsTableFilterComposer,
          $$ApprovalsTableOrderingComposer,
          $$ApprovalsTableAnnotationComposer,
          $$ApprovalsTableCreateCompanionBuilder,
          $$ApprovalsTableUpdateCompanionBuilder,
          (Approval, BaseReferences<_$AppDatabase, $ApprovalsTable, Approval>),
          Approval,
          PrefetchHooks Function()
        > {
  $$ApprovalsTableTableManager(_$AppDatabase db, $ApprovalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApprovalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApprovalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApprovalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<ApprovalEntityType> type = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<String> requesterId = const Value.absent(),
                Value<String> approverId = const Value.absent(),
                Value<ApprovalStatus> status = const Value.absent(),
                Value<String> comments = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApprovalsCompanion(
                id: id,
                type: type,
                referenceId: referenceId,
                requesterId: requesterId,
                approverId: approverId,
                status: status,
                comments: comments,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required ApprovalEntityType type,
                required String referenceId,
                required String requesterId,
                Value<String> approverId = const Value.absent(),
                Value<ApprovalStatus> status = const Value.absent(),
                Value<String> comments = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApprovalsCompanion.insert(
                id: id,
                type: type,
                referenceId: referenceId,
                requesterId: requesterId,
                approverId: approverId,
                status: status,
                comments: comments,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ApprovalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApprovalsTable,
      Approval,
      $$ApprovalsTableFilterComposer,
      $$ApprovalsTableOrderingComposer,
      $$ApprovalsTableAnnotationComposer,
      $$ApprovalsTableCreateCompanionBuilder,
      $$ApprovalsTableUpdateCompanionBuilder,
      (Approval, BaseReferences<_$AppDatabase, $ApprovalsTable, Approval>),
      Approval,
      PrefetchHooks Function()
    >;
typedef $$NotificationsTableCreateCompanionBuilder =
    NotificationsCompanion Function({
      required String id,
      required String userId,
      required String title,
      required String body,
      required NotificationType type,
      Value<String> referenceId,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$NotificationsTableUpdateCompanionBuilder =
    NotificationsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> body,
      Value<NotificationType> type,
      Value<String> referenceId,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NotificationType, NotificationType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationsTable,
          Notification,
          $$NotificationsTableFilterComposer,
          $$NotificationsTableOrderingComposer,
          $$NotificationsTableAnnotationComposer,
          $$NotificationsTableCreateCompanionBuilder,
          $$NotificationsTableUpdateCompanionBuilder,
          (
            Notification,
            BaseReferences<_$AppDatabase, $NotificationsTable, Notification>,
          ),
          Notification,
          PrefetchHooks Function()
        > {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<NotificationType> type = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationsCompanion(
                id: id,
                userId: userId,
                title: title,
                body: body,
                type: type,
                referenceId: referenceId,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                required String body,
                required NotificationType type,
                Value<String> referenceId = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                body: body,
                type: type,
                referenceId: referenceId,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationsTable,
      Notification,
      $$NotificationsTableFilterComposer,
      $$NotificationsTableOrderingComposer,
      $$NotificationsTableAnnotationComposer,
      $$NotificationsTableCreateCompanionBuilder,
      $$NotificationsTableUpdateCompanionBuilder,
      (
        Notification,
        BaseReferences<_$AppDatabase, $NotificationsTable, Notification>,
      ),
      Notification,
      PrefetchHooks Function()
    >;
typedef $$CampaignsTableCreateCompanionBuilder =
    CampaignsCompanion Function({
      required String id,
      required String name,
      required DateTime startDate,
      required DateTime endDate,
      Value<String> description,
      Value<String> targetDoctors,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$CampaignsTableUpdateCompanionBuilder =
    CampaignsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> description,
      Value<String> targetDoctors,
      Value<String> status,
      Value<int> rowid,
    });

class $$CampaignsTableFilterComposer
    extends Composer<_$AppDatabase, $CampaignsTable> {
  $$CampaignsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetDoctors => $composableBuilder(
    column: $table.targetDoctors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CampaignsTableOrderingComposer
    extends Composer<_$AppDatabase, $CampaignsTable> {
  $$CampaignsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetDoctors => $composableBuilder(
    column: $table.targetDoctors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CampaignsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CampaignsTable> {
  $$CampaignsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetDoctors => $composableBuilder(
    column: $table.targetDoctors,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$CampaignsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CampaignsTable,
          Campaign,
          $$CampaignsTableFilterComposer,
          $$CampaignsTableOrderingComposer,
          $$CampaignsTableAnnotationComposer,
          $$CampaignsTableCreateCompanionBuilder,
          $$CampaignsTableUpdateCompanionBuilder,
          (Campaign, BaseReferences<_$AppDatabase, $CampaignsTable, Campaign>),
          Campaign,
          PrefetchHooks Function()
        > {
  $$CampaignsTableTableManager(_$AppDatabase db, $CampaignsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CampaignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CampaignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CampaignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> targetDoctors = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CampaignsCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                description: description,
                targetDoctors: targetDoctors,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime startDate,
                required DateTime endDate,
                Value<String> description = const Value.absent(),
                Value<String> targetDoctors = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CampaignsCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                description: description,
                targetDoctors: targetDoctors,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CampaignsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CampaignsTable,
      Campaign,
      $$CampaignsTableFilterComposer,
      $$CampaignsTableOrderingComposer,
      $$CampaignsTableAnnotationComposer,
      $$CampaignsTableCreateCompanionBuilder,
      $$CampaignsTableUpdateCompanionBuilder,
      (Campaign, BaseReferences<_$AppDatabase, $CampaignsTable, Campaign>),
      Campaign,
      PrefetchHooks Function()
    >;
typedef $$EDetailContentsTableCreateCompanionBuilder =
    EDetailContentsCompanion Function({
      required String id,
      required String productId,
      required String title,
      Value<String> type,
      Value<String> url,
      Value<String> version,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$EDetailContentsTableUpdateCompanionBuilder =
    EDetailContentsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> title,
      Value<String> type,
      Value<String> url,
      Value<String> version,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$EDetailContentsTableFilterComposer
    extends Composer<_$AppDatabase, $EDetailContentsTable> {
  $$EDetailContentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EDetailContentsTableOrderingComposer
    extends Composer<_$AppDatabase, $EDetailContentsTable> {
  $$EDetailContentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EDetailContentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EDetailContentsTable> {
  $$EDetailContentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$EDetailContentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EDetailContentsTable,
          EDetailContent,
          $$EDetailContentsTableFilterComposer,
          $$EDetailContentsTableOrderingComposer,
          $$EDetailContentsTableAnnotationComposer,
          $$EDetailContentsTableCreateCompanionBuilder,
          $$EDetailContentsTableUpdateCompanionBuilder,
          (
            EDetailContent,
            BaseReferences<
              _$AppDatabase,
              $EDetailContentsTable,
              EDetailContent
            >,
          ),
          EDetailContent,
          PrefetchHooks Function()
        > {
  $$EDetailContentsTableTableManager(
    _$AppDatabase db,
    $EDetailContentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EDetailContentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EDetailContentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EDetailContentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EDetailContentsCompanion(
                id: id,
                productId: productId,
                title: title,
                type: type,
                url: url,
                version: version,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String title,
                Value<String> type = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EDetailContentsCompanion.insert(
                id: id,
                productId: productId,
                title: title,
                type: type,
                url: url,
                version: version,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EDetailContentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EDetailContentsTable,
      EDetailContent,
      $$EDetailContentsTableFilterComposer,
      $$EDetailContentsTableOrderingComposer,
      $$EDetailContentsTableAnnotationComposer,
      $$EDetailContentsTableCreateCompanionBuilder,
      $$EDetailContentsTableUpdateCompanionBuilder,
      (
        EDetailContent,
        BaseReferences<_$AppDatabase, $EDetailContentsTable, EDetailContent>,
      ),
      EDetailContent,
      PrefetchHooks Function()
    >;
typedef $$TargetsTableCreateCompanionBuilder =
    TargetsCompanion Function({
      required String id,
      required String mrId,
      Value<String> productId,
      required TargetType targetType,
      Value<double> targetValue,
      Value<double> achievedValue,
      required String period,
      Value<int> rowid,
    });
typedef $$TargetsTableUpdateCompanionBuilder =
    TargetsCompanion Function({
      Value<String> id,
      Value<String> mrId,
      Value<String> productId,
      Value<TargetType> targetType,
      Value<double> targetValue,
      Value<double> achievedValue,
      Value<String> period,
      Value<int> rowid,
    });

class $$TargetsTableFilterComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TargetType, TargetType, int> get targetType =>
      $composableBuilder(
        column: $table.targetType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get achievedValue => $composableBuilder(
    column: $table.achievedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get achievedValue => $composableBuilder(
    column: $table.achievedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TargetType, int> get targetType =>
      $composableBuilder(
        column: $table.targetType,
        builder: (column) => column,
      );

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get achievedValue => $composableBuilder(
    column: $table.achievedValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);
}

class $$TargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TargetsTable,
          Target,
          $$TargetsTableFilterComposer,
          $$TargetsTableOrderingComposer,
          $$TargetsTableAnnotationComposer,
          $$TargetsTableCreateCompanionBuilder,
          $$TargetsTableUpdateCompanionBuilder,
          (Target, BaseReferences<_$AppDatabase, $TargetsTable, Target>),
          Target,
          PrefetchHooks Function()
        > {
  $$TargetsTableTableManager(_$AppDatabase db, $TargetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<TargetType> targetType = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<double> achievedValue = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TargetsCompanion(
                id: id,
                mrId: mrId,
                productId: productId,
                targetType: targetType,
                targetValue: targetValue,
                achievedValue: achievedValue,
                period: period,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mrId,
                Value<String> productId = const Value.absent(),
                required TargetType targetType,
                Value<double> targetValue = const Value.absent(),
                Value<double> achievedValue = const Value.absent(),
                required String period,
                Value<int> rowid = const Value.absent(),
              }) => TargetsCompanion.insert(
                id: id,
                mrId: mrId,
                productId: productId,
                targetType: targetType,
                targetValue: targetValue,
                achievedValue: achievedValue,
                period: period,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TargetsTable,
      Target,
      $$TargetsTableFilterComposer,
      $$TargetsTableOrderingComposer,
      $$TargetsTableAnnotationComposer,
      $$TargetsTableCreateCompanionBuilder,
      $$TargetsTableUpdateCompanionBuilder,
      (Target, BaseReferences<_$AppDatabase, $TargetsTable, Target>),
      Target,
      PrefetchHooks Function()
    >;
typedef $$ActivityLogsTableCreateCompanionBuilder =
    ActivityLogsCompanion Function({
      required String id,
      required String userId,
      required String action,
      required String entityType,
      Value<String> entityId,
      Value<String> details,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });
typedef $$ActivityLogsTableUpdateCompanionBuilder =
    ActivityLogsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> action,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> details,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

class $$ActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ActivityLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogsTable,
          ActivityLog,
          $$ActivityLogsTableFilterComposer,
          $$ActivityLogsTableOrderingComposer,
          $$ActivityLogsTableAnnotationComposer,
          $$ActivityLogsTableCreateCompanionBuilder,
          $$ActivityLogsTableUpdateCompanionBuilder,
          (
            ActivityLog,
            BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>,
          ),
          ActivityLog,
          PrefetchHooks Function()
        > {
  $$ActivityLogsTableTableManager(_$AppDatabase db, $ActivityLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> details = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogsCompanion(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                details: details,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String action,
                required String entityType,
                Value<String> entityId = const Value.absent(),
                Value<String> details = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogsCompanion.insert(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                details: details,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogsTable,
      ActivityLog,
      $$ActivityLogsTableFilterComposer,
      $$ActivityLogsTableOrderingComposer,
      $$ActivityLogsTableAnnotationComposer,
      $$ActivityLogsTableCreateCompanionBuilder,
      $$ActivityLogsTableUpdateCompanionBuilder,
      (
        ActivityLog,
        BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>,
      ),
      ActivityLog,
      PrefetchHooks Function()
    >;
typedef $$TerritoriesTableCreateCompanionBuilder =
    TerritoriesCompanion Function({
      required String id,
      required String name,
      Value<String> parentId,
      Value<int> level,
      Value<String> boundaries,
      Value<int> rowid,
    });
typedef $$TerritoriesTableUpdateCompanionBuilder =
    TerritoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> parentId,
      Value<int> level,
      Value<String> boundaries,
      Value<int> rowid,
    });

class $$TerritoriesTableFilterComposer
    extends Composer<_$AppDatabase, $TerritoriesTable> {
  $$TerritoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get boundaries => $composableBuilder(
    column: $table.boundaries,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TerritoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TerritoriesTable> {
  $$TerritoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boundaries => $composableBuilder(
    column: $table.boundaries,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TerritoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TerritoriesTable> {
  $$TerritoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get boundaries => $composableBuilder(
    column: $table.boundaries,
    builder: (column) => column,
  );
}

class $$TerritoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TerritoriesTable,
          Territory,
          $$TerritoriesTableFilterComposer,
          $$TerritoriesTableOrderingComposer,
          $$TerritoriesTableAnnotationComposer,
          $$TerritoriesTableCreateCompanionBuilder,
          $$TerritoriesTableUpdateCompanionBuilder,
          (
            Territory,
            BaseReferences<_$AppDatabase, $TerritoriesTable, Territory>,
          ),
          Territory,
          PrefetchHooks Function()
        > {
  $$TerritoriesTableTableManager(_$AppDatabase db, $TerritoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TerritoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TerritoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TerritoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> boundaries = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TerritoriesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                level: level,
                boundaries: boundaries,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> parentId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> boundaries = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TerritoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                level: level,
                boundaries: boundaries,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TerritoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TerritoriesTable,
      Territory,
      $$TerritoriesTableFilterComposer,
      $$TerritoriesTableOrderingComposer,
      $$TerritoriesTableAnnotationComposer,
      $$TerritoriesTableCreateCompanionBuilder,
      $$TerritoriesTableUpdateCompanionBuilder,
      (Territory, BaseReferences<_$AppDatabase, $TerritoriesTable, Territory>),
      Territory,
      PrefetchHooks Function()
    >;
typedef $$StockLedgersTableCreateCompanionBuilder =
    StockLedgersCompanion Function({
      required String id,
      required String productId,
      required String mrId,
      Value<int> openingStock,
      Value<int> received,
      Value<int> distributed,
      Value<int> closingStock,
      required DateTime date,
      Value<int> rowid,
    });
typedef $$StockLedgersTableUpdateCompanionBuilder =
    StockLedgersCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> mrId,
      Value<int> openingStock,
      Value<int> received,
      Value<int> distributed,
      Value<int> closingStock,
      Value<DateTime> date,
      Value<int> rowid,
    });

class $$StockLedgersTableFilterComposer
    extends Composer<_$AppDatabase, $StockLedgersTable> {
  $$StockLedgersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingStock => $composableBuilder(
    column: $table.openingStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get received => $composableBuilder(
    column: $table.received,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distributed => $composableBuilder(
    column: $table.distributed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closingStock => $composableBuilder(
    column: $table.closingStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockLedgersTableOrderingComposer
    extends Composer<_$AppDatabase, $StockLedgersTable> {
  $$StockLedgersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mrId => $composableBuilder(
    column: $table.mrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingStock => $composableBuilder(
    column: $table.openingStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get received => $composableBuilder(
    column: $table.received,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distributed => $composableBuilder(
    column: $table.distributed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closingStock => $composableBuilder(
    column: $table.closingStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockLedgersTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockLedgersTable> {
  $$StockLedgersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get mrId =>
      $composableBuilder(column: $table.mrId, builder: (column) => column);

  GeneratedColumn<int> get openingStock => $composableBuilder(
    column: $table.openingStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get received =>
      $composableBuilder(column: $table.received, builder: (column) => column);

  GeneratedColumn<int> get distributed => $composableBuilder(
    column: $table.distributed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get closingStock => $composableBuilder(
    column: $table.closingStock,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$StockLedgersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockLedgersTable,
          StockLedger,
          $$StockLedgersTableFilterComposer,
          $$StockLedgersTableOrderingComposer,
          $$StockLedgersTableAnnotationComposer,
          $$StockLedgersTableCreateCompanionBuilder,
          $$StockLedgersTableUpdateCompanionBuilder,
          (
            StockLedger,
            BaseReferences<_$AppDatabase, $StockLedgersTable, StockLedger>,
          ),
          StockLedger,
          PrefetchHooks Function()
        > {
  $$StockLedgersTableTableManager(_$AppDatabase db, $StockLedgersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockLedgersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockLedgersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockLedgersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> mrId = const Value.absent(),
                Value<int> openingStock = const Value.absent(),
                Value<int> received = const Value.absent(),
                Value<int> distributed = const Value.absent(),
                Value<int> closingStock = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockLedgersCompanion(
                id: id,
                productId: productId,
                mrId: mrId,
                openingStock: openingStock,
                received: received,
                distributed: distributed,
                closingStock: closingStock,
                date: date,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String mrId,
                Value<int> openingStock = const Value.absent(),
                Value<int> received = const Value.absent(),
                Value<int> distributed = const Value.absent(),
                Value<int> closingStock = const Value.absent(),
                required DateTime date,
                Value<int> rowid = const Value.absent(),
              }) => StockLedgersCompanion.insert(
                id: id,
                productId: productId,
                mrId: mrId,
                openingStock: openingStock,
                received: received,
                distributed: distributed,
                closingStock: closingStock,
                date: date,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockLedgersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockLedgersTable,
      StockLedger,
      $$StockLedgersTableFilterComposer,
      $$StockLedgersTableOrderingComposer,
      $$StockLedgersTableAnnotationComposer,
      $$StockLedgersTableCreateCompanionBuilder,
      $$StockLedgersTableUpdateCompanionBuilder,
      (
        StockLedger,
        BaseReferences<_$AppDatabase, $StockLedgersTable, StockLedger>,
      ),
      StockLedger,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
  $$DoctorsTableTableManager get doctors =>
      $$DoctorsTableTableManager(_db, _db.doctors);
  $$DcrsTableTableManager get dcrs => $$DcrsTableTableManager(_db, _db.dcrs);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$VisitsTableTableManager get visits =>
      $$VisitsTableTableManager(_db, _db.visits);
  $$RecommendationsTableTableManager get recommendations =>
      $$RecommendationsTableTableManager(_db, _db.recommendations);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$SamplesTableTableManager get samples =>
      $$SamplesTableTableManager(_db, _db.samples);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$TourPlansTableTableManager get tourPlans =>
      $$TourPlansTableTableManager(_db, _db.tourPlans);
  $$TourPlanDaysTableTableManager get tourPlanDays =>
      $$TourPlanDaysTableTableManager(_db, _db.tourPlanDays);
  $$AttendancesTableTableManager get attendances =>
      $$AttendancesTableTableManager(_db, _db.attendances);
  $$LeaveRequestsTableTableManager get leaveRequests =>
      $$LeaveRequestsTableTableManager(_db, _db.leaveRequests);
  $$LeaveBalancesTableTableManager get leaveBalances =>
      $$LeaveBalancesTableTableManager(_db, _db.leaveBalances);
  $$ApprovalsTableTableManager get approvals =>
      $$ApprovalsTableTableManager(_db, _db.approvals);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
  $$CampaignsTableTableManager get campaigns =>
      $$CampaignsTableTableManager(_db, _db.campaigns);
  $$EDetailContentsTableTableManager get eDetailContents =>
      $$EDetailContentsTableTableManager(_db, _db.eDetailContents);
  $$TargetsTableTableManager get targets =>
      $$TargetsTableTableManager(_db, _db.targets);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
  $$TerritoriesTableTableManager get territories =>
      $$TerritoriesTableTableManager(_db, _db.territories);
  $$StockLedgersTableTableManager get stockLedgers =>
      $$StockLedgersTableTableManager(_db, _db.stockLedgers);
}
