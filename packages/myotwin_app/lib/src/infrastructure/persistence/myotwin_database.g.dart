// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myotwin_database.dart';

// ignore_for_file: type=lint
class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GoalStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GoalStatus>($GoalsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GoalMetadata, String> metadata =
      GeneratedColumn<String>(
        'metadata',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GoalMetadata>($GoalsTable.$convertermetadata);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    status,
    createdAt,
    updatedAt,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      status: $GoalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      metadata: $GoalsTable.$convertermetadata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metadata'],
        )!,
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GoalStatus, String, String> $converterstatus =
      const EnumNameConverter(GoalStatus.values);
  static TypeConverter<GoalMetadata, String> $convertermetadata =
      const GoalMetadataConverter();
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String label;
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// JSONB metadata wrapped in GoalMetadata extension type.
  final GoalMetadata metadata;
  const Goal({
    required this.id,
    required this.label,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    {
      map['status'] = Variable<String>(
        $GoalsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    {
      map['metadata'] = Variable<String>(
        $GoalsTable.$convertermetadata.toSql(metadata),
      );
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      label: Value(label),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      metadata: Value(metadata),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      status: $GoalsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      metadata: serializer.fromJson<GoalMetadata>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'status': serializer.toJson<String>(
        $GoalsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'metadata': serializer.toJson<GoalMetadata>(metadata),
    };
  }

  Goal copyWith({
    String? id,
    String? label,
    GoalStatus? status,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    GoalMetadata? metadata,
  }) => Goal(
    id: id ?? this.id,
    label: label ?? this.label,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    metadata: metadata ?? this.metadata,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, status, createdAt, updatedAt, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.label == this.label &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.metadata == this.metadata);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> label;
  final Value<GoalStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<GoalMetadata> metadata;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String label,
    required GoalStatus status,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    required GoalMetadata metadata,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       status = Value(status),
       createdAt = Value(createdAt),
       metadata = Value(metadata);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<GoalStatus>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<GoalMetadata>? metadata,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $GoalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
        $GoalsTable.$convertermetadata.toSql(metadata.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntentRecordsTable extends IntentRecords
    with TableInfo<$IntentRecordsTable, IntentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<IntentType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IntentType>($IntentRecordsTable.$convertertype);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledTime =
      GeneratedColumn<DateTime>(
        'scheduled_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deliveredAtMeta = const VerificationMeta(
    'deliveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
    'delivered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userEngagementScoreMeta =
      const VerificationMeta('userEngagementScore');
  @override
  late final GeneratedColumn<double> userEngagementScore =
      GeneratedColumn<double>(
        'user_engagement_score',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IntentPayload, String> payload =
      GeneratedColumn<String>(
        'payload',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IntentPayload>($IntentRecordsTable.$converterpayload);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    type,
    createdAt,
    scheduledTime,
    deliveredAt,
    userEngagementScore,
    reason,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intent_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<IntentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
        _deliveredAtMeta,
        deliveredAt.isAcceptableOrUnknown(
          data['delivered_at']!,
          _deliveredAtMeta,
        ),
      );
    }
    if (data.containsKey('user_engagement_score')) {
      context.handle(
        _userEngagementScoreMeta,
        userEngagementScore.isAcceptableOrUnknown(
          data['user_engagement_score']!,
          _userEngagementScoreMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      type: $IntentRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_time'],
      )!,
      deliveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivered_at'],
      ),
      userEngagementScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}user_engagement_score'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      payload: $IntentRecordsTable.$converterpayload.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payload'],
        )!,
      ),
    );
  }

  @override
  $IntentRecordsTable createAlias(String alias) {
    return $IntentRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IntentType, String, String> $convertertype =
      const EnumNameConverter(IntentType.values);
  static TypeConverter<IntentPayload, String> $converterpayload =
      const IntentPayloadConverter();
}

class IntentRecord extends DataClass implements Insertable<IntentRecord> {
  final String id;
  final String goalId;
  final IntentType type;
  final DateTime createdAt;
  final DateTime scheduledTime;
  final DateTime? deliveredAt;
  final double? userEngagementScore;
  final String reason;

  /// JSONB GenUI payload wrapped in IntentPayload extension type.
  final IntentPayload payload;
  const IntentRecord({
    required this.id,
    required this.goalId,
    required this.type,
    required this.createdAt,
    required this.scheduledTime,
    this.deliveredAt,
    this.userEngagementScore,
    required this.reason,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    {
      map['type'] = Variable<String>(
        $IntentRecordsTable.$convertertype.toSql(type),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['scheduled_time'] = Variable<DateTime>(scheduledTime);
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    if (!nullToAbsent || userEngagementScore != null) {
      map['user_engagement_score'] = Variable<double>(userEngagementScore);
    }
    map['reason'] = Variable<String>(reason);
    {
      map['payload'] = Variable<String>(
        $IntentRecordsTable.$converterpayload.toSql(payload),
      );
    }
    return map;
  }

  IntentRecordsCompanion toCompanion(bool nullToAbsent) {
    return IntentRecordsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      type: Value(type),
      createdAt: Value(createdAt),
      scheduledTime: Value(scheduledTime),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
      userEngagementScore: userEngagementScore == null && nullToAbsent
          ? const Value.absent()
          : Value(userEngagementScore),
      reason: Value(reason),
      payload: Value(payload),
    );
  }

  factory IntentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntentRecord(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      type: $IntentRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      scheduledTime: serializer.fromJson<DateTime>(json['scheduledTime']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
      userEngagementScore: serializer.fromJson<double?>(
        json['userEngagementScore'],
      ),
      reason: serializer.fromJson<String>(json['reason']),
      payload: serializer.fromJson<IntentPayload>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'type': serializer.toJson<String>(
        $IntentRecordsTable.$convertertype.toJson(type),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'scheduledTime': serializer.toJson<DateTime>(scheduledTime),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
      'userEngagementScore': serializer.toJson<double?>(userEngagementScore),
      'reason': serializer.toJson<String>(reason),
      'payload': serializer.toJson<IntentPayload>(payload),
    };
  }

  IntentRecord copyWith({
    String? id,
    String? goalId,
    IntentType? type,
    DateTime? createdAt,
    DateTime? scheduledTime,
    Value<DateTime?> deliveredAt = const Value.absent(),
    Value<double?> userEngagementScore = const Value.absent(),
    String? reason,
    IntentPayload? payload,
  }) => IntentRecord(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    scheduledTime: scheduledTime ?? this.scheduledTime,
    deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
    userEngagementScore: userEngagementScore.present
        ? userEngagementScore.value
        : this.userEngagementScore,
    reason: reason ?? this.reason,
    payload: payload ?? this.payload,
  );
  IntentRecord copyWithCompanion(IntentRecordsCompanion data) {
    return IntentRecord(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      deliveredAt: data.deliveredAt.present
          ? data.deliveredAt.value
          : this.deliveredAt,
      userEngagementScore: data.userEngagementScore.present
          ? data.userEngagementScore.value
          : this.userEngagementScore,
      reason: data.reason.present ? data.reason.value : this.reason,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntentRecord(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('userEngagementScore: $userEngagementScore, ')
          ..write('reason: $reason, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalId,
    type,
    createdAt,
    scheduledTime,
    deliveredAt,
    userEngagementScore,
    reason,
    payload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntentRecord &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.scheduledTime == this.scheduledTime &&
          other.deliveredAt == this.deliveredAt &&
          other.userEngagementScore == this.userEngagementScore &&
          other.reason == this.reason &&
          other.payload == this.payload);
}

class IntentRecordsCompanion extends UpdateCompanion<IntentRecord> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<IntentType> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> scheduledTime;
  final Value<DateTime?> deliveredAt;
  final Value<double?> userEngagementScore;
  final Value<String> reason;
  final Value<IntentPayload> payload;
  final Value<int> rowid;
  const IntentRecordsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.userEngagementScore = const Value.absent(),
    this.reason = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntentRecordsCompanion.insert({
    required String id,
    required String goalId,
    required IntentType type,
    required DateTime createdAt,
    required DateTime scheduledTime,
    this.deliveredAt = const Value.absent(),
    this.userEngagementScore = const Value.absent(),
    required String reason,
    required IntentPayload payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       type = Value(type),
       createdAt = Value(createdAt),
       scheduledTime = Value(scheduledTime),
       reason = Value(reason),
       payload = Value(payload);
  static Insertable<IntentRecord> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? scheduledTime,
    Expression<DateTime>? deliveredAt,
    Expression<double>? userEngagementScore,
    Expression<String>? reason,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (userEngagementScore != null)
        'user_engagement_score': userEngagementScore,
      if (reason != null) 'reason': reason,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntentRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<IntentType>? type,
    Value<DateTime>? createdAt,
    Value<DateTime>? scheduledTime,
    Value<DateTime?>? deliveredAt,
    Value<double?>? userEngagementScore,
    Value<String>? reason,
    Value<IntentPayload>? payload,
    Value<int>? rowid,
  }) {
    return IntentRecordsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      userEngagementScore: userEngagementScore ?? this.userEngagementScore,
      reason: reason ?? this.reason,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $IntentRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<DateTime>(scheduledTime.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (userEngagementScore.present) {
      map['user_engagement_score'] = Variable<double>(
        userEngagementScore.value,
      );
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(
        $IntentRecordsTable.$converterpayload.toSql(payload.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('userEngagementScore: $userEngagementScore, ')
          ..write('reason: $reason, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyoTwinDatabase extends GeneratedDatabase {
  _$MyoTwinDatabase(QueryExecutor e) : super(e);
  $MyoTwinDatabaseManager get managers => $MyoTwinDatabaseManager(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $IntentRecordsTable intentRecords = $IntentRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [goals, intentRecords];
}

typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      required String id,
      required String label,
      required GoalStatus status,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      required GoalMetadata metadata,
      Value<int> rowid,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<GoalStatus> status,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<GoalMetadata> metadata,
      Value<int> rowid,
    });

final class $$GoalsTableReferences
    extends BaseReferences<_$MyoTwinDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IntentRecordsTable, List<IntentRecord>>
  _intentRecordsRefsTable(_$MyoTwinDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.intentRecords,
        aliasName: $_aliasNameGenerator(db.goals.id, db.intentRecords.goalId),
      );

  $$IntentRecordsTableProcessedTableManager get intentRecordsRefs {
    final manager = $$IntentRecordsTableTableManager(
      $_db,
      $_db.intentRecords,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_intentRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalsTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GoalStatus, GoalStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GoalMetadata, GoalMetadata, String>
  get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> intentRecordsRefs(
    Expression<bool> Function($$IntentRecordsTableFilterComposer f) f,
  ) {
    final $$IntentRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.intentRecords,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntentRecordsTableFilterComposer(
            $db: $db,
            $table: $db.intentRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GoalStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GoalMetadata, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  Expression<T> intentRecordsRefs<T extends Object>(
    Expression<T> Function($$IntentRecordsTableAnnotationComposer a) f,
  ) {
    final $$IntentRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.intentRecords,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntentRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.intentRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, $$GoalsTableReferences),
          Goal,
          PrefetchHooks Function({bool intentRecordsRefs})
        > {
  $$GoalsTableTableManager(_$MyoTwinDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<GoalStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<GoalMetadata> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                label: label,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required GoalStatus status,
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                required GoalMetadata metadata,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                label: label,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoalsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({intentRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (intentRecordsRefs) db.intentRecords,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (intentRecordsRefs)
                    await $_getPrefetchedData<Goal, $GoalsTable, IntentRecord>(
                      currentTable: table,
                      referencedTable: $$GoalsTableReferences
                          ._intentRecordsRefsTable(db),
                      managerFromTypedResult: (p0) => $$GoalsTableReferences(
                        db,
                        table,
                        p0,
                      ).intentRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.goalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, $$GoalsTableReferences),
      Goal,
      PrefetchHooks Function({bool intentRecordsRefs})
    >;
typedef $$IntentRecordsTableCreateCompanionBuilder =
    IntentRecordsCompanion Function({
      required String id,
      required String goalId,
      required IntentType type,
      required DateTime createdAt,
      required DateTime scheduledTime,
      Value<DateTime?> deliveredAt,
      Value<double?> userEngagementScore,
      required String reason,
      required IntentPayload payload,
      Value<int> rowid,
    });
typedef $$IntentRecordsTableUpdateCompanionBuilder =
    IntentRecordsCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<IntentType> type,
      Value<DateTime> createdAt,
      Value<DateTime> scheduledTime,
      Value<DateTime?> deliveredAt,
      Value<double?> userEngagementScore,
      Value<String> reason,
      Value<IntentPayload> payload,
      Value<int> rowid,
    });

final class $$IntentRecordsTableReferences
    extends
        BaseReferences<_$MyoTwinDatabase, $IntentRecordsTable, IntentRecord> {
  $$IntentRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GoalsTable _goalIdTable(_$MyoTwinDatabase db) => db.goals.createAlias(
    $_aliasNameGenerator(db.intentRecords.goalId, db.goals.id),
  );

  $$GoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IntentRecordsTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $IntentRecordsTable> {
  $$IntentRecordsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<IntentType, IntentType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get userEngagementScore => $composableBuilder(
    column: $table.userEngagementScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IntentPayload, IntentPayload, String>
  get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntentRecordsTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $IntentRecordsTable> {
  $$IntentRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get userEngagementScore => $composableBuilder(
    column: $table.userEngagementScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntentRecordsTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $IntentRecordsTable> {
  $$IntentRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IntentType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get userEngagementScore => $composableBuilder(
    column: $table.userEngagementScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IntentPayload, String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntentRecordsTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $IntentRecordsTable,
          IntentRecord,
          $$IntentRecordsTableFilterComposer,
          $$IntentRecordsTableOrderingComposer,
          $$IntentRecordsTableAnnotationComposer,
          $$IntentRecordsTableCreateCompanionBuilder,
          $$IntentRecordsTableUpdateCompanionBuilder,
          (IntentRecord, $$IntentRecordsTableReferences),
          IntentRecord,
          PrefetchHooks Function({bool goalId})
        > {
  $$IntentRecordsTableTableManager(
    _$MyoTwinDatabase db,
    $IntentRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntentRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntentRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntentRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<IntentType> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> scheduledTime = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<double?> userEngagementScore = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<IntentPayload> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntentRecordsCompanion(
                id: id,
                goalId: goalId,
                type: type,
                createdAt: createdAt,
                scheduledTime: scheduledTime,
                deliveredAt: deliveredAt,
                userEngagementScore: userEngagementScore,
                reason: reason,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required IntentType type,
                required DateTime createdAt,
                required DateTime scheduledTime,
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<double?> userEngagementScore = const Value.absent(),
                required String reason,
                required IntentPayload payload,
                Value<int> rowid = const Value.absent(),
              }) => IntentRecordsCompanion.insert(
                id: id,
                goalId: goalId,
                type: type,
                createdAt: createdAt,
                scheduledTime: scheduledTime,
                deliveredAt: deliveredAt,
                userEngagementScore: userEngagementScore,
                reason: reason,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IntentRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
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
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable: $$IntentRecordsTableReferences
                                    ._goalIdTable(db),
                                referencedColumn: $$IntentRecordsTableReferences
                                    ._goalIdTable(db)
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

typedef $$IntentRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $IntentRecordsTable,
      IntentRecord,
      $$IntentRecordsTableFilterComposer,
      $$IntentRecordsTableOrderingComposer,
      $$IntentRecordsTableAnnotationComposer,
      $$IntentRecordsTableCreateCompanionBuilder,
      $$IntentRecordsTableUpdateCompanionBuilder,
      (IntentRecord, $$IntentRecordsTableReferences),
      IntentRecord,
      PrefetchHooks Function({bool goalId})
    >;

class $MyoTwinDatabaseManager {
  final _$MyoTwinDatabase _db;
  $MyoTwinDatabaseManager(this._db);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$IntentRecordsTableTableManager get intentRecords =>
      $$IntentRecordsTableTableManager(_db, _db.intentRecords);
}
