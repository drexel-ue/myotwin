// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExercisesTableTable extends ExercisesTable
    with TableInfo<$ExercisesTableTable, ExercisesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMusclesMeta = const VerificationMeta(
    'targetMuscles',
  );
  @override
  late final GeneratedColumn<String> targetMuscles = GeneratedColumn<String>(
    'target_muscles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiredEquipmentMeta = const VerificationMeta(
    'requiredEquipment',
  );
  @override
  late final GeneratedColumn<String> requiredEquipment =
      GeneratedColumn<String>(
        'required_equipment',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ringHeightMeta = const VerificationMeta(
    'ringHeight',
  );
  @override
  late final GeneratedColumn<double> ringHeight = GeneratedColumn<double>(
    'ring_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecsMeta = const VerificationMeta(
    'durationSecs',
  );
  @override
  late final GeneratedColumn<int> durationSecs = GeneratedColumn<int>(
    'duration_secs',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scientificRationaleMeta =
      const VerificationMeta('scientificRationale');
  @override
  late final GeneratedColumn<String> scientificRationale =
      GeneratedColumn<String>(
        'scientific_rationale',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _equipmentNotesMeta = const VerificationMeta(
    'equipmentNotes',
  );
  @override
  late final GeneratedColumn<String> equipmentNotes = GeneratedColumn<String>(
    'equipment_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    category,
    targetMuscles,
    requiredEquipment,
    ringHeight,
    durationSecs,
    scientificRationale,
    equipmentNotes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExercisesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('target_muscles')) {
      context.handle(
        _targetMusclesMeta,
        targetMuscles.isAcceptableOrUnknown(
          data['target_muscles']!,
          _targetMusclesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetMusclesMeta);
    }
    if (data.containsKey('required_equipment')) {
      context.handle(
        _requiredEquipmentMeta,
        requiredEquipment.isAcceptableOrUnknown(
          data['required_equipment']!,
          _requiredEquipmentMeta,
        ),
      );
    }
    if (data.containsKey('ring_height')) {
      context.handle(
        _ringHeightMeta,
        ringHeight.isAcceptableOrUnknown(data['ring_height']!, _ringHeightMeta),
      );
    }
    if (data.containsKey('duration_secs')) {
      context.handle(
        _durationSecsMeta,
        durationSecs.isAcceptableOrUnknown(
          data['duration_secs']!,
          _durationSecsMeta,
        ),
      );
    }
    if (data.containsKey('scientific_rationale')) {
      context.handle(
        _scientificRationaleMeta,
        scientificRationale.isAcceptableOrUnknown(
          data['scientific_rationale']!,
          _scientificRationaleMeta,
        ),
      );
    }
    if (data.containsKey('equipment_notes')) {
      context.handle(
        _equipmentNotesMeta,
        equipmentNotes.isAcceptableOrUnknown(
          data['equipment_notes']!,
          _equipmentNotesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  ExercisesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExercisesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      targetMuscles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_muscles'],
      )!,
      requiredEquipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}required_equipment'],
      ),
      ringHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ring_height'],
      ),
      durationSecs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_secs'],
      ),
      scientificRationale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scientific_rationale'],
      ),
      equipmentNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExercisesTableTable createAlias(String alias) {
    return $ExercisesTableTable(attachedDatabase, alias);
  }
}

class ExercisesTableData extends DataClass
    implements Insertable<ExercisesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Exercise display name.
  final String name;

  /// Detailed description of the exercise form and execution.
  final String? description;

  /// Exercise category (e.g. cardio, strength, HIIT).
  final String category;

  /// Comma-separated list of target muscle groups.
  final String targetMuscles;

  /// Equipment required to perform the exercise.
  final String? requiredEquipment;

  /// Height of the ring in meters, used for biomechanical calculations.
  final double? ringHeight;

  /// Duration of the exercise in seconds.
  final int? durationSecs;

  /// Scientific rationale supporting the exercise design.
  final String? scientificRationale;

  /// Notes about equipment configuration and usage.
  final String? equipmentNotes;

  /// Timestamp when the exercise record was created.
  final DateTime createdAt;

  /// Timestamp when the exercise record was last updated.
  final DateTime updatedAt;
  const ExercisesTableData({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.targetMuscles,
    this.requiredEquipment,
    this.ringHeight,
    this.durationSecs,
    this.scientificRationale,
    this.equipmentNotes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['target_muscles'] = Variable<String>(targetMuscles);
    if (!nullToAbsent || requiredEquipment != null) {
      map['required_equipment'] = Variable<String>(requiredEquipment);
    }
    if (!nullToAbsent || ringHeight != null) {
      map['ring_height'] = Variable<double>(ringHeight);
    }
    if (!nullToAbsent || durationSecs != null) {
      map['duration_secs'] = Variable<int>(durationSecs);
    }
    if (!nullToAbsent || scientificRationale != null) {
      map['scientific_rationale'] = Variable<String>(scientificRationale);
    }
    if (!nullToAbsent || equipmentNotes != null) {
      map['equipment_notes'] = Variable<String>(equipmentNotes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExercisesTableCompanion toCompanion(bool nullToAbsent) {
    return ExercisesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      targetMuscles: Value(targetMuscles),
      requiredEquipment: requiredEquipment == null && nullToAbsent
          ? const Value.absent()
          : Value(requiredEquipment),
      ringHeight: ringHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(ringHeight),
      durationSecs: durationSecs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSecs),
      scientificRationale: scientificRationale == null && nullToAbsent
          ? const Value.absent()
          : Value(scientificRationale),
      equipmentNotes: equipmentNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentNotes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExercisesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExercisesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      targetMuscles: serializer.fromJson<String>(json['targetMuscles']),
      requiredEquipment: serializer.fromJson<String?>(
        json['requiredEquipment'],
      ),
      ringHeight: serializer.fromJson<double?>(json['ringHeight']),
      durationSecs: serializer.fromJson<int?>(json['durationSecs']),
      scientificRationale: serializer.fromJson<String?>(
        json['scientificRationale'],
      ),
      equipmentNotes: serializer.fromJson<String?>(json['equipmentNotes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'targetMuscles': serializer.toJson<String>(targetMuscles),
      'requiredEquipment': serializer.toJson<String?>(requiredEquipment),
      'ringHeight': serializer.toJson<double?>(ringHeight),
      'durationSecs': serializer.toJson<int?>(durationSecs),
      'scientificRationale': serializer.toJson<String?>(scientificRationale),
      'equipmentNotes': serializer.toJson<String?>(equipmentNotes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExercisesTableData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? category,
    String? targetMuscles,
    Value<String?> requiredEquipment = const Value.absent(),
    Value<double?> ringHeight = const Value.absent(),
    Value<int?> durationSecs = const Value.absent(),
    Value<String?> scientificRationale = const Value.absent(),
    Value<String?> equipmentNotes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ExercisesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    category: category ?? this.category,
    targetMuscles: targetMuscles ?? this.targetMuscles,
    requiredEquipment: requiredEquipment.present
        ? requiredEquipment.value
        : this.requiredEquipment,
    ringHeight: ringHeight.present ? ringHeight.value : this.ringHeight,
    durationSecs: durationSecs.present ? durationSecs.value : this.durationSecs,
    scientificRationale: scientificRationale.present
        ? scientificRationale.value
        : this.scientificRationale,
    equipmentNotes: equipmentNotes.present
        ? equipmentNotes.value
        : this.equipmentNotes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExercisesTableData copyWithCompanion(ExercisesTableCompanion data) {
    return ExercisesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      targetMuscles: data.targetMuscles.present
          ? data.targetMuscles.value
          : this.targetMuscles,
      requiredEquipment: data.requiredEquipment.present
          ? data.requiredEquipment.value
          : this.requiredEquipment,
      ringHeight: data.ringHeight.present
          ? data.ringHeight.value
          : this.ringHeight,
      durationSecs: data.durationSecs.present
          ? data.durationSecs.value
          : this.durationSecs,
      scientificRationale: data.scientificRationale.present
          ? data.scientificRationale.value
          : this.scientificRationale,
      equipmentNotes: data.equipmentNotes.present
          ? data.equipmentNotes.value
          : this.equipmentNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('targetMuscles: $targetMuscles, ')
          ..write('requiredEquipment: $requiredEquipment, ')
          ..write('ringHeight: $ringHeight, ')
          ..write('durationSecs: $durationSecs, ')
          ..write('scientificRationale: $scientificRationale, ')
          ..write('equipmentNotes: $equipmentNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    category,
    targetMuscles,
    requiredEquipment,
    ringHeight,
    durationSecs,
    scientificRationale,
    equipmentNotes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExercisesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.targetMuscles == this.targetMuscles &&
          other.requiredEquipment == this.requiredEquipment &&
          other.ringHeight == this.ringHeight &&
          other.durationSecs == this.durationSecs &&
          other.scientificRationale == this.scientificRationale &&
          other.equipmentNotes == this.equipmentNotes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExercisesTableCompanion extends UpdateCompanion<ExercisesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> category;
  final Value<String> targetMuscles;
  final Value<String?> requiredEquipment;
  final Value<double?> ringHeight;
  final Value<int?> durationSecs;
  final Value<String?> scientificRationale;
  final Value<String?> equipmentNotes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExercisesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.targetMuscles = const Value.absent(),
    this.requiredEquipment = const Value.absent(),
    this.ringHeight = const Value.absent(),
    this.durationSecs = const Value.absent(),
    this.scientificRationale = const Value.absent(),
    this.equipmentNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExercisesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required String category,
    required String targetMuscles,
    this.requiredEquipment = const Value.absent(),
    this.ringHeight = const Value.absent(),
    this.durationSecs = const Value.absent(),
    this.scientificRationale = const Value.absent(),
    this.equipmentNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       targetMuscles = Value(targetMuscles);
  static Insertable<ExercisesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? targetMuscles,
    Expression<String>? requiredEquipment,
    Expression<double>? ringHeight,
    Expression<int>? durationSecs,
    Expression<String>? scientificRationale,
    Expression<String>? equipmentNotes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (targetMuscles != null) 'target_muscles': targetMuscles,
      if (requiredEquipment != null) 'required_equipment': requiredEquipment,
      if (ringHeight != null) 'ring_height': ringHeight,
      if (durationSecs != null) 'duration_secs': durationSecs,
      if (scientificRationale != null)
        'scientific_rationale': scientificRationale,
      if (equipmentNotes != null) 'equipment_notes': equipmentNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExercisesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? category,
    Value<String>? targetMuscles,
    Value<String?>? requiredEquipment,
    Value<double?>? ringHeight,
    Value<int?>? durationSecs,
    Value<String?>? scientificRationale,
    Value<String?>? equipmentNotes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExercisesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      requiredEquipment: requiredEquipment ?? this.requiredEquipment,
      ringHeight: ringHeight ?? this.ringHeight,
      durationSecs: durationSecs ?? this.durationSecs,
      scientificRationale: scientificRationale ?? this.scientificRationale,
      equipmentNotes: equipmentNotes ?? this.equipmentNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetMuscles.present) {
      map['target_muscles'] = Variable<String>(targetMuscles.value);
    }
    if (requiredEquipment.present) {
      map['required_equipment'] = Variable<String>(requiredEquipment.value);
    }
    if (ringHeight.present) {
      map['ring_height'] = Variable<double>(ringHeight.value);
    }
    if (durationSecs.present) {
      map['duration_secs'] = Variable<int>(durationSecs.value);
    }
    if (scientificRationale.present) {
      map['scientific_rationale'] = Variable<String>(scientificRationale.value);
    }
    if (equipmentNotes.present) {
      map['equipment_notes'] = Variable<String>(equipmentNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('targetMuscles: $targetMuscles, ')
          ..write('requiredEquipment: $requiredEquipment, ')
          ..write('ringHeight: $ringHeight, ')
          ..write('durationSecs: $durationSecs, ')
          ..write('scientificRationale: $scientificRationale, ')
          ..write('equipmentNotes: $equipmentNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutLogsTableTable extends WorkoutLogsTable
    with TableInfo<$WorkoutLogsTableTable, WorkoutLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutLogsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises_table (id)',
    ),
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<int> volume = GeneratedColumn<int>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecsMeta = const VerificationMeta(
    'durationSecs',
  );
  @override
  late final GeneratedColumn<int> durationSecs = GeneratedColumn<int>(
    'duration_secs',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<double> intensity = GeneratedColumn<double>(
    'intensity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    exerciseId,
    volume,
    durationSecs,
    notes,
    intensity,
    sourceType,
    logDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeMeta);
    }
    if (data.containsKey('duration_secs')) {
      context.handle(
        _durationSecsMeta,
        durationSecs.isAcceptableOrUnknown(
          data['duration_secs']!,
          _durationSecsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
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
  WorkoutLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume'],
      )!,
      durationSecs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_secs'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}intensity'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorkoutLogsTableTable createAlias(String alias) {
    return $WorkoutLogsTableTable(attachedDatabase, alias);
  }
}

class WorkoutLogsTableData extends DataClass
    implements Insertable<WorkoutLogsTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Foreign key reference to the linked exercise.
  final int exerciseId;

  /// Total volume of the workout (e.g. reps * weight).
  final int volume;

  /// Workout duration in seconds.
  final int? durationSecs;

  /// Additional notes about the workout session.
  final String? notes;

  /// Intensity score of the workout session.
  final double? intensity;

  /// Source type of the log (e.g. manual, device).
  final String sourceType;

  /// Date the workout was logged.
  final DateTime logDate;

  /// Timestamp when the log record was created.
  final DateTime createdAt;
  const WorkoutLogsTableData({
    required this.id,
    required this.exerciseId,
    required this.volume,
    this.durationSecs,
    this.notes,
    this.intensity,
    required this.sourceType,
    required this.logDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['volume'] = Variable<int>(volume);
    if (!nullToAbsent || durationSecs != null) {
      map['duration_secs'] = Variable<int>(durationSecs);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || intensity != null) {
      map['intensity'] = Variable<double>(intensity);
    }
    map['source_type'] = Variable<String>(sourceType);
    map['log_date'] = Variable<DateTime>(logDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkoutLogsTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutLogsTableCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      volume: Value(volume),
      durationSecs: durationSecs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSecs),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      intensity: intensity == null && nullToAbsent
          ? const Value.absent()
          : Value(intensity),
      sourceType: Value(sourceType),
      logDate: Value(logDate),
      createdAt: Value(createdAt),
    );
  }

  factory WorkoutLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      volume: serializer.fromJson<int>(json['volume']),
      durationSecs: serializer.fromJson<int?>(json['durationSecs']),
      notes: serializer.fromJson<String?>(json['notes']),
      intensity: serializer.fromJson<double?>(json['intensity']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'volume': serializer.toJson<int>(volume),
      'durationSecs': serializer.toJson<int?>(durationSecs),
      'notes': serializer.toJson<String?>(notes),
      'intensity': serializer.toJson<double?>(intensity),
      'sourceType': serializer.toJson<String>(sourceType),
      'logDate': serializer.toJson<DateTime>(logDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkoutLogsTableData copyWith({
    int? id,
    int? exerciseId,
    int? volume,
    Value<int?> durationSecs = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<double?> intensity = const Value.absent(),
    String? sourceType,
    DateTime? logDate,
    DateTime? createdAt,
  }) => WorkoutLogsTableData(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    volume: volume ?? this.volume,
    durationSecs: durationSecs.present ? durationSecs.value : this.durationSecs,
    notes: notes.present ? notes.value : this.notes,
    intensity: intensity.present ? intensity.value : this.intensity,
    sourceType: sourceType ?? this.sourceType,
    logDate: logDate ?? this.logDate,
    createdAt: createdAt ?? this.createdAt,
  );
  WorkoutLogsTableData copyWithCompanion(WorkoutLogsTableCompanion data) {
    return WorkoutLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      volume: data.volume.present ? data.volume.value : this.volume,
      durationSecs: data.durationSecs.present
          ? data.durationSecs.value
          : this.durationSecs,
      notes: data.notes.present ? data.notes.value : this.notes,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsTableData(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('volume: $volume, ')
          ..write('durationSecs: $durationSecs, ')
          ..write('notes: $notes, ')
          ..write('intensity: $intensity, ')
          ..write('sourceType: $sourceType, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseId,
    volume,
    durationSecs,
    notes,
    intensity,
    sourceType,
    logDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutLogsTableData &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.volume == this.volume &&
          other.durationSecs == this.durationSecs &&
          other.notes == this.notes &&
          other.intensity == this.intensity &&
          other.sourceType == this.sourceType &&
          other.logDate == this.logDate &&
          other.createdAt == this.createdAt);
}

class WorkoutLogsTableCompanion extends UpdateCompanion<WorkoutLogsTableData> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<int> volume;
  final Value<int?> durationSecs;
  final Value<String?> notes;
  final Value<double?> intensity;
  final Value<String> sourceType;
  final Value<DateTime> logDate;
  final Value<DateTime> createdAt;
  const WorkoutLogsTableCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.volume = const Value.absent(),
    this.durationSecs = const Value.absent(),
    this.notes = const Value.absent(),
    this.intensity = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.logDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WorkoutLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required int volume,
    this.durationSecs = const Value.absent(),
    this.notes = const Value.absent(),
    this.intensity = const Value.absent(),
    required String sourceType,
    this.logDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       volume = Value(volume),
       sourceType = Value(sourceType);
  static Insertable<WorkoutLogsTableData> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<int>? volume,
    Expression<int>? durationSecs,
    Expression<String>? notes,
    Expression<double>? intensity,
    Expression<String>? sourceType,
    Expression<DateTime>? logDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (volume != null) 'volume': volume,
      if (durationSecs != null) 'duration_secs': durationSecs,
      if (notes != null) 'notes': notes,
      if (intensity != null) 'intensity': intensity,
      if (sourceType != null) 'source_type': sourceType,
      if (logDate != null) 'log_date': logDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WorkoutLogsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<int>? volume,
    Value<int?>? durationSecs,
    Value<String?>? notes,
    Value<double?>? intensity,
    Value<String>? sourceType,
    Value<DateTime>? logDate,
    Value<DateTime>? createdAt,
  }) {
    return WorkoutLogsTableCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      volume: volume ?? this.volume,
      durationSecs: durationSecs ?? this.durationSecs,
      notes: notes ?? this.notes,
      intensity: intensity ?? this.intensity,
      sourceType: sourceType ?? this.sourceType,
      logDate: logDate ?? this.logDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (volume.present) {
      map['volume'] = Variable<int>(volume.value);
    }
    if (durationSecs.present) {
      map['duration_secs'] = Variable<int>(durationSecs.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<double>(intensity.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('volume: $volume, ')
          ..write('durationSecs: $durationSecs, ')
          ..write('notes: $notes, ')
          ..write('intensity: $intensity, ')
          ..write('sourceType: $sourceType, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SymptomLogsTableTable extends SymptomLogsTable
    with TableInfo<$SymptomLogsTableTable, SymptomLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomLogsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _muscleIdMeta = const VerificationMeta(
    'muscleId',
  );
  @override
  late final GeneratedColumn<String> muscleId = GeneratedColumn<String>(
    'muscle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    muscleId,
    intensity,
    note,
    category,
    sourceType,
    logDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('muscle_id')) {
      context.handle(
        _muscleIdMeta,
        muscleId.isAcceptableOrUnknown(data['muscle_id']!, _muscleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_muscleIdMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
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
  SymptomLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      muscleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_id'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SymptomLogsTableTable createAlias(String alias) {
    return $SymptomLogsTableTable(attachedDatabase, alias);
  }
}

class SymptomLogsTableData extends DataClass
    implements Insertable<SymptomLogsTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// ID of the affected muscle body segment.
  final String muscleId;

  /// Severity score of the reported symptom.
  final int intensity;

  /// Optional user note describing the symptom.
  final String? note;

  /// Symptom category (e.g. pain, fatigue, stiffness).
  final String? category;

  /// Source type of the symptom log (e.g. manual, detected).
  final String sourceType;

  /// Date the symptom was logged.
  final DateTime logDate;

  /// Timestamp when the log record was created.
  final DateTime createdAt;
  const SymptomLogsTableData({
    required this.id,
    required this.muscleId,
    required this.intensity,
    this.note,
    this.category,
    required this.sourceType,
    required this.logDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['muscle_id'] = Variable<String>(muscleId);
    map['intensity'] = Variable<int>(intensity);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['source_type'] = Variable<String>(sourceType);
    map['log_date'] = Variable<DateTime>(logDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SymptomLogsTableCompanion toCompanion(bool nullToAbsent) {
    return SymptomLogsTableCompanion(
      id: Value(id),
      muscleId: Value(muscleId),
      intensity: Value(intensity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      sourceType: Value(sourceType),
      logDate: Value(logDate),
      createdAt: Value(createdAt),
    );
  }

  factory SymptomLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      muscleId: serializer.fromJson<String>(json['muscleId']),
      intensity: serializer.fromJson<int>(json['intensity']),
      note: serializer.fromJson<String?>(json['note']),
      category: serializer.fromJson<String?>(json['category']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'muscleId': serializer.toJson<String>(muscleId),
      'intensity': serializer.toJson<int>(intensity),
      'note': serializer.toJson<String?>(note),
      'category': serializer.toJson<String?>(category),
      'sourceType': serializer.toJson<String>(sourceType),
      'logDate': serializer.toJson<DateTime>(logDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SymptomLogsTableData copyWith({
    int? id,
    String? muscleId,
    int? intensity,
    Value<String?> note = const Value.absent(),
    Value<String?> category = const Value.absent(),
    String? sourceType,
    DateTime? logDate,
    DateTime? createdAt,
  }) => SymptomLogsTableData(
    id: id ?? this.id,
    muscleId: muscleId ?? this.muscleId,
    intensity: intensity ?? this.intensity,
    note: note.present ? note.value : this.note,
    category: category.present ? category.value : this.category,
    sourceType: sourceType ?? this.sourceType,
    logDate: logDate ?? this.logDate,
    createdAt: createdAt ?? this.createdAt,
  );
  SymptomLogsTableData copyWithCompanion(SymptomLogsTableCompanion data) {
    return SymptomLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      muscleId: data.muscleId.present ? data.muscleId.value : this.muscleId,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      note: data.note.present ? data.note.value : this.note,
      category: data.category.present ? data.category.value : this.category,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLogsTableData(')
          ..write('id: $id, ')
          ..write('muscleId: $muscleId, ')
          ..write('intensity: $intensity, ')
          ..write('note: $note, ')
          ..write('category: $category, ')
          ..write('sourceType: $sourceType, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    muscleId,
    intensity,
    note,
    category,
    sourceType,
    logDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomLogsTableData &&
          other.id == this.id &&
          other.muscleId == this.muscleId &&
          other.intensity == this.intensity &&
          other.note == this.note &&
          other.category == this.category &&
          other.sourceType == this.sourceType &&
          other.logDate == this.logDate &&
          other.createdAt == this.createdAt);
}

class SymptomLogsTableCompanion extends UpdateCompanion<SymptomLogsTableData> {
  final Value<int> id;
  final Value<String> muscleId;
  final Value<int> intensity;
  final Value<String?> note;
  final Value<String?> category;
  final Value<String> sourceType;
  final Value<DateTime> logDate;
  final Value<DateTime> createdAt;
  const SymptomLogsTableCompanion({
    this.id = const Value.absent(),
    this.muscleId = const Value.absent(),
    this.intensity = const Value.absent(),
    this.note = const Value.absent(),
    this.category = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.logDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SymptomLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required String muscleId,
    required int intensity,
    this.note = const Value.absent(),
    this.category = const Value.absent(),
    required String sourceType,
    this.logDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : muscleId = Value(muscleId),
       intensity = Value(intensity),
       sourceType = Value(sourceType);
  static Insertable<SymptomLogsTableData> custom({
    Expression<int>? id,
    Expression<String>? muscleId,
    Expression<int>? intensity,
    Expression<String>? note,
    Expression<String>? category,
    Expression<String>? sourceType,
    Expression<DateTime>? logDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (muscleId != null) 'muscle_id': muscleId,
      if (intensity != null) 'intensity': intensity,
      if (note != null) 'note': note,
      if (category != null) 'category': category,
      if (sourceType != null) 'source_type': sourceType,
      if (logDate != null) 'log_date': logDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SymptomLogsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? muscleId,
    Value<int>? intensity,
    Value<String?>? note,
    Value<String?>? category,
    Value<String>? sourceType,
    Value<DateTime>? logDate,
    Value<DateTime>? createdAt,
  }) {
    return SymptomLogsTableCompanion(
      id: id ?? this.id,
      muscleId: muscleId ?? this.muscleId,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      category: category ?? this.category,
      sourceType: sourceType ?? this.sourceType,
      logDate: logDate ?? this.logDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (muscleId.present) {
      map['muscle_id'] = Variable<String>(muscleId.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('muscleId: $muscleId, ')
          ..write('intensity: $intensity, ')
          ..write('note: $note, ')
          ..write('category: $category, ')
          ..write('sourceType: $sourceType, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HypothesesTableTable extends HypothesesTable
    with TableInfo<$HypothesesTableTable, HypothesesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HypothesesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetNodeMeta = const VerificationMeta(
    'targetNode',
  );
  @override
  late final GeneratedColumn<String> targetNode = GeneratedColumn<String>(
    'target_node',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkedNodesMeta = const VerificationMeta(
    'linkedNodes',
  );
  @override
  late final GeneratedColumn<String> linkedNodes = GeneratedColumn<String>(
    'linked_nodes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementMeta = const VerificationMeta(
    'statement',
  );
  @override
  late final GeneratedColumn<String> statement = GeneratedColumn<String>(
    'statement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _certaintyScoreMeta = const VerificationMeta(
    'certaintyScore',
  );
  @override
  late final GeneratedColumn<double> certaintyScore = GeneratedColumn<double>(
    'certainty_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourcesCitedMeta = const VerificationMeta(
    'sourcesCited',
  );
  @override
  late final GeneratedColumn<String> sourcesCited = GeneratedColumn<String>(
    'sources_cited',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scientificRationaleMeta =
      const VerificationMeta('scientificRationale');
  @override
  late final GeneratedColumn<String> scientificRationale =
      GeneratedColumn<String>(
        'scientific_rationale',
        aliasedName,
        true,
        type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetNode,
    linkedNodes,
    statement,
    certaintyScore,
    status,
    sourcesCited,
    scientificRationale,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hypotheses_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HypothesesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_node')) {
      context.handle(
        _targetNodeMeta,
        targetNode.isAcceptableOrUnknown(data['target_node']!, _targetNodeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetNodeMeta);
    }
    if (data.containsKey('linked_nodes')) {
      context.handle(
        _linkedNodesMeta,
        linkedNodes.isAcceptableOrUnknown(
          data['linked_nodes']!,
          _linkedNodesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_linkedNodesMeta);
    }
    if (data.containsKey('statement')) {
      context.handle(
        _statementMeta,
        statement.isAcceptableOrUnknown(data['statement']!, _statementMeta),
      );
    } else if (isInserting) {
      context.missing(_statementMeta);
    }
    if (data.containsKey('certainty_score')) {
      context.handle(
        _certaintyScoreMeta,
        certaintyScore.isAcceptableOrUnknown(
          data['certainty_score']!,
          _certaintyScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_certaintyScoreMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('sources_cited')) {
      context.handle(
        _sourcesCitedMeta,
        sourcesCited.isAcceptableOrUnknown(
          data['sources_cited']!,
          _sourcesCitedMeta,
        ),
      );
    }
    if (data.containsKey('scientific_rationale')) {
      context.handle(
        _scientificRationaleMeta,
        scientificRationale.isAcceptableOrUnknown(
          data['scientific_rationale']!,
          _scientificRationaleMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  HypothesesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HypothesesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetNode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_node'],
      )!,
      linkedNodes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_nodes'],
      )!,
      statement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statement'],
      )!,
      certaintyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}certainty_score'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sourcesCited: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sources_cited'],
      ),
      scientificRationale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scientific_rationale'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HypothesesTableTable createAlias(String alias) {
    return $HypothesesTableTable(attachedDatabase, alias);
  }
}

class HypothesesTableData extends DataClass
    implements Insertable<HypothesesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Target body segment node the hypothesis concerns.
  final String targetNode;

  /// Comma-separated list of nodes related to the hypothesis.
  final String linkedNodes;

  /// Human-readable statement of the hypothesis.
  final String statement;

  /// Numerical certainty score for the hypothesis.
  final double certaintyScore;

  /// Status of the hypothesis (e.g. active, proven, refuted).
  final String status;

  /// Comma-separated list of sources cited in support.
  final String? sourcesCited;

  /// Scientific rationale supporting the hypothesis.
  final String? scientificRationale;

  /// Timestamp when the hypothesis record was created.
  final DateTime createdAt;

  /// Timestamp when the hypothesis record was last updated.
  final DateTime updatedAt;
  const HypothesesTableData({
    required this.id,
    required this.targetNode,
    required this.linkedNodes,
    required this.statement,
    required this.certaintyScore,
    required this.status,
    this.sourcesCited,
    this.scientificRationale,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_node'] = Variable<String>(targetNode);
    map['linked_nodes'] = Variable<String>(linkedNodes);
    map['statement'] = Variable<String>(statement);
    map['certainty_score'] = Variable<double>(certaintyScore);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || sourcesCited != null) {
      map['sources_cited'] = Variable<String>(sourcesCited);
    }
    if (!nullToAbsent || scientificRationale != null) {
      map['scientific_rationale'] = Variable<String>(scientificRationale);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HypothesesTableCompanion toCompanion(bool nullToAbsent) {
    return HypothesesTableCompanion(
      id: Value(id),
      targetNode: Value(targetNode),
      linkedNodes: Value(linkedNodes),
      statement: Value(statement),
      certaintyScore: Value(certaintyScore),
      status: Value(status),
      sourcesCited: sourcesCited == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcesCited),
      scientificRationale: scientificRationale == null && nullToAbsent
          ? const Value.absent()
          : Value(scientificRationale),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HypothesesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HypothesesTableData(
      id: serializer.fromJson<int>(json['id']),
      targetNode: serializer.fromJson<String>(json['targetNode']),
      linkedNodes: serializer.fromJson<String>(json['linkedNodes']),
      statement: serializer.fromJson<String>(json['statement']),
      certaintyScore: serializer.fromJson<double>(json['certaintyScore']),
      status: serializer.fromJson<String>(json['status']),
      sourcesCited: serializer.fromJson<String?>(json['sourcesCited']),
      scientificRationale: serializer.fromJson<String?>(
        json['scientificRationale'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetNode': serializer.toJson<String>(targetNode),
      'linkedNodes': serializer.toJson<String>(linkedNodes),
      'statement': serializer.toJson<String>(statement),
      'certaintyScore': serializer.toJson<double>(certaintyScore),
      'status': serializer.toJson<String>(status),
      'sourcesCited': serializer.toJson<String?>(sourcesCited),
      'scientificRationale': serializer.toJson<String?>(scientificRationale),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HypothesesTableData copyWith({
    int? id,
    String? targetNode,
    String? linkedNodes,
    String? statement,
    double? certaintyScore,
    String? status,
    Value<String?> sourcesCited = const Value.absent(),
    Value<String?> scientificRationale = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HypothesesTableData(
    id: id ?? this.id,
    targetNode: targetNode ?? this.targetNode,
    linkedNodes: linkedNodes ?? this.linkedNodes,
    statement: statement ?? this.statement,
    certaintyScore: certaintyScore ?? this.certaintyScore,
    status: status ?? this.status,
    sourcesCited: sourcesCited.present ? sourcesCited.value : this.sourcesCited,
    scientificRationale: scientificRationale.present
        ? scientificRationale.value
        : this.scientificRationale,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HypothesesTableData copyWithCompanion(HypothesesTableCompanion data) {
    return HypothesesTableData(
      id: data.id.present ? data.id.value : this.id,
      targetNode: data.targetNode.present
          ? data.targetNode.value
          : this.targetNode,
      linkedNodes: data.linkedNodes.present
          ? data.linkedNodes.value
          : this.linkedNodes,
      statement: data.statement.present ? data.statement.value : this.statement,
      certaintyScore: data.certaintyScore.present
          ? data.certaintyScore.value
          : this.certaintyScore,
      status: data.status.present ? data.status.value : this.status,
      sourcesCited: data.sourcesCited.present
          ? data.sourcesCited.value
          : this.sourcesCited,
      scientificRationale: data.scientificRationale.present
          ? data.scientificRationale.value
          : this.scientificRationale,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HypothesesTableData(')
          ..write('id: $id, ')
          ..write('targetNode: $targetNode, ')
          ..write('linkedNodes: $linkedNodes, ')
          ..write('statement: $statement, ')
          ..write('certaintyScore: $certaintyScore, ')
          ..write('status: $status, ')
          ..write('sourcesCited: $sourcesCited, ')
          ..write('scientificRationale: $scientificRationale, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetNode,
    linkedNodes,
    statement,
    certaintyScore,
    status,
    sourcesCited,
    scientificRationale,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HypothesesTableData &&
          other.id == this.id &&
          other.targetNode == this.targetNode &&
          other.linkedNodes == this.linkedNodes &&
          other.statement == this.statement &&
          other.certaintyScore == this.certaintyScore &&
          other.status == this.status &&
          other.sourcesCited == this.sourcesCited &&
          other.scientificRationale == this.scientificRationale &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HypothesesTableCompanion extends UpdateCompanion<HypothesesTableData> {
  final Value<int> id;
  final Value<String> targetNode;
  final Value<String> linkedNodes;
  final Value<String> statement;
  final Value<double> certaintyScore;
  final Value<String> status;
  final Value<String?> sourcesCited;
  final Value<String?> scientificRationale;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const HypothesesTableCompanion({
    this.id = const Value.absent(),
    this.targetNode = const Value.absent(),
    this.linkedNodes = const Value.absent(),
    this.statement = const Value.absent(),
    this.certaintyScore = const Value.absent(),
    this.status = const Value.absent(),
    this.sourcesCited = const Value.absent(),
    this.scientificRationale = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HypothesesTableCompanion.insert({
    this.id = const Value.absent(),
    required String targetNode,
    required String linkedNodes,
    required String statement,
    required double certaintyScore,
    required String status,
    this.sourcesCited = const Value.absent(),
    this.scientificRationale = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : targetNode = Value(targetNode),
       linkedNodes = Value(linkedNodes),
       statement = Value(statement),
       certaintyScore = Value(certaintyScore),
       status = Value(status);
  static Insertable<HypothesesTableData> custom({
    Expression<int>? id,
    Expression<String>? targetNode,
    Expression<String>? linkedNodes,
    Expression<String>? statement,
    Expression<double>? certaintyScore,
    Expression<String>? status,
    Expression<String>? sourcesCited,
    Expression<String>? scientificRationale,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetNode != null) 'target_node': targetNode,
      if (linkedNodes != null) 'linked_nodes': linkedNodes,
      if (statement != null) 'statement': statement,
      if (certaintyScore != null) 'certainty_score': certaintyScore,
      if (status != null) 'status': status,
      if (sourcesCited != null) 'sources_cited': sourcesCited,
      if (scientificRationale != null)
        'scientific_rationale': scientificRationale,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HypothesesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? targetNode,
    Value<String>? linkedNodes,
    Value<String>? statement,
    Value<double>? certaintyScore,
    Value<String>? status,
    Value<String?>? sourcesCited,
    Value<String?>? scientificRationale,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return HypothesesTableCompanion(
      id: id ?? this.id,
      targetNode: targetNode ?? this.targetNode,
      linkedNodes: linkedNodes ?? this.linkedNodes,
      statement: statement ?? this.statement,
      certaintyScore: certaintyScore ?? this.certaintyScore,
      status: status ?? this.status,
      sourcesCited: sourcesCited ?? this.sourcesCited,
      scientificRationale: scientificRationale ?? this.scientificRationale,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetNode.present) {
      map['target_node'] = Variable<String>(targetNode.value);
    }
    if (linkedNodes.present) {
      map['linked_nodes'] = Variable<String>(linkedNodes.value);
    }
    if (statement.present) {
      map['statement'] = Variable<String>(statement.value);
    }
    if (certaintyScore.present) {
      map['certainty_score'] = Variable<double>(certaintyScore.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sourcesCited.present) {
      map['sources_cited'] = Variable<String>(sourcesCited.value);
    }
    if (scientificRationale.present) {
      map['scientific_rationale'] = Variable<String>(scientificRationale.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HypothesesTableCompanion(')
          ..write('id: $id, ')
          ..write('targetNode: $targetNode, ')
          ..write('linkedNodes: $linkedNodes, ')
          ..write('statement: $statement, ')
          ..write('certaintyScore: $certaintyScore, ')
          ..write('status: $status, ')
          ..write('sourcesCited: $sourcesCited, ')
          ..write('scientificRationale: $scientificRationale, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SourcesTableTable extends SourcesTable
    with TableInfo<$SourcesTableTable, SourcesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorsMeta = const VerificationMeta(
    'authors',
  );
  @override
  late final GeneratedColumn<String> authors = GeneratedColumn<String>(
    'authors',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyTakeawayMeta = const VerificationMeta(
    'keyTakeaway',
  );
  @override
  late final GeneratedColumn<String> keyTakeaway = GeneratedColumn<String>(
    'key_takeaway',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relationshipToHypothesisMeta =
      const VerificationMeta('relationshipToHypothesis');
  @override
  late final GeneratedColumn<String> relationshipToHypothesis =
      GeneratedColumn<String>(
        'relationship_to_hypothesis',
        aliasedName,
        true,
        type: DriftSqlType.string,
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
    title,
    authors,
    link,
    keyTakeaway,
    relationshipToHypothesis,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourcesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('authors')) {
      context.handle(
        _authorsMeta,
        authors.isAcceptableOrUnknown(data['authors']!, _authorsMeta),
      );
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('key_takeaway')) {
      context.handle(
        _keyTakeawayMeta,
        keyTakeaway.isAcceptableOrUnknown(
          data['key_takeaway']!,
          _keyTakeawayMeta,
        ),
      );
    }
    if (data.containsKey('relationship_to_hypothesis')) {
      context.handle(
        _relationshipToHypothesisMeta,
        relationshipToHypothesis.isAcceptableOrUnknown(
          data['relationship_to_hypothesis']!,
          _relationshipToHypothesisMeta,
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
  SourcesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourcesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      authors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors'],
      ),
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      keyTakeaway: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_takeaway'],
      ),
      relationshipToHypothesis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship_to_hypothesis'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SourcesTableTable createAlias(String alias) {
    return $SourcesTableTable(attachedDatabase, alias);
  }
}

class SourcesTableData extends DataClass
    implements Insertable<SourcesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Title of the cited research or article.
  final String title;

  /// Author(s) of the source material.
  final String? authors;

  /// URL link to the source document.
  final String? link;

  /// Key takeaway or finding from the source.
  final String? keyTakeaway;

  /// How the source relates to the associated hypothesis.
  final String? relationshipToHypothesis;

  /// Timestamp when the source record was created.
  final DateTime createdAt;
  const SourcesTableData({
    required this.id,
    required this.title,
    this.authors,
    this.link,
    this.keyTakeaway,
    this.relationshipToHypothesis,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || authors != null) {
      map['authors'] = Variable<String>(authors);
    }
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || keyTakeaway != null) {
      map['key_takeaway'] = Variable<String>(keyTakeaway);
    }
    if (!nullToAbsent || relationshipToHypothesis != null) {
      map['relationship_to_hypothesis'] = Variable<String>(
        relationshipToHypothesis,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SourcesTableCompanion toCompanion(bool nullToAbsent) {
    return SourcesTableCompanion(
      id: Value(id),
      title: Value(title),
      authors: authors == null && nullToAbsent
          ? const Value.absent()
          : Value(authors),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      keyTakeaway: keyTakeaway == null && nullToAbsent
          ? const Value.absent()
          : Value(keyTakeaway),
      relationshipToHypothesis: relationshipToHypothesis == null && nullToAbsent
          ? const Value.absent()
          : Value(relationshipToHypothesis),
      createdAt: Value(createdAt),
    );
  }

  factory SourcesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourcesTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      authors: serializer.fromJson<String?>(json['authors']),
      link: serializer.fromJson<String?>(json['link']),
      keyTakeaway: serializer.fromJson<String?>(json['keyTakeaway']),
      relationshipToHypothesis: serializer.fromJson<String?>(
        json['relationshipToHypothesis'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'authors': serializer.toJson<String?>(authors),
      'link': serializer.toJson<String?>(link),
      'keyTakeaway': serializer.toJson<String?>(keyTakeaway),
      'relationshipToHypothesis': serializer.toJson<String?>(
        relationshipToHypothesis,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SourcesTableData copyWith({
    int? id,
    String? title,
    Value<String?> authors = const Value.absent(),
    Value<String?> link = const Value.absent(),
    Value<String?> keyTakeaway = const Value.absent(),
    Value<String?> relationshipToHypothesis = const Value.absent(),
    DateTime? createdAt,
  }) => SourcesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    authors: authors.present ? authors.value : this.authors,
    link: link.present ? link.value : this.link,
    keyTakeaway: keyTakeaway.present ? keyTakeaway.value : this.keyTakeaway,
    relationshipToHypothesis: relationshipToHypothesis.present
        ? relationshipToHypothesis.value
        : this.relationshipToHypothesis,
    createdAt: createdAt ?? this.createdAt,
  );
  SourcesTableData copyWithCompanion(SourcesTableCompanion data) {
    return SourcesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      authors: data.authors.present ? data.authors.value : this.authors,
      link: data.link.present ? data.link.value : this.link,
      keyTakeaway: data.keyTakeaway.present
          ? data.keyTakeaway.value
          : this.keyTakeaway,
      relationshipToHypothesis: data.relationshipToHypothesis.present
          ? data.relationshipToHypothesis.value
          : this.relationshipToHypothesis,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourcesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authors: $authors, ')
          ..write('link: $link, ')
          ..write('keyTakeaway: $keyTakeaway, ')
          ..write('relationshipToHypothesis: $relationshipToHypothesis, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    authors,
    link,
    keyTakeaway,
    relationshipToHypothesis,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourcesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.authors == this.authors &&
          other.link == this.link &&
          other.keyTakeaway == this.keyTakeaway &&
          other.relationshipToHypothesis == this.relationshipToHypothesis &&
          other.createdAt == this.createdAt);
}

class SourcesTableCompanion extends UpdateCompanion<SourcesTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> authors;
  final Value<String?> link;
  final Value<String?> keyTakeaway;
  final Value<String?> relationshipToHypothesis;
  final Value<DateTime> createdAt;
  const SourcesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.authors = const Value.absent(),
    this.link = const Value.absent(),
    this.keyTakeaway = const Value.absent(),
    this.relationshipToHypothesis = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SourcesTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.authors = const Value.absent(),
    this.link = const Value.absent(),
    this.keyTakeaway = const Value.absent(),
    this.relationshipToHypothesis = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<SourcesTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? authors,
    Expression<String>? link,
    Expression<String>? keyTakeaway,
    Expression<String>? relationshipToHypothesis,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (authors != null) 'authors': authors,
      if (link != null) 'link': link,
      if (keyTakeaway != null) 'key_takeaway': keyTakeaway,
      if (relationshipToHypothesis != null)
        'relationship_to_hypothesis': relationshipToHypothesis,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SourcesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? authors,
    Value<String?>? link,
    Value<String?>? keyTakeaway,
    Value<String?>? relationshipToHypothesis,
    Value<DateTime>? createdAt,
  }) {
    return SourcesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      link: link ?? this.link,
      keyTakeaway: keyTakeaway ?? this.keyTakeaway,
      relationshipToHypothesis:
          relationshipToHypothesis ?? this.relationshipToHypothesis,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (authors.present) {
      map['authors'] = Variable<String>(authors.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (keyTakeaway.present) {
      map['key_takeaway'] = Variable<String>(keyTakeaway.value);
    }
    if (relationshipToHypothesis.present) {
      map['relationship_to_hypothesis'] = Variable<String>(
        relationshipToHypothesis.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authors: $authors, ')
          ..write('link: $link, ')
          ..write('keyTakeaway: $keyTakeaway, ')
          ..write('relationshipToHypothesis: $relationshipToHypothesis, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PrinciplesTableTable extends PrinciplesTable
    with TableInfo<$PrinciplesTableTable, PrinciplesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrinciplesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementMeta = const VerificationMeta(
    'statement',
  );
  @override
  late final GeneratedColumn<String> statement = GeneratedColumn<String>(
    'statement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeSourceIdMeta = const VerificationMeta(
    'knowledgeSourceId',
  );
  @override
  late final GeneratedColumn<String> knowledgeSourceId =
      GeneratedColumn<String>(
        'knowledge_source_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
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
    name,
    statement,
    category,
    knowledgeSourceId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'principles_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrinciplesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('statement')) {
      context.handle(
        _statementMeta,
        statement.isAcceptableOrUnknown(data['statement']!, _statementMeta),
      );
    } else if (isInserting) {
      context.missing(_statementMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('knowledge_source_id')) {
      context.handle(
        _knowledgeSourceIdMeta,
        knowledgeSourceId.isAcceptableOrUnknown(
          data['knowledge_source_id']!,
          _knowledgeSourceIdMeta,
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
  PrinciplesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrinciplesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      statement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statement'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      knowledgeSourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}knowledge_source_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PrinciplesTableTable createAlias(String alias) {
    return $PrinciplesTableTable(attachedDatabase, alias);
  }
}

class PrinciplesTableData extends DataClass
    implements Insertable<PrinciplesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Display name of the biomechanical principle.
  final String name;

  /// The principle statement or rule.
  final String statement;

  /// Category of the principle (e.g. biomechanics, physiology).
  final String category;

  /// Foreign key reference to the originating knowledge source.
  final String? knowledgeSourceId;

  /// Timestamp when the principle record was created.
  final DateTime createdAt;
  const PrinciplesTableData({
    required this.id,
    required this.name,
    required this.statement,
    required this.category,
    this.knowledgeSourceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['statement'] = Variable<String>(statement);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || knowledgeSourceId != null) {
      map['knowledge_source_id'] = Variable<String>(knowledgeSourceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PrinciplesTableCompanion toCompanion(bool nullToAbsent) {
    return PrinciplesTableCompanion(
      id: Value(id),
      name: Value(name),
      statement: Value(statement),
      category: Value(category),
      knowledgeSourceId: knowledgeSourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(knowledgeSourceId),
      createdAt: Value(createdAt),
    );
  }

  factory PrinciplesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrinciplesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      statement: serializer.fromJson<String>(json['statement']),
      category: serializer.fromJson<String>(json['category']),
      knowledgeSourceId: serializer.fromJson<String?>(
        json['knowledgeSourceId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'statement': serializer.toJson<String>(statement),
      'category': serializer.toJson<String>(category),
      'knowledgeSourceId': serializer.toJson<String?>(knowledgeSourceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PrinciplesTableData copyWith({
    int? id,
    String? name,
    String? statement,
    String? category,
    Value<String?> knowledgeSourceId = const Value.absent(),
    DateTime? createdAt,
  }) => PrinciplesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    statement: statement ?? this.statement,
    category: category ?? this.category,
    knowledgeSourceId: knowledgeSourceId.present
        ? knowledgeSourceId.value
        : this.knowledgeSourceId,
    createdAt: createdAt ?? this.createdAt,
  );
  PrinciplesTableData copyWithCompanion(PrinciplesTableCompanion data) {
    return PrinciplesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      statement: data.statement.present ? data.statement.value : this.statement,
      category: data.category.present ? data.category.value : this.category,
      knowledgeSourceId: data.knowledgeSourceId.present
          ? data.knowledgeSourceId.value
          : this.knowledgeSourceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrinciplesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('statement: $statement, ')
          ..write('category: $category, ')
          ..write('knowledgeSourceId: $knowledgeSourceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, statement, category, knowledgeSourceId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrinciplesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.statement == this.statement &&
          other.category == this.category &&
          other.knowledgeSourceId == this.knowledgeSourceId &&
          other.createdAt == this.createdAt);
}

class PrinciplesTableCompanion extends UpdateCompanion<PrinciplesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> statement;
  final Value<String> category;
  final Value<String?> knowledgeSourceId;
  final Value<DateTime> createdAt;
  const PrinciplesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.statement = const Value.absent(),
    this.category = const Value.absent(),
    this.knowledgeSourceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PrinciplesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String statement,
    required String category,
    this.knowledgeSourceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       statement = Value(statement),
       category = Value(category);
  static Insertable<PrinciplesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? statement,
    Expression<String>? category,
    Expression<String>? knowledgeSourceId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (statement != null) 'statement': statement,
      if (category != null) 'category': category,
      if (knowledgeSourceId != null) 'knowledge_source_id': knowledgeSourceId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PrinciplesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? statement,
    Value<String>? category,
    Value<String?>? knowledgeSourceId,
    Value<DateTime>? createdAt,
  }) {
    return PrinciplesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      statement: statement ?? this.statement,
      category: category ?? this.category,
      knowledgeSourceId: knowledgeSourceId ?? this.knowledgeSourceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (statement.present) {
      map['statement'] = Variable<String>(statement.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (knowledgeSourceId.present) {
      map['knowledge_source_id'] = Variable<String>(knowledgeSourceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrinciplesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('statement: $statement, ')
          ..write('category: $category, ')
          ..write('knowledgeSourceId: $knowledgeSourceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ResearchNotesTableTable extends ResearchNotesTable
    with TableInfo<$ResearchNotesTableTable, ResearchNotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResearchNotesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedHypothesisIdMeta =
      const VerificationMeta('relatedHypothesisId');
  @override
  late final GeneratedColumn<String> relatedHypothesisId =
      GeneratedColumn<String>(
        'related_hypothesis_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _certaintyScoreMeta = const VerificationMeta(
    'certaintyScore',
  );
  @override
  late final GeneratedColumn<double> certaintyScore = GeneratedColumn<double>(
    'certainty_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
    content,
    type,
    relatedHypothesisId,
    certaintyScore,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'research_notes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResearchNotesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('related_hypothesis_id')) {
      context.handle(
        _relatedHypothesisIdMeta,
        relatedHypothesisId.isAcceptableOrUnknown(
          data['related_hypothesis_id']!,
          _relatedHypothesisIdMeta,
        ),
      );
    }
    if (data.containsKey('certainty_score')) {
      context.handle(
        _certaintyScoreMeta,
        certaintyScore.isAcceptableOrUnknown(
          data['certainty_score']!,
          _certaintyScoreMeta,
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
  ResearchNotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResearchNotesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      relatedHypothesisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_hypothesis_id'],
      ),
      certaintyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}certainty_score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ResearchNotesTableTable createAlias(String alias) {
    return $ResearchNotesTableTable(attachedDatabase, alias);
  }
}

class ResearchNotesTableData extends DataClass
    implements Insertable<ResearchNotesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Content of the research note.
  final String content;

  /// Type or classification of the research note.
  final String type;

  /// Foreign key reference to an optional related hypothesis.
  final String? relatedHypothesisId;

  /// Certainty score for the research finding.
  final double? certaintyScore;

  /// Timestamp when the note record was created.
  final DateTime createdAt;
  const ResearchNotesTableData({
    required this.id,
    required this.content,
    required this.type,
    this.relatedHypothesisId,
    this.certaintyScore,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || relatedHypothesisId != null) {
      map['related_hypothesis_id'] = Variable<String>(relatedHypothesisId);
    }
    if (!nullToAbsent || certaintyScore != null) {
      map['certainty_score'] = Variable<double>(certaintyScore);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ResearchNotesTableCompanion toCompanion(bool nullToAbsent) {
    return ResearchNotesTableCompanion(
      id: Value(id),
      content: Value(content),
      type: Value(type),
      relatedHypothesisId: relatedHypothesisId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedHypothesisId),
      certaintyScore: certaintyScore == null && nullToAbsent
          ? const Value.absent()
          : Value(certaintyScore),
      createdAt: Value(createdAt),
    );
  }

  factory ResearchNotesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResearchNotesTableData(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      relatedHypothesisId: serializer.fromJson<String?>(
        json['relatedHypothesisId'],
      ),
      certaintyScore: serializer.fromJson<double?>(json['certaintyScore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<String>(type),
      'relatedHypothesisId': serializer.toJson<String?>(relatedHypothesisId),
      'certaintyScore': serializer.toJson<double?>(certaintyScore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ResearchNotesTableData copyWith({
    int? id,
    String? content,
    String? type,
    Value<String?> relatedHypothesisId = const Value.absent(),
    Value<double?> certaintyScore = const Value.absent(),
    DateTime? createdAt,
  }) => ResearchNotesTableData(
    id: id ?? this.id,
    content: content ?? this.content,
    type: type ?? this.type,
    relatedHypothesisId: relatedHypothesisId.present
        ? relatedHypothesisId.value
        : this.relatedHypothesisId,
    certaintyScore: certaintyScore.present
        ? certaintyScore.value
        : this.certaintyScore,
    createdAt: createdAt ?? this.createdAt,
  );
  ResearchNotesTableData copyWithCompanion(ResearchNotesTableCompanion data) {
    return ResearchNotesTableData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      relatedHypothesisId: data.relatedHypothesisId.present
          ? data.relatedHypothesisId.value
          : this.relatedHypothesisId,
      certaintyScore: data.certaintyScore.present
          ? data.certaintyScore.value
          : this.certaintyScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResearchNotesTableData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('relatedHypothesisId: $relatedHypothesisId, ')
          ..write('certaintyScore: $certaintyScore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    type,
    relatedHypothesisId,
    certaintyScore,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResearchNotesTableData &&
          other.id == this.id &&
          other.content == this.content &&
          other.type == this.type &&
          other.relatedHypothesisId == this.relatedHypothesisId &&
          other.certaintyScore == this.certaintyScore &&
          other.createdAt == this.createdAt);
}

class ResearchNotesTableCompanion
    extends UpdateCompanion<ResearchNotesTableData> {
  final Value<int> id;
  final Value<String> content;
  final Value<String> type;
  final Value<String?> relatedHypothesisId;
  final Value<double?> certaintyScore;
  final Value<DateTime> createdAt;
  const ResearchNotesTableCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.relatedHypothesisId = const Value.absent(),
    this.certaintyScore = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ResearchNotesTableCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required String type,
    this.relatedHypothesisId = const Value.absent(),
    this.certaintyScore = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : content = Value(content),
       type = Value(type);
  static Insertable<ResearchNotesTableData> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? type,
    Expression<String>? relatedHypothesisId,
    Expression<double>? certaintyScore,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (relatedHypothesisId != null)
        'related_hypothesis_id': relatedHypothesisId,
      if (certaintyScore != null) 'certainty_score': certaintyScore,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ResearchNotesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String>? type,
    Value<String?>? relatedHypothesisId,
    Value<double?>? certaintyScore,
    Value<DateTime>? createdAt,
  }) {
    return ResearchNotesTableCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      relatedHypothesisId: relatedHypothesisId ?? this.relatedHypothesisId,
      certaintyScore: certaintyScore ?? this.certaintyScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (relatedHypothesisId.present) {
      map['related_hypothesis_id'] = Variable<String>(
        relatedHypothesisId.value,
      );
    }
    if (certaintyScore.present) {
      map['certainty_score'] = Variable<double>(certaintyScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResearchNotesTableCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('relatedHypothesisId: $relatedHypothesisId, ')
          ..write('certaintyScore: $certaintyScore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationContextTableTable extends NotificationContextTable
    with
        TableInfo<
          $NotificationContextTableTable,
          NotificationContextTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationContextTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _deepLinkMeta = const VerificationMeta(
    'deepLink',
  );
  @override
  late final GeneratedColumn<String> deepLink = GeneratedColumn<String>(
    'deep_link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _delayMinutesMeta = const VerificationMeta(
    'delayMinutes',
  );
  @override
  late final GeneratedColumn<int> delayMinutes = GeneratedColumn<int>(
    'delay_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextUuidMeta = const VerificationMeta(
    'contextUuid',
  );
  @override
  late final GeneratedColumn<String> contextUuid = GeneratedColumn<String>(
    'context_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    clientDefault: () => 'pending',
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
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    deepLink,
    delayMinutes,
    contextUuid,
    status,
    createdAt,
    scheduledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_context_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationContextTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('deep_link')) {
      context.handle(
        _deepLinkMeta,
        deepLink.isAcceptableOrUnknown(data['deep_link']!, _deepLinkMeta),
      );
    } else if (isInserting) {
      context.missing(_deepLinkMeta);
    }
    if (data.containsKey('delay_minutes')) {
      context.handle(
        _delayMinutesMeta,
        delayMinutes.isAcceptableOrUnknown(
          data['delay_minutes']!,
          _delayMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_delayMinutesMeta);
    }
    if (data.containsKey('context_uuid')) {
      context.handle(
        _contextUuidMeta,
        contextUuid.isAcceptableOrUnknown(
          data['context_uuid']!,
          _contextUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextUuidMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationContextTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationContextTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      deepLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deep_link'],
      )!,
      delayMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delay_minutes'],
      )!,
      contextUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_uuid'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      ),
    );
  }

  @override
  $NotificationContextTableTable createAlias(String alias) {
    return $NotificationContextTableTable(attachedDatabase, alias);
  }
}

class NotificationContextTableData extends DataClass
    implements Insertable<NotificationContextTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Title text for the notification.
  final String title;

  /// Body text content of the notification.
  final String body;

  /// Deep-link UUID for navigation when notification is tapped.
  final String deepLink;

  /// Delay minutes before the notification is dispatched.
  final int delayMinutes;

  /// Context UUID for correlation with other records.
  final String contextUuid;

  /// Notification delivery status (e.g. pending, delivered).
  final String status;

  /// Timestamp when the notification record was created.
  final DateTime createdAt;

  /// Scheduled delivery timestamp for the notification.
  final DateTime? scheduledAt;
  const NotificationContextTableData({
    required this.id,
    required this.title,
    required this.body,
    required this.deepLink,
    required this.delayMinutes,
    required this.contextUuid,
    required this.status,
    required this.createdAt,
    this.scheduledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['deep_link'] = Variable<String>(deepLink);
    map['delay_minutes'] = Variable<int>(delayMinutes);
    map['context_uuid'] = Variable<String>(contextUuid);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || scheduledAt != null) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    }
    return map;
  }

  NotificationContextTableCompanion toCompanion(bool nullToAbsent) {
    return NotificationContextTableCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      deepLink: Value(deepLink),
      delayMinutes: Value(delayMinutes),
      contextUuid: Value(contextUuid),
      status: Value(status),
      createdAt: Value(createdAt),
      scheduledAt: scheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledAt),
    );
  }

  factory NotificationContextTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationContextTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      deepLink: serializer.fromJson<String>(json['deepLink']),
      delayMinutes: serializer.fromJson<int>(json['delayMinutes']),
      contextUuid: serializer.fromJson<String>(json['contextUuid']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      scheduledAt: serializer.fromJson<DateTime?>(json['scheduledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'deepLink': serializer.toJson<String>(deepLink),
      'delayMinutes': serializer.toJson<int>(delayMinutes),
      'contextUuid': serializer.toJson<String>(contextUuid),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'scheduledAt': serializer.toJson<DateTime?>(scheduledAt),
    };
  }

  NotificationContextTableData copyWith({
    int? id,
    String? title,
    String? body,
    String? deepLink,
    int? delayMinutes,
    String? contextUuid,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> scheduledAt = const Value.absent(),
  }) => NotificationContextTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    deepLink: deepLink ?? this.deepLink,
    delayMinutes: delayMinutes ?? this.delayMinutes,
    contextUuid: contextUuid ?? this.contextUuid,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    scheduledAt: scheduledAt.present ? scheduledAt.value : this.scheduledAt,
  );
  NotificationContextTableData copyWithCompanion(
    NotificationContextTableCompanion data,
  ) {
    return NotificationContextTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      deepLink: data.deepLink.present ? data.deepLink.value : this.deepLink,
      delayMinutes: data.delayMinutes.present
          ? data.delayMinutes.value
          : this.delayMinutes,
      contextUuid: data.contextUuid.present
          ? data.contextUuid.value
          : this.contextUuid,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationContextTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('deepLink: $deepLink, ')
          ..write('delayMinutes: $delayMinutes, ')
          ..write('contextUuid: $contextUuid, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('scheduledAt: $scheduledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    body,
    deepLink,
    delayMinutes,
    contextUuid,
    status,
    createdAt,
    scheduledAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationContextTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.deepLink == this.deepLink &&
          other.delayMinutes == this.delayMinutes &&
          other.contextUuid == this.contextUuid &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.scheduledAt == this.scheduledAt);
}

class NotificationContextTableCompanion
    extends UpdateCompanion<NotificationContextTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> deepLink;
  final Value<int> delayMinutes;
  final Value<String> contextUuid;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> scheduledAt;
  const NotificationContextTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.deepLink = const Value.absent(),
    this.delayMinutes = const Value.absent(),
    this.contextUuid = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.scheduledAt = const Value.absent(),
  });
  NotificationContextTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String body,
    required String deepLink,
    required int delayMinutes,
    required String contextUuid,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.scheduledAt = const Value.absent(),
  }) : title = Value(title),
       body = Value(body),
       deepLink = Value(deepLink),
       delayMinutes = Value(delayMinutes),
       contextUuid = Value(contextUuid);
  static Insertable<NotificationContextTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? deepLink,
    Expression<int>? delayMinutes,
    Expression<String>? contextUuid,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? scheduledAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (deepLink != null) 'deep_link': deepLink,
      if (delayMinutes != null) 'delay_minutes': delayMinutes,
      if (contextUuid != null) 'context_uuid': contextUuid,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
    });
  }

  NotificationContextTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? body,
    Value<String>? deepLink,
    Value<int>? delayMinutes,
    Value<String>? contextUuid,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? scheduledAt,
  }) {
    return NotificationContextTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      deepLink: deepLink ?? this.deepLink,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      contextUuid: contextUuid ?? this.contextUuid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (deepLink.present) {
      map['deep_link'] = Variable<String>(deepLink.value);
    }
    if (delayMinutes.present) {
      map['delay_minutes'] = Variable<int>(delayMinutes.value);
    }
    if (contextUuid.present) {
      map['context_uuid'] = Variable<String>(contextUuid.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationContextTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('deepLink: $deepLink, ')
          ..write('delayMinutes: $delayMinutes, ')
          ..write('contextUuid: $contextUuid, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('scheduledAt: $scheduledAt')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeSourcesTableTable extends KnowledgeSourcesTable
    with TableInfo<$KnowledgeSourcesTableTable, KnowledgeSourcesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeSourcesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    contentType,
    content,
    title,
    category,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_sources_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeSourcesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
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
  KnowledgeSourcesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeSourcesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KnowledgeSourcesTableTable createAlias(String alias) {
    return $KnowledgeSourcesTableTable(attachedDatabase, alias);
  }
}

class KnowledgeSourcesTableData extends DataClass
    implements Insertable<KnowledgeSourcesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Content type of the ingested source (e.g. pdf, text, url).
  final String contentType;

  /// Full content of the ingested source material.
  final String content;

  /// Optional human-readable title for the source.
  final String? title;

  /// Category classification of the knowledge source.
  final String? category;

  /// Timestamp when the source record was created.
  final DateTime createdAt;
  const KnowledgeSourcesTableData({
    required this.id,
    required this.contentType,
    required this.content,
    this.title,
    this.category,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content_type'] = Variable<String>(contentType);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KnowledgeSourcesTableCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeSourcesTableCompanion(
      id: Value(id),
      contentType: Value(contentType),
      content: Value(content),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory KnowledgeSourcesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeSourcesTableData(
      id: serializer.fromJson<int>(json['id']),
      contentType: serializer.fromJson<String>(json['contentType']),
      content: serializer.fromJson<String>(json['content']),
      title: serializer.fromJson<String?>(json['title']),
      category: serializer.fromJson<String?>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contentType': serializer.toJson<String>(contentType),
      'content': serializer.toJson<String>(content),
      'title': serializer.toJson<String?>(title),
      'category': serializer.toJson<String?>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  KnowledgeSourcesTableData copyWith({
    int? id,
    String? contentType,
    String? content,
    Value<String?> title = const Value.absent(),
    Value<String?> category = const Value.absent(),
    DateTime? createdAt,
  }) => KnowledgeSourcesTableData(
    id: id ?? this.id,
    contentType: contentType ?? this.contentType,
    content: content ?? this.content,
    title: title.present ? title.value : this.title,
    category: category.present ? category.value : this.category,
    createdAt: createdAt ?? this.createdAt,
  );
  KnowledgeSourcesTableData copyWithCompanion(
    KnowledgeSourcesTableCompanion data,
  ) {
    return KnowledgeSourcesTableData(
      id: data.id.present ? data.id.value : this.id,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      content: data.content.present ? data.content.value : this.content,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeSourcesTableData(')
          ..write('id: $id, ')
          ..write('contentType: $contentType, ')
          ..write('content: $content, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, contentType, content, title, category, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeSourcesTableData &&
          other.id == this.id &&
          other.contentType == this.contentType &&
          other.content == this.content &&
          other.title == this.title &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class KnowledgeSourcesTableCompanion
    extends UpdateCompanion<KnowledgeSourcesTableData> {
  final Value<int> id;
  final Value<String> contentType;
  final Value<String> content;
  final Value<String?> title;
  final Value<String?> category;
  final Value<DateTime> createdAt;
  const KnowledgeSourcesTableCompanion({
    this.id = const Value.absent(),
    this.contentType = const Value.absent(),
    this.content = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  KnowledgeSourcesTableCompanion.insert({
    this.id = const Value.absent(),
    required String contentType,
    required String content,
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : contentType = Value(contentType),
       content = Value(content);
  static Insertable<KnowledgeSourcesTableData> custom({
    Expression<int>? id,
    Expression<String>? contentType,
    Expression<String>? content,
    Expression<String>? title,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contentType != null) 'content_type': contentType,
      if (content != null) 'content': content,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  KnowledgeSourcesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? contentType,
    Value<String>? content,
    Value<String?>? title,
    Value<String?>? category,
    Value<DateTime>? createdAt,
  }) {
    return KnowledgeSourcesTableCompanion(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      content: content ?? this.content,
      title: title ?? this.title,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeSourcesTableCompanion(')
          ..write('id: $id, ')
          ..write('contentType: $contentType, ')
          ..write('content: $content, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NoiseLogsTableTable extends NoiseLogsTable
    with TableInfo<$NoiseLogsTableTable, NoiseLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoiseLogsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    intensity,
    note,
    sourceType,
    logDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'noise_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoiseLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
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
  NoiseLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoiseLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NoiseLogsTableTable createAlias(String alias) {
    return $NoiseLogsTableTable(attachedDatabase, alias);
  }
}

class NoiseLogsTableData extends DataClass
    implements Insertable<NoiseLogsTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Type of noise or stressor (e.g. environmental, mental).
  final String type;

  /// Intensity level of the noise/stressor.
  final int? intensity;

  /// Optional note describing the noise event.
  final String? note;

  /// Source type of the noise log (e.g. sensor, manual).
  final String sourceType;

  /// Date the noise event was logged.
  final DateTime logDate;

  /// Timestamp when the log record was created.
  final DateTime createdAt;
  const NoiseLogsTableData({
    required this.id,
    required this.type,
    this.intensity,
    this.note,
    required this.sourceType,
    required this.logDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || intensity != null) {
      map['intensity'] = Variable<int>(intensity);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source_type'] = Variable<String>(sourceType);
    map['log_date'] = Variable<DateTime>(logDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NoiseLogsTableCompanion toCompanion(bool nullToAbsent) {
    return NoiseLogsTableCompanion(
      id: Value(id),
      type: Value(type),
      intensity: intensity == null && nullToAbsent
          ? const Value.absent()
          : Value(intensity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      sourceType: Value(sourceType),
      logDate: Value(logDate),
      createdAt: Value(createdAt),
    );
  }

  factory NoiseLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoiseLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      intensity: serializer.fromJson<int?>(json['intensity']),
      note: serializer.fromJson<String?>(json['note']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'intensity': serializer.toJson<int?>(intensity),
      'note': serializer.toJson<String?>(note),
      'sourceType': serializer.toJson<String>(sourceType),
      'logDate': serializer.toJson<DateTime>(logDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NoiseLogsTableData copyWith({
    int? id,
    String? type,
    Value<int?> intensity = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? sourceType,
    DateTime? logDate,
    DateTime? createdAt,
  }) => NoiseLogsTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    intensity: intensity.present ? intensity.value : this.intensity,
    note: note.present ? note.value : this.note,
    sourceType: sourceType ?? this.sourceType,
    logDate: logDate ?? this.logDate,
    createdAt: createdAt ?? this.createdAt,
  );
  NoiseLogsTableData copyWithCompanion(NoiseLogsTableCompanion data) {
    return NoiseLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      note: data.note.present ? data.note.value : this.note,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoiseLogsTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('intensity: $intensity, ')
          ..write('note: $note, ')
          ..write('sourceType: $sourceType, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, intensity, note, sourceType, logDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoiseLogsTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.intensity == this.intensity &&
          other.note == this.note &&
          other.sourceType == this.sourceType &&
          other.logDate == this.logDate &&
          other.createdAt == this.createdAt);
}

class NoiseLogsTableCompanion extends UpdateCompanion<NoiseLogsTableData> {
  final Value<int> id;
  final Value<String> type;
  final Value<int?> intensity;
  final Value<String?> note;
  final Value<String> sourceType;
  final Value<DateTime> logDate;
  final Value<DateTime> createdAt;
  const NoiseLogsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.intensity = const Value.absent(),
    this.note = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.logDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NoiseLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.intensity = const Value.absent(),
    this.note = const Value.absent(),
    required String sourceType,
    this.logDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : type = Value(type),
       sourceType = Value(sourceType);
  static Insertable<NoiseLogsTableData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? intensity,
    Expression<String>? note,
    Expression<String>? sourceType,
    Expression<DateTime>? logDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (intensity != null) 'intensity': intensity,
      if (note != null) 'note': note,
      if (sourceType != null) 'source_type': sourceType,
      if (logDate != null) 'log_date': logDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NoiseLogsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<int?>? intensity,
    Value<String?>? note,
    Value<String>? sourceType,
    Value<DateTime>? logDate,
    Value<DateTime>? createdAt,
  }) {
    return NoiseLogsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      sourceType: sourceType ?? this.sourceType,
      logDate: logDate ?? this.logDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoiseLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('intensity: $intensity, ')
          ..write('note: $note, ')
          ..write('sourceType: $sourceType, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KineticChainEdgesTableTable extends KineticChainEdgesTable
    with TableInfo<$KineticChainEdgesTableTable, KineticChainEdgesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KineticChainEdgesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sourceNodeMeta = const VerificationMeta(
    'sourceNode',
  );
  @override
  late final GeneratedColumn<String> sourceNode = GeneratedColumn<String>(
    'source_node',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetNodeMeta = const VerificationMeta(
    'targetNode',
  );
  @override
  late final GeneratedColumn<String> targetNode = GeneratedColumn<String>(
    'target_node',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correlationStrengthMeta =
      const VerificationMeta('correlationStrength');
  @override
  late final GeneratedColumn<double> correlationStrength =
      GeneratedColumn<double>(
        'correlation_strength',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _certaintyScoreMeta = const VerificationMeta(
    'certaintyScore',
  );
  @override
  late final GeneratedColumn<double> certaintyScore = GeneratedColumn<double>(
    'certainty_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _edgeTypeMeta = const VerificationMeta(
    'edgeType',
  );
  @override
  late final GeneratedColumn<String> edgeType = GeneratedColumn<String>(
    'edge_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceNode,
    targetNode,
    weight,
    correlationStrength,
    certaintyScore,
    edgeType,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kinetic_chain_edges_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<KineticChainEdgesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_node')) {
      context.handle(
        _sourceNodeMeta,
        sourceNode.isAcceptableOrUnknown(data['source_node']!, _sourceNodeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNodeMeta);
    }
    if (data.containsKey('target_node')) {
      context.handle(
        _targetNodeMeta,
        targetNode.isAcceptableOrUnknown(data['target_node']!, _targetNodeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetNodeMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('correlation_strength')) {
      context.handle(
        _correlationStrengthMeta,
        correlationStrength.isAcceptableOrUnknown(
          data['correlation_strength']!,
          _correlationStrengthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correlationStrengthMeta);
    }
    if (data.containsKey('certainty_score')) {
      context.handle(
        _certaintyScoreMeta,
        certaintyScore.isAcceptableOrUnknown(
          data['certainty_score']!,
          _certaintyScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_certaintyScoreMeta);
    }
    if (data.containsKey('edge_type')) {
      context.handle(
        _edgeTypeMeta,
        edgeType.isAcceptableOrUnknown(data['edge_type']!, _edgeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_edgeTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  KineticChainEdgesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KineticChainEdgesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceNode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_node'],
      )!,
      targetNode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_node'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      correlationStrength: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}correlation_strength'],
      )!,
      certaintyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}certainty_score'],
      )!,
      edgeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edge_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KineticChainEdgesTableTable createAlias(String alias) {
    return $KineticChainEdgesTableTable(attachedDatabase, alias);
  }
}

class KineticChainEdgesTableData extends DataClass
    implements Insertable<KineticChainEdgesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Source body segment node of the edge.
  final String sourceNode;

  /// Target body segment node of the edge.
  final String targetNode;

  /// Weight of the kinetic chain edge.
  final double weight;

  /// Measured correlation strength between the connected nodes.
  final double correlationStrength;

  /// Certainty score for the edge relationship.
  final double certaintyScore;

  /// Type of the kinetic chain edge.
  final String edgeType;

  /// Timestamp when the edge record was created.
  final DateTime createdAt;

  /// Timestamp when the edge record was last updated.
  final DateTime updatedAt;
  const KineticChainEdgesTableData({
    required this.id,
    required this.sourceNode,
    required this.targetNode,
    required this.weight,
    required this.correlationStrength,
    required this.certaintyScore,
    required this.edgeType,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_node'] = Variable<String>(sourceNode);
    map['target_node'] = Variable<String>(targetNode);
    map['weight'] = Variable<double>(weight);
    map['correlation_strength'] = Variable<double>(correlationStrength);
    map['certainty_score'] = Variable<double>(certaintyScore);
    map['edge_type'] = Variable<String>(edgeType);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KineticChainEdgesTableCompanion toCompanion(bool nullToAbsent) {
    return KineticChainEdgesTableCompanion(
      id: Value(id),
      sourceNode: Value(sourceNode),
      targetNode: Value(targetNode),
      weight: Value(weight),
      correlationStrength: Value(correlationStrength),
      certaintyScore: Value(certaintyScore),
      edgeType: Value(edgeType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KineticChainEdgesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KineticChainEdgesTableData(
      id: serializer.fromJson<int>(json['id']),
      sourceNode: serializer.fromJson<String>(json['sourceNode']),
      targetNode: serializer.fromJson<String>(json['targetNode']),
      weight: serializer.fromJson<double>(json['weight']),
      correlationStrength: serializer.fromJson<double>(
        json['correlationStrength'],
      ),
      certaintyScore: serializer.fromJson<double>(json['certaintyScore']),
      edgeType: serializer.fromJson<String>(json['edgeType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceNode': serializer.toJson<String>(sourceNode),
      'targetNode': serializer.toJson<String>(targetNode),
      'weight': serializer.toJson<double>(weight),
      'correlationStrength': serializer.toJson<double>(correlationStrength),
      'certaintyScore': serializer.toJson<double>(certaintyScore),
      'edgeType': serializer.toJson<String>(edgeType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KineticChainEdgesTableData copyWith({
    int? id,
    String? sourceNode,
    String? targetNode,
    double? weight,
    double? correlationStrength,
    double? certaintyScore,
    String? edgeType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KineticChainEdgesTableData(
    id: id ?? this.id,
    sourceNode: sourceNode ?? this.sourceNode,
    targetNode: targetNode ?? this.targetNode,
    weight: weight ?? this.weight,
    correlationStrength: correlationStrength ?? this.correlationStrength,
    certaintyScore: certaintyScore ?? this.certaintyScore,
    edgeType: edgeType ?? this.edgeType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KineticChainEdgesTableData copyWithCompanion(
    KineticChainEdgesTableCompanion data,
  ) {
    return KineticChainEdgesTableData(
      id: data.id.present ? data.id.value : this.id,
      sourceNode: data.sourceNode.present
          ? data.sourceNode.value
          : this.sourceNode,
      targetNode: data.targetNode.present
          ? data.targetNode.value
          : this.targetNode,
      weight: data.weight.present ? data.weight.value : this.weight,
      correlationStrength: data.correlationStrength.present
          ? data.correlationStrength.value
          : this.correlationStrength,
      certaintyScore: data.certaintyScore.present
          ? data.certaintyScore.value
          : this.certaintyScore,
      edgeType: data.edgeType.present ? data.edgeType.value : this.edgeType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KineticChainEdgesTableData(')
          ..write('id: $id, ')
          ..write('sourceNode: $sourceNode, ')
          ..write('targetNode: $targetNode, ')
          ..write('weight: $weight, ')
          ..write('correlationStrength: $correlationStrength, ')
          ..write('certaintyScore: $certaintyScore, ')
          ..write('edgeType: $edgeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceNode,
    targetNode,
    weight,
    correlationStrength,
    certaintyScore,
    edgeType,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KineticChainEdgesTableData &&
          other.id == this.id &&
          other.sourceNode == this.sourceNode &&
          other.targetNode == this.targetNode &&
          other.weight == this.weight &&
          other.correlationStrength == this.correlationStrength &&
          other.certaintyScore == this.certaintyScore &&
          other.edgeType == this.edgeType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KineticChainEdgesTableCompanion
    extends UpdateCompanion<KineticChainEdgesTableData> {
  final Value<int> id;
  final Value<String> sourceNode;
  final Value<String> targetNode;
  final Value<double> weight;
  final Value<double> correlationStrength;
  final Value<double> certaintyScore;
  final Value<String> edgeType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KineticChainEdgesTableCompanion({
    this.id = const Value.absent(),
    this.sourceNode = const Value.absent(),
    this.targetNode = const Value.absent(),
    this.weight = const Value.absent(),
    this.correlationStrength = const Value.absent(),
    this.certaintyScore = const Value.absent(),
    this.edgeType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KineticChainEdgesTableCompanion.insert({
    this.id = const Value.absent(),
    required String sourceNode,
    required String targetNode,
    required double weight,
    required double correlationStrength,
    required double certaintyScore,
    required String edgeType,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : sourceNode = Value(sourceNode),
       targetNode = Value(targetNode),
       weight = Value(weight),
       correlationStrength = Value(correlationStrength),
       certaintyScore = Value(certaintyScore),
       edgeType = Value(edgeType);
  static Insertable<KineticChainEdgesTableData> custom({
    Expression<int>? id,
    Expression<String>? sourceNode,
    Expression<String>? targetNode,
    Expression<double>? weight,
    Expression<double>? correlationStrength,
    Expression<double>? certaintyScore,
    Expression<String>? edgeType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceNode != null) 'source_node': sourceNode,
      if (targetNode != null) 'target_node': targetNode,
      if (weight != null) 'weight': weight,
      if (correlationStrength != null)
        'correlation_strength': correlationStrength,
      if (certaintyScore != null) 'certainty_score': certaintyScore,
      if (edgeType != null) 'edge_type': edgeType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KineticChainEdgesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? sourceNode,
    Value<String>? targetNode,
    Value<double>? weight,
    Value<double>? correlationStrength,
    Value<double>? certaintyScore,
    Value<String>? edgeType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KineticChainEdgesTableCompanion(
      id: id ?? this.id,
      sourceNode: sourceNode ?? this.sourceNode,
      targetNode: targetNode ?? this.targetNode,
      weight: weight ?? this.weight,
      correlationStrength: correlationStrength ?? this.correlationStrength,
      certaintyScore: certaintyScore ?? this.certaintyScore,
      edgeType: edgeType ?? this.edgeType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceNode.present) {
      map['source_node'] = Variable<String>(sourceNode.value);
    }
    if (targetNode.present) {
      map['target_node'] = Variable<String>(targetNode.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (correlationStrength.present) {
      map['correlation_strength'] = Variable<double>(correlationStrength.value);
    }
    if (certaintyScore.present) {
      map['certainty_score'] = Variable<double>(certaintyScore.value);
    }
    if (edgeType.present) {
      map['edge_type'] = Variable<String>(edgeType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KineticChainEdgesTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceNode: $sourceNode, ')
          ..write('targetNode: $targetNode, ')
          ..write('weight: $weight, ')
          ..write('correlationStrength: $correlationStrength, ')
          ..write('certaintyScore: $certaintyScore, ')
          ..write('edgeType: $edgeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BodySegmentsTableTable extends BodySegmentsTable
    with TableInfo<$BodySegmentsTableTable, BodySegmentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodySegmentsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _integrityScoreMeta = const VerificationMeta(
    'integrityScore',
  );
  @override
  late final GeneratedColumn<double> integrityScore = GeneratedColumn<double>(
    'integrity_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    clientDefault: () => 1.0,
  );
  static const VerificationMeta _heatIndexMeta = const VerificationMeta(
    'heatIndex',
  );
  @override
  late final GeneratedColumn<String> heatIndex = GeneratedColumn<String>(
    'heat_index',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    region,
    description,
    integrityScore,
    heatIndex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_segments_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodySegmentsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    } else if (isInserting) {
      context.missing(_regionMeta);
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
    if (data.containsKey('integrity_score')) {
      context.handle(
        _integrityScoreMeta,
        integrityScore.isAcceptableOrUnknown(
          data['integrity_score']!,
          _integrityScoreMeta,
        ),
      );
    }
    if (data.containsKey('heat_index')) {
      context.handle(
        _heatIndexMeta,
        heatIndex.isAcceptableOrUnknown(data['heat_index']!, _heatIndexMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  BodySegmentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodySegmentsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      integrityScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}integrity_score'],
      )!,
      heatIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}heat_index'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BodySegmentsTableTable createAlias(String alias) {
    return $BodySegmentsTableTable(attachedDatabase, alias);
  }
}

class BodySegmentsTableData extends DataClass
    implements Insertable<BodySegmentsTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Display name of the body segment.
  final String name;

  /// Anatomical region of the body segment.
  final String region;

  /// Description of the body segment and its role.
  final String? description;

  /// Structural integrity score (defaults to 1.0).
  final double integrityScore;

  /// Heat index for the body segment.
  final String? heatIndex;

  /// Timestamp when the segment record was created.
  final DateTime createdAt;

  /// Timestamp when the segment record was last updated.
  final DateTime updatedAt;
  const BodySegmentsTableData({
    required this.id,
    required this.name,
    required this.region,
    this.description,
    required this.integrityScore,
    this.heatIndex,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['region'] = Variable<String>(region);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['integrity_score'] = Variable<double>(integrityScore);
    if (!nullToAbsent || heatIndex != null) {
      map['heat_index'] = Variable<String>(heatIndex);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BodySegmentsTableCompanion toCompanion(bool nullToAbsent) {
    return BodySegmentsTableCompanion(
      id: Value(id),
      name: Value(name),
      region: Value(region),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      integrityScore: Value(integrityScore),
      heatIndex: heatIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(heatIndex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BodySegmentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodySegmentsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      region: serializer.fromJson<String>(json['region']),
      description: serializer.fromJson<String?>(json['description']),
      integrityScore: serializer.fromJson<double>(json['integrityScore']),
      heatIndex: serializer.fromJson<String?>(json['heatIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'region': serializer.toJson<String>(region),
      'description': serializer.toJson<String?>(description),
      'integrityScore': serializer.toJson<double>(integrityScore),
      'heatIndex': serializer.toJson<String?>(heatIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BodySegmentsTableData copyWith({
    int? id,
    String? name,
    String? region,
    Value<String?> description = const Value.absent(),
    double? integrityScore,
    Value<String?> heatIndex = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BodySegmentsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    region: region ?? this.region,
    description: description.present ? description.value : this.description,
    integrityScore: integrityScore ?? this.integrityScore,
    heatIndex: heatIndex.present ? heatIndex.value : this.heatIndex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BodySegmentsTableData copyWithCompanion(BodySegmentsTableCompanion data) {
    return BodySegmentsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      region: data.region.present ? data.region.value : this.region,
      description: data.description.present
          ? data.description.value
          : this.description,
      integrityScore: data.integrityScore.present
          ? data.integrityScore.value
          : this.integrityScore,
      heatIndex: data.heatIndex.present ? data.heatIndex.value : this.heatIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodySegmentsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('description: $description, ')
          ..write('integrityScore: $integrityScore, ')
          ..write('heatIndex: $heatIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    region,
    description,
    integrityScore,
    heatIndex,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodySegmentsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.region == this.region &&
          other.description == this.description &&
          other.integrityScore == this.integrityScore &&
          other.heatIndex == this.heatIndex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BodySegmentsTableCompanion
    extends UpdateCompanion<BodySegmentsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> region;
  final Value<String?> description;
  final Value<double> integrityScore;
  final Value<String?> heatIndex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BodySegmentsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.region = const Value.absent(),
    this.description = const Value.absent(),
    this.integrityScore = const Value.absent(),
    this.heatIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BodySegmentsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String region,
    this.description = const Value.absent(),
    this.integrityScore = const Value.absent(),
    this.heatIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       region = Value(region);
  static Insertable<BodySegmentsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? region,
    Expression<String>? description,
    Expression<double>? integrityScore,
    Expression<String>? heatIndex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (region != null) 'region': region,
      if (description != null) 'description': description,
      if (integrityScore != null) 'integrity_score': integrityScore,
      if (heatIndex != null) 'heat_index': heatIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BodySegmentsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? region,
    Value<String?>? description,
    Value<double>? integrityScore,
    Value<String?>? heatIndex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BodySegmentsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      description: description ?? this.description,
      integrityScore: integrityScore ?? this.integrityScore,
      heatIndex: heatIndex ?? this.heatIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (integrityScore.present) {
      map['integrity_score'] = Variable<double>(integrityScore.value);
    }
    if (heatIndex.present) {
      map['heat_index'] = Variable<String>(heatIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodySegmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('description: $description, ')
          ..write('integrityScore: $integrityScore, ')
          ..write('heatIndex: $heatIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DriveSettingsTableTable extends DriveSettingsTable
    with TableInfo<$DriveSettingsTableTable, DriveSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriveSettingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _settingNameMeta = const VerificationMeta(
    'settingName',
  );
  @override
  late final GeneratedColumn<String> settingName = GeneratedColumn<String>(
    'setting_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    settingName,
    value,
    scope,
    nodeId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drive_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriveSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('setting_name')) {
      context.handle(
        _settingNameMeta,
        settingName.isAcceptableOrUnknown(
          data['setting_name']!,
          _settingNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingNameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  DriveSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriveSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      settingName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DriveSettingsTableTable createAlias(String alias) {
    return $DriveSettingsTableTable(attachedDatabase, alias);
  }
}

class DriveSettingsTableData extends DataClass
    implements Insertable<DriveSettingsTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Name of the intensity/drive setting.
  final String settingName;

  /// Numerical value of the setting.
  final double value;

  /// Scope of the setting (e.g. global, per-node).
  final String scope;

  /// Node ID the setting applies to (nullable for global settings).
  final String? nodeId;

  /// Timestamp when the setting record was created.
  final DateTime createdAt;

  /// Timestamp when the setting record was last updated.
  final DateTime updatedAt;
  const DriveSettingsTableData({
    required this.id,
    required this.settingName,
    required this.value,
    required this.scope,
    this.nodeId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['setting_name'] = Variable<String>(settingName);
    map['value'] = Variable<double>(value);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || nodeId != null) {
      map['node_id'] = Variable<String>(nodeId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DriveSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return DriveSettingsTableCompanion(
      id: Value(id),
      settingName: Value(settingName),
      value: Value(value),
      scope: Value(scope),
      nodeId: nodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(nodeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriveSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriveSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      settingName: serializer.fromJson<String>(json['settingName']),
      value: serializer.fromJson<double>(json['value']),
      scope: serializer.fromJson<String>(json['scope']),
      nodeId: serializer.fromJson<String?>(json['nodeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'settingName': serializer.toJson<String>(settingName),
      'value': serializer.toJson<double>(value),
      'scope': serializer.toJson<String>(scope),
      'nodeId': serializer.toJson<String?>(nodeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriveSettingsTableData copyWith({
    int? id,
    String? settingName,
    double? value,
    String? scope,
    Value<String?> nodeId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DriveSettingsTableData(
    id: id ?? this.id,
    settingName: settingName ?? this.settingName,
    value: value ?? this.value,
    scope: scope ?? this.scope,
    nodeId: nodeId.present ? nodeId.value : this.nodeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriveSettingsTableData copyWithCompanion(DriveSettingsTableCompanion data) {
    return DriveSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      settingName: data.settingName.present
          ? data.settingName.value
          : this.settingName,
      value: data.value.present ? data.value.value : this.value,
      scope: data.scope.present ? data.scope.value : this.scope,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriveSettingsTableData(')
          ..write('id: $id, ')
          ..write('settingName: $settingName, ')
          ..write('value: $value, ')
          ..write('scope: $scope, ')
          ..write('nodeId: $nodeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, settingName, value, scope, nodeId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriveSettingsTableData &&
          other.id == this.id &&
          other.settingName == this.settingName &&
          other.value == this.value &&
          other.scope == this.scope &&
          other.nodeId == this.nodeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DriveSettingsTableCompanion
    extends UpdateCompanion<DriveSettingsTableData> {
  final Value<int> id;
  final Value<String> settingName;
  final Value<double> value;
  final Value<String> scope;
  final Value<String?> nodeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DriveSettingsTableCompanion({
    this.id = const Value.absent(),
    this.settingName = const Value.absent(),
    this.value = const Value.absent(),
    this.scope = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DriveSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String settingName,
    required double value,
    required String scope,
    this.nodeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : settingName = Value(settingName),
       value = Value(value),
       scope = Value(scope);
  static Insertable<DriveSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? settingName,
    Expression<double>? value,
    Expression<String>? scope,
    Expression<String>? nodeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (settingName != null) 'setting_name': settingName,
      if (value != null) 'value': value,
      if (scope != null) 'scope': scope,
      if (nodeId != null) 'node_id': nodeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DriveSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? settingName,
    Value<double>? value,
    Value<String>? scope,
    Value<String?>? nodeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DriveSettingsTableCompanion(
      id: id ?? this.id,
      settingName: settingName ?? this.settingName,
      value: value ?? this.value,
      scope: scope ?? this.scope,
      nodeId: nodeId ?? this.nodeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (settingName.present) {
      map['setting_name'] = Variable<String>(settingName.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriveSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('settingName: $settingName, ')
          ..write('value: $value, ')
          ..write('scope: $scope, ')
          ..write('nodeId: $nodeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DeviceSyncStateTableTable extends DeviceSyncStateTable
    with TableInfo<$DeviceSyncStateTableTable, DeviceSyncStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceSyncStateTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncTimestampMeta = const VerificationMeta(
    'lastSyncTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncTimestamp =
      GeneratedColumn<DateTime>(
        'last_sync_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    lastSyncTimestamp,
    direction,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_sync_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceSyncStateTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('last_sync_timestamp')) {
      context.handle(
        _lastSyncTimestampMeta,
        lastSyncTimestamp.isAcceptableOrUnknown(
          data['last_sync_timestamp']!,
          _lastSyncTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncTimestampMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  DeviceSyncStateTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceSyncStateTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      lastSyncTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_timestamp'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DeviceSyncStateTableTable createAlias(String alias) {
    return $DeviceSyncStateTableTable(attachedDatabase, alias);
  }
}

class DeviceSyncStateTableData extends DataClass
    implements Insertable<DeviceSyncStateTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Unique device identifier for sync tracking.
  final String deviceId;

  /// Last sync timestamp for this device.
  final DateTime lastSyncTimestamp;

  /// Sync direction (e.g. upload, download).
  final String direction;

  /// Timestamp when the sync state record was created.
  final DateTime createdAt;

  /// Timestamp when the sync state record was last updated.
  final DateTime updatedAt;
  const DeviceSyncStateTableData({
    required this.id,
    required this.deviceId,
    required this.lastSyncTimestamp,
    required this.direction,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['last_sync_timestamp'] = Variable<DateTime>(lastSyncTimestamp);
    map['direction'] = Variable<String>(direction);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DeviceSyncStateTableCompanion toCompanion(bool nullToAbsent) {
    return DeviceSyncStateTableCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      lastSyncTimestamp: Value(lastSyncTimestamp),
      direction: Value(direction),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeviceSyncStateTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceSyncStateTableData(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      lastSyncTimestamp: serializer.fromJson<DateTime>(
        json['lastSyncTimestamp'],
      ),
      direction: serializer.fromJson<String>(json['direction']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'lastSyncTimestamp': serializer.toJson<DateTime>(lastSyncTimestamp),
      'direction': serializer.toJson<String>(direction),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DeviceSyncStateTableData copyWith({
    int? id,
    String? deviceId,
    DateTime? lastSyncTimestamp,
    String? direction,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DeviceSyncStateTableData(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    lastSyncTimestamp: lastSyncTimestamp ?? this.lastSyncTimestamp,
    direction: direction ?? this.direction,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DeviceSyncStateTableData copyWithCompanion(
    DeviceSyncStateTableCompanion data,
  ) {
    return DeviceSyncStateTableData(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      lastSyncTimestamp: data.lastSyncTimestamp.present
          ? data.lastSyncTimestamp.value
          : this.lastSyncTimestamp,
      direction: data.direction.present ? data.direction.value : this.direction,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceSyncStateTableData(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastSyncTimestamp: $lastSyncTimestamp, ')
          ..write('direction: $direction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    lastSyncTimestamp,
    direction,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceSyncStateTableData &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.lastSyncTimestamp == this.lastSyncTimestamp &&
          other.direction == this.direction &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DeviceSyncStateTableCompanion
    extends UpdateCompanion<DeviceSyncStateTableData> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<DateTime> lastSyncTimestamp;
  final Value<String> direction;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DeviceSyncStateTableCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.lastSyncTimestamp = const Value.absent(),
    this.direction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DeviceSyncStateTableCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required DateTime lastSyncTimestamp,
    required String direction,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : deviceId = Value(deviceId),
       lastSyncTimestamp = Value(lastSyncTimestamp),
       direction = Value(direction);
  static Insertable<DeviceSyncStateTableData> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<DateTime>? lastSyncTimestamp,
    Expression<String>? direction,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (lastSyncTimestamp != null) 'last_sync_timestamp': lastSyncTimestamp,
      if (direction != null) 'direction': direction,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DeviceSyncStateTableCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<DateTime>? lastSyncTimestamp,
    Value<String>? direction,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DeviceSyncStateTableCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      lastSyncTimestamp: lastSyncTimestamp ?? this.lastSyncTimestamp,
      direction: direction ?? this.direction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (lastSyncTimestamp.present) {
      map['last_sync_timestamp'] = Variable<DateTime>(lastSyncTimestamp.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceSyncStateTableCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastSyncTimestamp: $lastSyncTimestamp, ')
          ..write('direction: $direction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InjuriesTableTable extends InjuriesTable
    with TableInfo<$InjuriesTableTable, InjuriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InjuriesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bodyRegionMeta = const VerificationMeta(
    'bodyRegion',
  );
  @override
  late final GeneratedColumn<String> bodyRegion = GeneratedColumn<String>(
    'body_region',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _integrityScoreMeta = const VerificationMeta(
    'integrityScore',
  );
  @override
  late final GeneratedColumn<double> integrityScore = GeneratedColumn<double>(
    'integrity_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    clientDefault: () => 1.0,
  );
  static const VerificationMeta _functionalOffsetsMeta = const VerificationMeta(
    'functionalOffsets',
  );
  @override
  late final GeneratedColumn<String> functionalOffsets =
      GeneratedColumn<String>(
        'functional_offsets',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _narrativeMeta = const VerificationMeta(
    'narrative',
  );
  @override
  late final GeneratedColumn<String> narrative = GeneratedColumn<String>(
    'narrative',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bodyRegion,
    type,
    integrityScore,
    functionalOffsets,
    narrative,
    status,
    date,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'injuries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InjuriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('body_region')) {
      context.handle(
        _bodyRegionMeta,
        bodyRegion.isAcceptableOrUnknown(data['body_region']!, _bodyRegionMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyRegionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('integrity_score')) {
      context.handle(
        _integrityScoreMeta,
        integrityScore.isAcceptableOrUnknown(
          data['integrity_score']!,
          _integrityScoreMeta,
        ),
      );
    }
    if (data.containsKey('functional_offsets')) {
      context.handle(
        _functionalOffsetsMeta,
        functionalOffsets.isAcceptableOrUnknown(
          data['functional_offsets']!,
          _functionalOffsetsMeta,
        ),
      );
    }
    if (data.containsKey('narrative')) {
      context.handle(
        _narrativeMeta,
        narrative.isAcceptableOrUnknown(data['narrative']!, _narrativeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  InjuriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InjuriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bodyRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_region'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      integrityScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}integrity_score'],
      )!,
      functionalOffsets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}functional_offsets'],
      ),
      narrative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}narrative'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InjuriesTableTable createAlias(String alias) {
    return $InjuriesTableTable(attachedDatabase, alias);
  }
}

class InjuriesTableData extends DataClass
    implements Insertable<InjuriesTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Body region affected by the injury.
  final String bodyRegion;

  /// Injury type classification.
  final String type;

  /// Structural integrity score (defaults to 1.0).
  final double integrityScore;

  /// Functional offsets caused by the injury.
  final String? functionalOffsets;

  /// Narrative description of the injury.
  final String? narrative;

  /// Current status of the injury (e.g. active, healed).
  final String status;

  /// Date the injury occurred.
  final DateTime date;

  /// Timestamp when the injury record was created.
  final DateTime createdAt;

  /// Timestamp when the injury record was last updated.
  final DateTime updatedAt;
  const InjuriesTableData({
    required this.id,
    required this.bodyRegion,
    required this.type,
    required this.integrityScore,
    this.functionalOffsets,
    this.narrative,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['body_region'] = Variable<String>(bodyRegion);
    map['type'] = Variable<String>(type);
    map['integrity_score'] = Variable<double>(integrityScore);
    if (!nullToAbsent || functionalOffsets != null) {
      map['functional_offsets'] = Variable<String>(functionalOffsets);
    }
    if (!nullToAbsent || narrative != null) {
      map['narrative'] = Variable<String>(narrative);
    }
    map['status'] = Variable<String>(status);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InjuriesTableCompanion toCompanion(bool nullToAbsent) {
    return InjuriesTableCompanion(
      id: Value(id),
      bodyRegion: Value(bodyRegion),
      type: Value(type),
      integrityScore: Value(integrityScore),
      functionalOffsets: functionalOffsets == null && nullToAbsent
          ? const Value.absent()
          : Value(functionalOffsets),
      narrative: narrative == null && nullToAbsent
          ? const Value.absent()
          : Value(narrative),
      status: Value(status),
      date: Value(date),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InjuriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InjuriesTableData(
      id: serializer.fromJson<int>(json['id']),
      bodyRegion: serializer.fromJson<String>(json['bodyRegion']),
      type: serializer.fromJson<String>(json['type']),
      integrityScore: serializer.fromJson<double>(json['integrityScore']),
      functionalOffsets: serializer.fromJson<String?>(
        json['functionalOffsets'],
      ),
      narrative: serializer.fromJson<String?>(json['narrative']),
      status: serializer.fromJson<String>(json['status']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bodyRegion': serializer.toJson<String>(bodyRegion),
      'type': serializer.toJson<String>(type),
      'integrityScore': serializer.toJson<double>(integrityScore),
      'functionalOffsets': serializer.toJson<String?>(functionalOffsets),
      'narrative': serializer.toJson<String?>(narrative),
      'status': serializer.toJson<String>(status),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InjuriesTableData copyWith({
    int? id,
    String? bodyRegion,
    String? type,
    double? integrityScore,
    Value<String?> functionalOffsets = const Value.absent(),
    Value<String?> narrative = const Value.absent(),
    String? status,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InjuriesTableData(
    id: id ?? this.id,
    bodyRegion: bodyRegion ?? this.bodyRegion,
    type: type ?? this.type,
    integrityScore: integrityScore ?? this.integrityScore,
    functionalOffsets: functionalOffsets.present
        ? functionalOffsets.value
        : this.functionalOffsets,
    narrative: narrative.present ? narrative.value : this.narrative,
    status: status ?? this.status,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InjuriesTableData copyWithCompanion(InjuriesTableCompanion data) {
    return InjuriesTableData(
      id: data.id.present ? data.id.value : this.id,
      bodyRegion: data.bodyRegion.present
          ? data.bodyRegion.value
          : this.bodyRegion,
      type: data.type.present ? data.type.value : this.type,
      integrityScore: data.integrityScore.present
          ? data.integrityScore.value
          : this.integrityScore,
      functionalOffsets: data.functionalOffsets.present
          ? data.functionalOffsets.value
          : this.functionalOffsets,
      narrative: data.narrative.present ? data.narrative.value : this.narrative,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InjuriesTableData(')
          ..write('id: $id, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('type: $type, ')
          ..write('integrityScore: $integrityScore, ')
          ..write('functionalOffsets: $functionalOffsets, ')
          ..write('narrative: $narrative, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bodyRegion,
    type,
    integrityScore,
    functionalOffsets,
    narrative,
    status,
    date,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InjuriesTableData &&
          other.id == this.id &&
          other.bodyRegion == this.bodyRegion &&
          other.type == this.type &&
          other.integrityScore == this.integrityScore &&
          other.functionalOffsets == this.functionalOffsets &&
          other.narrative == this.narrative &&
          other.status == this.status &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InjuriesTableCompanion extends UpdateCompanion<InjuriesTableData> {
  final Value<int> id;
  final Value<String> bodyRegion;
  final Value<String> type;
  final Value<double> integrityScore;
  final Value<String?> functionalOffsets;
  final Value<String?> narrative;
  final Value<String> status;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const InjuriesTableCompanion({
    this.id = const Value.absent(),
    this.bodyRegion = const Value.absent(),
    this.type = const Value.absent(),
    this.integrityScore = const Value.absent(),
    this.functionalOffsets = const Value.absent(),
    this.narrative = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InjuriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String bodyRegion,
    required String type,
    this.integrityScore = const Value.absent(),
    this.functionalOffsets = const Value.absent(),
    this.narrative = const Value.absent(),
    required String status,
    required DateTime date,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : bodyRegion = Value(bodyRegion),
       type = Value(type),
       status = Value(status),
       date = Value(date);
  static Insertable<InjuriesTableData> custom({
    Expression<int>? id,
    Expression<String>? bodyRegion,
    Expression<String>? type,
    Expression<double>? integrityScore,
    Expression<String>? functionalOffsets,
    Expression<String>? narrative,
    Expression<String>? status,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bodyRegion != null) 'body_region': bodyRegion,
      if (type != null) 'type': type,
      if (integrityScore != null) 'integrity_score': integrityScore,
      if (functionalOffsets != null) 'functional_offsets': functionalOffsets,
      if (narrative != null) 'narrative': narrative,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InjuriesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? bodyRegion,
    Value<String>? type,
    Value<double>? integrityScore,
    Value<String?>? functionalOffsets,
    Value<String?>? narrative,
    Value<String>? status,
    Value<DateTime>? date,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return InjuriesTableCompanion(
      id: id ?? this.id,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      type: type ?? this.type,
      integrityScore: integrityScore ?? this.integrityScore,
      functionalOffsets: functionalOffsets ?? this.functionalOffsets,
      narrative: narrative ?? this.narrative,
      status: status ?? this.status,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bodyRegion.present) {
      map['body_region'] = Variable<String>(bodyRegion.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (integrityScore.present) {
      map['integrity_score'] = Variable<double>(integrityScore.value);
    }
    if (functionalOffsets.present) {
      map['functional_offsets'] = Variable<String>(functionalOffsets.value);
    }
    if (narrative.present) {
      map['narrative'] = Variable<String>(narrative.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InjuriesTableCompanion(')
          ..write('id: $id, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('type: $type, ')
          ..write('integrityScore: $integrityScore, ')
          ..write('functionalOffsets: $functionalOffsets, ')
          ..write('narrative: $narrative, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EquipmentTableTable extends EquipmentTable
    with TableInfo<$EquipmentTableTable, EquipmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modalityMeta = const VerificationMeta(
    'modality',
  );
  @override
  late final GeneratedColumn<String> modality = GeneratedColumn<String>(
    'modality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorPointMeta = const VerificationMeta(
    'anchorPoint',
  );
  @override
  late final GeneratedColumn<String> anchorPoint = GeneratedColumn<String>(
    'anchor_point',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    clientDefault: () => true,
  );
  static const VerificationMeta _currentConfigurationMeta =
      const VerificationMeta('currentConfiguration');
  @override
  late final GeneratedColumn<String> currentConfiguration =
      GeneratedColumn<String>(
        'current_configuration',
        aliasedName,
        true,
        type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    modality,
    anchorPoint,
    active,
    currentConfiguration,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('modality')) {
      context.handle(
        _modalityMeta,
        modality.isAcceptableOrUnknown(data['modality']!, _modalityMeta),
      );
    } else if (isInserting) {
      context.missing(_modalityMeta);
    }
    if (data.containsKey('anchor_point')) {
      context.handle(
        _anchorPointMeta,
        anchorPoint.isAcceptableOrUnknown(
          data['anchor_point']!,
          _anchorPointMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('current_configuration')) {
      context.handle(
        _currentConfigurationMeta,
        currentConfiguration.isAcceptableOrUnknown(
          data['current_configuration']!,
          _currentConfigurationMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
  EquipmentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      modality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modality'],
      )!,
      anchorPoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_point'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      currentConfiguration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_configuration'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EquipmentTableTable createAlias(String alias) {
    return $EquipmentTableTable(attachedDatabase, alias);
  }
}

class EquipmentTableData extends DataClass
    implements Insertable<EquipmentTableData> {
  /// Auto-incrementing primary key identifier.
  final int id;

  /// Display name of the equipment.
  final String name;

  /// Equipment modality type.
  final String modality;

  /// Anchor point where the equipment is positioned.
  final String? anchorPoint;

  /// Whether the equipment is currently active (defaults to true).
  final bool active;

  /// Current configuration state of the equipment.
  final String? currentConfiguration;

  /// Timestamp when the equipment record was created.
  final DateTime createdAt;

  /// Timestamp when the equipment record was last updated.
  final DateTime updatedAt;
  const EquipmentTableData({
    required this.id,
    required this.name,
    required this.modality,
    this.anchorPoint,
    required this.active,
    this.currentConfiguration,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['modality'] = Variable<String>(modality);
    if (!nullToAbsent || anchorPoint != null) {
      map['anchor_point'] = Variable<String>(anchorPoint);
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || currentConfiguration != null) {
      map['current_configuration'] = Variable<String>(currentConfiguration);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EquipmentTableCompanion toCompanion(bool nullToAbsent) {
    return EquipmentTableCompanion(
      id: Value(id),
      name: Value(name),
      modality: Value(modality),
      anchorPoint: anchorPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(anchorPoint),
      active: Value(active),
      currentConfiguration: currentConfiguration == null && nullToAbsent
          ? const Value.absent()
          : Value(currentConfiguration),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EquipmentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      modality: serializer.fromJson<String>(json['modality']),
      anchorPoint: serializer.fromJson<String?>(json['anchorPoint']),
      active: serializer.fromJson<bool>(json['active']),
      currentConfiguration: serializer.fromJson<String?>(
        json['currentConfiguration'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'modality': serializer.toJson<String>(modality),
      'anchorPoint': serializer.toJson<String?>(anchorPoint),
      'active': serializer.toJson<bool>(active),
      'currentConfiguration': serializer.toJson<String?>(currentConfiguration),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EquipmentTableData copyWith({
    int? id,
    String? name,
    String? modality,
    Value<String?> anchorPoint = const Value.absent(),
    bool? active,
    Value<String?> currentConfiguration = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EquipmentTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    modality: modality ?? this.modality,
    anchorPoint: anchorPoint.present ? anchorPoint.value : this.anchorPoint,
    active: active ?? this.active,
    currentConfiguration: currentConfiguration.present
        ? currentConfiguration.value
        : this.currentConfiguration,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EquipmentTableData copyWithCompanion(EquipmentTableCompanion data) {
    return EquipmentTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      modality: data.modality.present ? data.modality.value : this.modality,
      anchorPoint: data.anchorPoint.present
          ? data.anchorPoint.value
          : this.anchorPoint,
      active: data.active.present ? data.active.value : this.active,
      currentConfiguration: data.currentConfiguration.present
          ? data.currentConfiguration.value
          : this.currentConfiguration,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modality: $modality, ')
          ..write('anchorPoint: $anchorPoint, ')
          ..write('active: $active, ')
          ..write('currentConfiguration: $currentConfiguration, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    modality,
    anchorPoint,
    active,
    currentConfiguration,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.modality == this.modality &&
          other.anchorPoint == this.anchorPoint &&
          other.active == this.active &&
          other.currentConfiguration == this.currentConfiguration &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EquipmentTableCompanion extends UpdateCompanion<EquipmentTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> modality;
  final Value<String?> anchorPoint;
  final Value<bool> active;
  final Value<String?> currentConfiguration;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EquipmentTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.modality = const Value.absent(),
    this.anchorPoint = const Value.absent(),
    this.active = const Value.absent(),
    this.currentConfiguration = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EquipmentTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String modality,
    this.anchorPoint = const Value.absent(),
    this.active = const Value.absent(),
    this.currentConfiguration = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       modality = Value(modality);
  static Insertable<EquipmentTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? modality,
    Expression<String>? anchorPoint,
    Expression<bool>? active,
    Expression<String>? currentConfiguration,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (modality != null) 'modality': modality,
      if (anchorPoint != null) 'anchor_point': anchorPoint,
      if (active != null) 'active': active,
      if (currentConfiguration != null)
        'current_configuration': currentConfiguration,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EquipmentTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? modality,
    Value<String?>? anchorPoint,
    Value<bool>? active,
    Value<String?>? currentConfiguration,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EquipmentTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      modality: modality ?? this.modality,
      anchorPoint: anchorPoint ?? this.anchorPoint,
      active: active ?? this.active,
      currentConfiguration: currentConfiguration ?? this.currentConfiguration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (modality.present) {
      map['modality'] = Variable<String>(modality.value);
    }
    if (anchorPoint.present) {
      map['anchor_point'] = Variable<String>(anchorPoint.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (currentConfiguration.present) {
      map['current_configuration'] = Variable<String>(
        currentConfiguration.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modality: $modality, ')
          ..write('anchorPoint: $anchorPoint, ')
          ..write('active: $active, ')
          ..write('currentConfiguration: $currentConfiguration, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyoTwinDatabase extends GeneratedDatabase {
  _$MyoTwinDatabase(QueryExecutor e) : super(e);
  $MyoTwinDatabaseManager get managers => $MyoTwinDatabaseManager(this);
  late final $ExercisesTableTable exercisesTable = $ExercisesTableTable(this);
  late final $WorkoutLogsTableTable workoutLogsTable = $WorkoutLogsTableTable(
    this,
  );
  late final $SymptomLogsTableTable symptomLogsTable = $SymptomLogsTableTable(
    this,
  );
  late final $HypothesesTableTable hypothesesTable = $HypothesesTableTable(
    this,
  );
  late final $SourcesTableTable sourcesTable = $SourcesTableTable(this);
  late final $PrinciplesTableTable principlesTable = $PrinciplesTableTable(
    this,
  );
  late final $ResearchNotesTableTable researchNotesTable =
      $ResearchNotesTableTable(this);
  late final $NotificationContextTableTable notificationContextTable =
      $NotificationContextTableTable(this);
  late final $KnowledgeSourcesTableTable knowledgeSourcesTable =
      $KnowledgeSourcesTableTable(this);
  late final $NoiseLogsTableTable noiseLogsTable = $NoiseLogsTableTable(this);
  late final $KineticChainEdgesTableTable kineticChainEdgesTable =
      $KineticChainEdgesTableTable(this);
  late final $BodySegmentsTableTable bodySegmentsTable =
      $BodySegmentsTableTable(this);
  late final $DriveSettingsTableTable driveSettingsTable =
      $DriveSettingsTableTable(this);
  late final $DeviceSyncStateTableTable deviceSyncStateTable =
      $DeviceSyncStateTableTable(this);
  late final $InjuriesTableTable injuriesTable = $InjuriesTableTable(this);
  late final $EquipmentTableTable equipmentTable = $EquipmentTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercisesTable,
    workoutLogsTable,
    symptomLogsTable,
    hypothesesTable,
    sourcesTable,
    principlesTable,
    researchNotesTable,
    notificationContextTable,
    knowledgeSourcesTable,
    noiseLogsTable,
    kineticChainEdgesTable,
    bodySegmentsTable,
    driveSettingsTable,
    deviceSyncStateTable,
    injuriesTable,
    equipmentTable,
  ];
}

typedef $$ExercisesTableTableCreateCompanionBuilder =
    ExercisesTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required String category,
      required String targetMuscles,
      Value<String?> requiredEquipment,
      Value<double?> ringHeight,
      Value<int?> durationSecs,
      Value<String?> scientificRationale,
      Value<String?> equipmentNotes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ExercisesTableTableUpdateCompanionBuilder =
    ExercisesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String> category,
      Value<String> targetMuscles,
      Value<String?> requiredEquipment,
      Value<double?> ringHeight,
      Value<int?> durationSecs,
      Value<String?> scientificRationale,
      Value<String?> equipmentNotes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ExercisesTableTableReferences
    extends
        BaseReferences<
          _$MyoTwinDatabase,
          $ExercisesTableTable,
          ExercisesTableData
        > {
  $$ExercisesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutLogsTableTable, List<WorkoutLogsTableData>>
  _workoutLogsTableRefsTable(_$MyoTwinDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutLogsTable,
        aliasName: $_aliasNameGenerator(
          db.exercisesTable.id,
          db.workoutLogsTable.exerciseId,
        ),
      );

  $$WorkoutLogsTableTableProcessedTableManager get workoutLogsTableRefs {
    final manager = $$WorkoutLogsTableTableTableManager(
      $_db,
      $_db.workoutLogsTable,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutLogsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requiredEquipment => $composableBuilder(
    column: $table.requiredEquipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ringHeight => $composableBuilder(
    column: $table.ringHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scientificRationale => $composableBuilder(
    column: $table.scientificRationale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentNotes => $composableBuilder(
    column: $table.equipmentNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutLogsTableRefs(
    Expression<bool> Function($$WorkoutLogsTableTableFilterComposer f) f,
  ) {
    final $$WorkoutLogsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutLogsTable,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutLogsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requiredEquipment => $composableBuilder(
    column: $table.requiredEquipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ringHeight => $composableBuilder(
    column: $table.ringHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scientificRationale => $composableBuilder(
    column: $table.scientificRationale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentNotes => $composableBuilder(
    column: $table.equipmentNotes,
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
}

class $$ExercisesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requiredEquipment => $composableBuilder(
    column: $table.requiredEquipment,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ringHeight => $composableBuilder(
    column: $table.ringHeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scientificRationale => $composableBuilder(
    column: $table.scientificRationale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentNotes => $composableBuilder(
    column: $table.equipmentNotes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> workoutLogsTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutLogsTableTableAnnotationComposer a) f,
  ) {
    final $$WorkoutLogsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutLogsTable,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutLogsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $ExercisesTableTable,
          ExercisesTableData,
          $$ExercisesTableTableFilterComposer,
          $$ExercisesTableTableOrderingComposer,
          $$ExercisesTableTableAnnotationComposer,
          $$ExercisesTableTableCreateCompanionBuilder,
          $$ExercisesTableTableUpdateCompanionBuilder,
          (ExercisesTableData, $$ExercisesTableTableReferences),
          ExercisesTableData,
          PrefetchHooks Function({bool workoutLogsTableRefs})
        > {
  $$ExercisesTableTableTableManager(
    _$MyoTwinDatabase db,
    $ExercisesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> targetMuscles = const Value.absent(),
                Value<String?> requiredEquipment = const Value.absent(),
                Value<double?> ringHeight = const Value.absent(),
                Value<int?> durationSecs = const Value.absent(),
                Value<String?> scientificRationale = const Value.absent(),
                Value<String?> equipmentNotes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExercisesTableCompanion(
                id: id,
                name: name,
                description: description,
                category: category,
                targetMuscles: targetMuscles,
                requiredEquipment: requiredEquipment,
                ringHeight: ringHeight,
                durationSecs: durationSecs,
                scientificRationale: scientificRationale,
                equipmentNotes: equipmentNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required String category,
                required String targetMuscles,
                Value<String?> requiredEquipment = const Value.absent(),
                Value<double?> ringHeight = const Value.absent(),
                Value<int?> durationSecs = const Value.absent(),
                Value<String?> scientificRationale = const Value.absent(),
                Value<String?> equipmentNotes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExercisesTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                category: category,
                targetMuscles: targetMuscles,
                requiredEquipment: requiredEquipment,
                ringHeight: ringHeight,
                durationSecs: durationSecs,
                scientificRationale: scientificRationale,
                equipmentNotes: equipmentNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutLogsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutLogsTableRefs) db.workoutLogsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutLogsTableRefs)
                    await $_getPrefetchedData<
                      ExercisesTableData,
                      $ExercisesTableTable,
                      WorkoutLogsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableTableReferences
                          ._workoutLogsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExercisesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutLogsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.exerciseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $ExercisesTableTable,
      ExercisesTableData,
      $$ExercisesTableTableFilterComposer,
      $$ExercisesTableTableOrderingComposer,
      $$ExercisesTableTableAnnotationComposer,
      $$ExercisesTableTableCreateCompanionBuilder,
      $$ExercisesTableTableUpdateCompanionBuilder,
      (ExercisesTableData, $$ExercisesTableTableReferences),
      ExercisesTableData,
      PrefetchHooks Function({bool workoutLogsTableRefs})
    >;
typedef $$WorkoutLogsTableTableCreateCompanionBuilder =
    WorkoutLogsTableCompanion Function({
      Value<int> id,
      required int exerciseId,
      required int volume,
      Value<int?> durationSecs,
      Value<String?> notes,
      Value<double?> intensity,
      required String sourceType,
      Value<DateTime> logDate,
      Value<DateTime> createdAt,
    });
typedef $$WorkoutLogsTableTableUpdateCompanionBuilder =
    WorkoutLogsTableCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<int> volume,
      Value<int?> durationSecs,
      Value<String?> notes,
      Value<double?> intensity,
      Value<String> sourceType,
      Value<DateTime> logDate,
      Value<DateTime> createdAt,
    });

final class $$WorkoutLogsTableTableReferences
    extends
        BaseReferences<
          _$MyoTwinDatabase,
          $WorkoutLogsTableTable,
          WorkoutLogsTableData
        > {
  $$WorkoutLogsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTableTable _exerciseIdTable(_$MyoTwinDatabase db) =>
      db.exercisesTable.createAlias(
        $_aliasNameGenerator(
          db.workoutLogsTable.exerciseId,
          db.exercisesTable.id,
        ),
      );

  $$ExercisesTableTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableTableManager(
      $_db,
      $_db.exercisesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutLogsTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $WorkoutLogsTableTable> {
  $$WorkoutLogsTableTableFilterComposer({
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

  ColumnFilters<int> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableTableFilterComposer get exerciseId {
    final $$ExercisesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableFilterComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutLogsTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $WorkoutLogsTableTable> {
  $$WorkoutLogsTableTableOrderingComposer({
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

  ColumnOrderings<int> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableTableOrderingComposer get exerciseId {
    final $$ExercisesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableOrderingComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutLogsTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $WorkoutLogsTableTable> {
  $$WorkoutLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExercisesTableTableAnnotationComposer get exerciseId {
    final $$ExercisesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercisesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.exercisesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutLogsTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $WorkoutLogsTableTable,
          WorkoutLogsTableData,
          $$WorkoutLogsTableTableFilterComposer,
          $$WorkoutLogsTableTableOrderingComposer,
          $$WorkoutLogsTableTableAnnotationComposer,
          $$WorkoutLogsTableTableCreateCompanionBuilder,
          $$WorkoutLogsTableTableUpdateCompanionBuilder,
          (WorkoutLogsTableData, $$WorkoutLogsTableTableReferences),
          WorkoutLogsTableData,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$WorkoutLogsTableTableTableManager(
    _$MyoTwinDatabase db,
    $WorkoutLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> volume = const Value.absent(),
                Value<int?> durationSecs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> intensity = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkoutLogsTableCompanion(
                id: id,
                exerciseId: exerciseId,
                volume: volume,
                durationSecs: durationSecs,
                notes: notes,
                intensity: intensity,
                sourceType: sourceType,
                logDate: logDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required int volume,
                Value<int?> durationSecs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> intensity = const Value.absent(),
                required String sourceType,
                Value<DateTime> logDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkoutLogsTableCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                volume: volume,
                durationSecs: durationSecs,
                notes: notes,
                intensity: intensity,
                sourceType: sourceType,
                logDate: logDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutLogsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
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
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$WorkoutLogsTableTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$WorkoutLogsTableTableReferences
                                        ._exerciseIdTable(db)
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

typedef $$WorkoutLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $WorkoutLogsTableTable,
      WorkoutLogsTableData,
      $$WorkoutLogsTableTableFilterComposer,
      $$WorkoutLogsTableTableOrderingComposer,
      $$WorkoutLogsTableTableAnnotationComposer,
      $$WorkoutLogsTableTableCreateCompanionBuilder,
      $$WorkoutLogsTableTableUpdateCompanionBuilder,
      (WorkoutLogsTableData, $$WorkoutLogsTableTableReferences),
      WorkoutLogsTableData,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$SymptomLogsTableTableCreateCompanionBuilder =
    SymptomLogsTableCompanion Function({
      Value<int> id,
      required String muscleId,
      required int intensity,
      Value<String?> note,
      Value<String?> category,
      required String sourceType,
      Value<DateTime> logDate,
      Value<DateTime> createdAt,
    });
typedef $$SymptomLogsTableTableUpdateCompanionBuilder =
    SymptomLogsTableCompanion Function({
      Value<int> id,
      Value<String> muscleId,
      Value<int> intensity,
      Value<String?> note,
      Value<String?> category,
      Value<String> sourceType,
      Value<DateTime> logDate,
      Value<DateTime> createdAt,
    });

class $$SymptomLogsTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $SymptomLogsTableTable> {
  $$SymptomLogsTableTableFilterComposer({
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

  ColumnFilters<String> get muscleId => $composableBuilder(
    column: $table.muscleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SymptomLogsTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $SymptomLogsTableTable> {
  $$SymptomLogsTableTableOrderingComposer({
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

  ColumnOrderings<String> get muscleId => $composableBuilder(
    column: $table.muscleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SymptomLogsTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $SymptomLogsTableTable> {
  $$SymptomLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get muscleId =>
      $composableBuilder(column: $table.muscleId, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SymptomLogsTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $SymptomLogsTableTable,
          SymptomLogsTableData,
          $$SymptomLogsTableTableFilterComposer,
          $$SymptomLogsTableTableOrderingComposer,
          $$SymptomLogsTableTableAnnotationComposer,
          $$SymptomLogsTableTableCreateCompanionBuilder,
          $$SymptomLogsTableTableUpdateCompanionBuilder,
          (
            SymptomLogsTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $SymptomLogsTableTable,
              SymptomLogsTableData
            >,
          ),
          SymptomLogsTableData,
          PrefetchHooks Function()
        > {
  $$SymptomLogsTableTableTableManager(
    _$MyoTwinDatabase db,
    $SymptomLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> muscleId = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SymptomLogsTableCompanion(
                id: id,
                muscleId: muscleId,
                intensity: intensity,
                note: note,
                category: category,
                sourceType: sourceType,
                logDate: logDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String muscleId,
                required int intensity,
                Value<String?> note = const Value.absent(),
                Value<String?> category = const Value.absent(),
                required String sourceType,
                Value<DateTime> logDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SymptomLogsTableCompanion.insert(
                id: id,
                muscleId: muscleId,
                intensity: intensity,
                note: note,
                category: category,
                sourceType: sourceType,
                logDate: logDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SymptomLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $SymptomLogsTableTable,
      SymptomLogsTableData,
      $$SymptomLogsTableTableFilterComposer,
      $$SymptomLogsTableTableOrderingComposer,
      $$SymptomLogsTableTableAnnotationComposer,
      $$SymptomLogsTableTableCreateCompanionBuilder,
      $$SymptomLogsTableTableUpdateCompanionBuilder,
      (
        SymptomLogsTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $SymptomLogsTableTable,
          SymptomLogsTableData
        >,
      ),
      SymptomLogsTableData,
      PrefetchHooks Function()
    >;
typedef $$HypothesesTableTableCreateCompanionBuilder =
    HypothesesTableCompanion Function({
      Value<int> id,
      required String targetNode,
      required String linkedNodes,
      required String statement,
      required double certaintyScore,
      required String status,
      Value<String?> sourcesCited,
      Value<String?> scientificRationale,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$HypothesesTableTableUpdateCompanionBuilder =
    HypothesesTableCompanion Function({
      Value<int> id,
      Value<String> targetNode,
      Value<String> linkedNodes,
      Value<String> statement,
      Value<double> certaintyScore,
      Value<String> status,
      Value<String?> sourcesCited,
      Value<String?> scientificRationale,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$HypothesesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $HypothesesTableTable> {
  $$HypothesesTableTableFilterComposer({
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

  ColumnFilters<String> get targetNode => $composableBuilder(
    column: $table.targetNode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedNodes => $composableBuilder(
    column: $table.linkedNodes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcesCited => $composableBuilder(
    column: $table.sourcesCited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scientificRationale => $composableBuilder(
    column: $table.scientificRationale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HypothesesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $HypothesesTableTable> {
  $$HypothesesTableTableOrderingComposer({
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

  ColumnOrderings<String> get targetNode => $composableBuilder(
    column: $table.targetNode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedNodes => $composableBuilder(
    column: $table.linkedNodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcesCited => $composableBuilder(
    column: $table.sourcesCited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scientificRationale => $composableBuilder(
    column: $table.scientificRationale,
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
}

class $$HypothesesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $HypothesesTableTable> {
  $$HypothesesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetNode => $composableBuilder(
    column: $table.targetNode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedNodes => $composableBuilder(
    column: $table.linkedNodes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statement =>
      $composableBuilder(column: $table.statement, builder: (column) => column);

  GeneratedColumn<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get sourcesCited => $composableBuilder(
    column: $table.sourcesCited,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scientificRationale => $composableBuilder(
    column: $table.scientificRationale,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HypothesesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $HypothesesTableTable,
          HypothesesTableData,
          $$HypothesesTableTableFilterComposer,
          $$HypothesesTableTableOrderingComposer,
          $$HypothesesTableTableAnnotationComposer,
          $$HypothesesTableTableCreateCompanionBuilder,
          $$HypothesesTableTableUpdateCompanionBuilder,
          (
            HypothesesTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $HypothesesTableTable,
              HypothesesTableData
            >,
          ),
          HypothesesTableData,
          PrefetchHooks Function()
        > {
  $$HypothesesTableTableTableManager(
    _$MyoTwinDatabase db,
    $HypothesesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HypothesesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HypothesesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HypothesesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetNode = const Value.absent(),
                Value<String> linkedNodes = const Value.absent(),
                Value<String> statement = const Value.absent(),
                Value<double> certaintyScore = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> sourcesCited = const Value.absent(),
                Value<String?> scientificRationale = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => HypothesesTableCompanion(
                id: id,
                targetNode: targetNode,
                linkedNodes: linkedNodes,
                statement: statement,
                certaintyScore: certaintyScore,
                status: status,
                sourcesCited: sourcesCited,
                scientificRationale: scientificRationale,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetNode,
                required String linkedNodes,
                required String statement,
                required double certaintyScore,
                required String status,
                Value<String?> sourcesCited = const Value.absent(),
                Value<String?> scientificRationale = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => HypothesesTableCompanion.insert(
                id: id,
                targetNode: targetNode,
                linkedNodes: linkedNodes,
                statement: statement,
                certaintyScore: certaintyScore,
                status: status,
                sourcesCited: sourcesCited,
                scientificRationale: scientificRationale,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HypothesesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $HypothesesTableTable,
      HypothesesTableData,
      $$HypothesesTableTableFilterComposer,
      $$HypothesesTableTableOrderingComposer,
      $$HypothesesTableTableAnnotationComposer,
      $$HypothesesTableTableCreateCompanionBuilder,
      $$HypothesesTableTableUpdateCompanionBuilder,
      (
        HypothesesTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $HypothesesTableTable,
          HypothesesTableData
        >,
      ),
      HypothesesTableData,
      PrefetchHooks Function()
    >;
typedef $$SourcesTableTableCreateCompanionBuilder =
    SourcesTableCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> authors,
      Value<String?> link,
      Value<String?> keyTakeaway,
      Value<String?> relationshipToHypothesis,
      Value<DateTime> createdAt,
    });
typedef $$SourcesTableTableUpdateCompanionBuilder =
    SourcesTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> authors,
      Value<String?> link,
      Value<String?> keyTakeaway,
      Value<String?> relationshipToHypothesis,
      Value<DateTime> createdAt,
    });

class $$SourcesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $SourcesTableTable> {
  $$SourcesTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyTakeaway => $composableBuilder(
    column: $table.keyTakeaway,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationshipToHypothesis => $composableBuilder(
    column: $table.relationshipToHypothesis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourcesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $SourcesTableTable> {
  $$SourcesTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyTakeaway => $composableBuilder(
    column: $table.keyTakeaway,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationshipToHypothesis => $composableBuilder(
    column: $table.relationshipToHypothesis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourcesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $SourcesTableTable> {
  $$SourcesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get authors =>
      $composableBuilder(column: $table.authors, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get keyTakeaway => $composableBuilder(
    column: $table.keyTakeaway,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relationshipToHypothesis => $composableBuilder(
    column: $table.relationshipToHypothesis,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SourcesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $SourcesTableTable,
          SourcesTableData,
          $$SourcesTableTableFilterComposer,
          $$SourcesTableTableOrderingComposer,
          $$SourcesTableTableAnnotationComposer,
          $$SourcesTableTableCreateCompanionBuilder,
          $$SourcesTableTableUpdateCompanionBuilder,
          (
            SourcesTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $SourcesTableTable,
              SourcesTableData
            >,
          ),
          SourcesTableData,
          PrefetchHooks Function()
        > {
  $$SourcesTableTableTableManager(
    _$MyoTwinDatabase db,
    $SourcesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> authors = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> keyTakeaway = const Value.absent(),
                Value<String?> relationshipToHypothesis = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SourcesTableCompanion(
                id: id,
                title: title,
                authors: authors,
                link: link,
                keyTakeaway: keyTakeaway,
                relationshipToHypothesis: relationshipToHypothesis,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> authors = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> keyTakeaway = const Value.absent(),
                Value<String?> relationshipToHypothesis = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SourcesTableCompanion.insert(
                id: id,
                title: title,
                authors: authors,
                link: link,
                keyTakeaway: keyTakeaway,
                relationshipToHypothesis: relationshipToHypothesis,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourcesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $SourcesTableTable,
      SourcesTableData,
      $$SourcesTableTableFilterComposer,
      $$SourcesTableTableOrderingComposer,
      $$SourcesTableTableAnnotationComposer,
      $$SourcesTableTableCreateCompanionBuilder,
      $$SourcesTableTableUpdateCompanionBuilder,
      (
        SourcesTableData,
        BaseReferences<_$MyoTwinDatabase, $SourcesTableTable, SourcesTableData>,
      ),
      SourcesTableData,
      PrefetchHooks Function()
    >;
typedef $$PrinciplesTableTableCreateCompanionBuilder =
    PrinciplesTableCompanion Function({
      Value<int> id,
      required String name,
      required String statement,
      required String category,
      Value<String?> knowledgeSourceId,
      Value<DateTime> createdAt,
    });
typedef $$PrinciplesTableTableUpdateCompanionBuilder =
    PrinciplesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> statement,
      Value<String> category,
      Value<String?> knowledgeSourceId,
      Value<DateTime> createdAt,
    });

class $$PrinciplesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $PrinciplesTableTable> {
  $$PrinciplesTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get knowledgeSourceId => $composableBuilder(
    column: $table.knowledgeSourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrinciplesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $PrinciplesTableTable> {
  $$PrinciplesTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get knowledgeSourceId => $composableBuilder(
    column: $table.knowledgeSourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrinciplesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $PrinciplesTableTable> {
  $$PrinciplesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get statement =>
      $composableBuilder(column: $table.statement, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get knowledgeSourceId => $composableBuilder(
    column: $table.knowledgeSourceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PrinciplesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $PrinciplesTableTable,
          PrinciplesTableData,
          $$PrinciplesTableTableFilterComposer,
          $$PrinciplesTableTableOrderingComposer,
          $$PrinciplesTableTableAnnotationComposer,
          $$PrinciplesTableTableCreateCompanionBuilder,
          $$PrinciplesTableTableUpdateCompanionBuilder,
          (
            PrinciplesTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $PrinciplesTableTable,
              PrinciplesTableData
            >,
          ),
          PrinciplesTableData,
          PrefetchHooks Function()
        > {
  $$PrinciplesTableTableTableManager(
    _$MyoTwinDatabase db,
    $PrinciplesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrinciplesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrinciplesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrinciplesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> statement = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> knowledgeSourceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PrinciplesTableCompanion(
                id: id,
                name: name,
                statement: statement,
                category: category,
                knowledgeSourceId: knowledgeSourceId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String statement,
                required String category,
                Value<String?> knowledgeSourceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PrinciplesTableCompanion.insert(
                id: id,
                name: name,
                statement: statement,
                category: category,
                knowledgeSourceId: knowledgeSourceId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrinciplesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $PrinciplesTableTable,
      PrinciplesTableData,
      $$PrinciplesTableTableFilterComposer,
      $$PrinciplesTableTableOrderingComposer,
      $$PrinciplesTableTableAnnotationComposer,
      $$PrinciplesTableTableCreateCompanionBuilder,
      $$PrinciplesTableTableUpdateCompanionBuilder,
      (
        PrinciplesTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $PrinciplesTableTable,
          PrinciplesTableData
        >,
      ),
      PrinciplesTableData,
      PrefetchHooks Function()
    >;
typedef $$ResearchNotesTableTableCreateCompanionBuilder =
    ResearchNotesTableCompanion Function({
      Value<int> id,
      required String content,
      required String type,
      Value<String?> relatedHypothesisId,
      Value<double?> certaintyScore,
      Value<DateTime> createdAt,
    });
typedef $$ResearchNotesTableTableUpdateCompanionBuilder =
    ResearchNotesTableCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String> type,
      Value<String?> relatedHypothesisId,
      Value<double?> certaintyScore,
      Value<DateTime> createdAt,
    });

class $$ResearchNotesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $ResearchNotesTableTable> {
  $$ResearchNotesTableTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedHypothesisId => $composableBuilder(
    column: $table.relatedHypothesisId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ResearchNotesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $ResearchNotesTableTable> {
  $$ResearchNotesTableTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedHypothesisId => $composableBuilder(
    column: $table.relatedHypothesisId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ResearchNotesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $ResearchNotesTableTable> {
  $$ResearchNotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get relatedHypothesisId => $composableBuilder(
    column: $table.relatedHypothesisId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ResearchNotesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $ResearchNotesTableTable,
          ResearchNotesTableData,
          $$ResearchNotesTableTableFilterComposer,
          $$ResearchNotesTableTableOrderingComposer,
          $$ResearchNotesTableTableAnnotationComposer,
          $$ResearchNotesTableTableCreateCompanionBuilder,
          $$ResearchNotesTableTableUpdateCompanionBuilder,
          (
            ResearchNotesTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $ResearchNotesTableTable,
              ResearchNotesTableData
            >,
          ),
          ResearchNotesTableData,
          PrefetchHooks Function()
        > {
  $$ResearchNotesTableTableTableManager(
    _$MyoTwinDatabase db,
    $ResearchNotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResearchNotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResearchNotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResearchNotesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> relatedHypothesisId = const Value.absent(),
                Value<double?> certaintyScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ResearchNotesTableCompanion(
                id: id,
                content: content,
                type: type,
                relatedHypothesisId: relatedHypothesisId,
                certaintyScore: certaintyScore,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                required String type,
                Value<String?> relatedHypothesisId = const Value.absent(),
                Value<double?> certaintyScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ResearchNotesTableCompanion.insert(
                id: id,
                content: content,
                type: type,
                relatedHypothesisId: relatedHypothesisId,
                certaintyScore: certaintyScore,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ResearchNotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $ResearchNotesTableTable,
      ResearchNotesTableData,
      $$ResearchNotesTableTableFilterComposer,
      $$ResearchNotesTableTableOrderingComposer,
      $$ResearchNotesTableTableAnnotationComposer,
      $$ResearchNotesTableTableCreateCompanionBuilder,
      $$ResearchNotesTableTableUpdateCompanionBuilder,
      (
        ResearchNotesTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $ResearchNotesTableTable,
          ResearchNotesTableData
        >,
      ),
      ResearchNotesTableData,
      PrefetchHooks Function()
    >;
typedef $$NotificationContextTableTableCreateCompanionBuilder =
    NotificationContextTableCompanion Function({
      Value<int> id,
      required String title,
      required String body,
      required String deepLink,
      required int delayMinutes,
      required String contextUuid,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> scheduledAt,
    });
typedef $$NotificationContextTableTableUpdateCompanionBuilder =
    NotificationContextTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<String> deepLink,
      Value<int> delayMinutes,
      Value<String> contextUuid,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> scheduledAt,
    });

class $$NotificationContextTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $NotificationContextTableTable> {
  $$NotificationContextTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deepLink => $composableBuilder(
    column: $table.deepLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delayMinutes => $composableBuilder(
    column: $table.delayMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextUuid => $composableBuilder(
    column: $table.contextUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationContextTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $NotificationContextTableTable> {
  $$NotificationContextTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deepLink => $composableBuilder(
    column: $table.deepLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delayMinutes => $composableBuilder(
    column: $table.delayMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextUuid => $composableBuilder(
    column: $table.contextUuid,
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

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationContextTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $NotificationContextTableTable> {
  $$NotificationContextTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get deepLink =>
      $composableBuilder(column: $table.deepLink, builder: (column) => column);

  GeneratedColumn<int> get delayMinutes => $composableBuilder(
    column: $table.delayMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextUuid => $composableBuilder(
    column: $table.contextUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );
}

class $$NotificationContextTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $NotificationContextTableTable,
          NotificationContextTableData,
          $$NotificationContextTableTableFilterComposer,
          $$NotificationContextTableTableOrderingComposer,
          $$NotificationContextTableTableAnnotationComposer,
          $$NotificationContextTableTableCreateCompanionBuilder,
          $$NotificationContextTableTableUpdateCompanionBuilder,
          (
            NotificationContextTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $NotificationContextTableTable,
              NotificationContextTableData
            >,
          ),
          NotificationContextTableData,
          PrefetchHooks Function()
        > {
  $$NotificationContextTableTableTableManager(
    _$MyoTwinDatabase db,
    $NotificationContextTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationContextTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationContextTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationContextTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> deepLink = const Value.absent(),
                Value<int> delayMinutes = const Value.absent(),
                Value<String> contextUuid = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
              }) => NotificationContextTableCompanion(
                id: id,
                title: title,
                body: body,
                deepLink: deepLink,
                delayMinutes: delayMinutes,
                contextUuid: contextUuid,
                status: status,
                createdAt: createdAt,
                scheduledAt: scheduledAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String body,
                required String deepLink,
                required int delayMinutes,
                required String contextUuid,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
              }) => NotificationContextTableCompanion.insert(
                id: id,
                title: title,
                body: body,
                deepLink: deepLink,
                delayMinutes: delayMinutes,
                contextUuid: contextUuid,
                status: status,
                createdAt: createdAt,
                scheduledAt: scheduledAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationContextTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $NotificationContextTableTable,
      NotificationContextTableData,
      $$NotificationContextTableTableFilterComposer,
      $$NotificationContextTableTableOrderingComposer,
      $$NotificationContextTableTableAnnotationComposer,
      $$NotificationContextTableTableCreateCompanionBuilder,
      $$NotificationContextTableTableUpdateCompanionBuilder,
      (
        NotificationContextTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $NotificationContextTableTable,
          NotificationContextTableData
        >,
      ),
      NotificationContextTableData,
      PrefetchHooks Function()
    >;
typedef $$KnowledgeSourcesTableTableCreateCompanionBuilder =
    KnowledgeSourcesTableCompanion Function({
      Value<int> id,
      required String contentType,
      required String content,
      Value<String?> title,
      Value<String?> category,
      Value<DateTime> createdAt,
    });
typedef $$KnowledgeSourcesTableTableUpdateCompanionBuilder =
    KnowledgeSourcesTableCompanion Function({
      Value<int> id,
      Value<String> contentType,
      Value<String> content,
      Value<String?> title,
      Value<String?> category,
      Value<DateTime> createdAt,
    });

class $$KnowledgeSourcesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $KnowledgeSourcesTableTable> {
  $$KnowledgeSourcesTableTableFilterComposer({
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

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnowledgeSourcesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $KnowledgeSourcesTableTable> {
  $$KnowledgeSourcesTableTableOrderingComposer({
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

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnowledgeSourcesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $KnowledgeSourcesTableTable> {
  $$KnowledgeSourcesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$KnowledgeSourcesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $KnowledgeSourcesTableTable,
          KnowledgeSourcesTableData,
          $$KnowledgeSourcesTableTableFilterComposer,
          $$KnowledgeSourcesTableTableOrderingComposer,
          $$KnowledgeSourcesTableTableAnnotationComposer,
          $$KnowledgeSourcesTableTableCreateCompanionBuilder,
          $$KnowledgeSourcesTableTableUpdateCompanionBuilder,
          (
            KnowledgeSourcesTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $KnowledgeSourcesTableTable,
              KnowledgeSourcesTableData
            >,
          ),
          KnowledgeSourcesTableData,
          PrefetchHooks Function()
        > {
  $$KnowledgeSourcesTableTableTableManager(
    _$MyoTwinDatabase db,
    $KnowledgeSourcesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeSourcesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$KnowledgeSourcesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$KnowledgeSourcesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KnowledgeSourcesTableCompanion(
                id: id,
                contentType: contentType,
                content: content,
                title: title,
                category: category,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String contentType,
                required String content,
                Value<String?> title = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KnowledgeSourcesTableCompanion.insert(
                id: id,
                contentType: contentType,
                content: content,
                title: title,
                category: category,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnowledgeSourcesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $KnowledgeSourcesTableTable,
      KnowledgeSourcesTableData,
      $$KnowledgeSourcesTableTableFilterComposer,
      $$KnowledgeSourcesTableTableOrderingComposer,
      $$KnowledgeSourcesTableTableAnnotationComposer,
      $$KnowledgeSourcesTableTableCreateCompanionBuilder,
      $$KnowledgeSourcesTableTableUpdateCompanionBuilder,
      (
        KnowledgeSourcesTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $KnowledgeSourcesTableTable,
          KnowledgeSourcesTableData
        >,
      ),
      KnowledgeSourcesTableData,
      PrefetchHooks Function()
    >;
typedef $$NoiseLogsTableTableCreateCompanionBuilder =
    NoiseLogsTableCompanion Function({
      Value<int> id,
      required String type,
      Value<int?> intensity,
      Value<String?> note,
      required String sourceType,
      Value<DateTime> logDate,
      Value<DateTime> createdAt,
    });
typedef $$NoiseLogsTableTableUpdateCompanionBuilder =
    NoiseLogsTableCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<int?> intensity,
      Value<String?> note,
      Value<String> sourceType,
      Value<DateTime> logDate,
      Value<DateTime> createdAt,
    });

class $$NoiseLogsTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $NoiseLogsTableTable> {
  $$NoiseLogsTableTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoiseLogsTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $NoiseLogsTableTable> {
  $$NoiseLogsTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoiseLogsTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $NoiseLogsTableTable> {
  $$NoiseLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NoiseLogsTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $NoiseLogsTableTable,
          NoiseLogsTableData,
          $$NoiseLogsTableTableFilterComposer,
          $$NoiseLogsTableTableOrderingComposer,
          $$NoiseLogsTableTableAnnotationComposer,
          $$NoiseLogsTableTableCreateCompanionBuilder,
          $$NoiseLogsTableTableUpdateCompanionBuilder,
          (
            NoiseLogsTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $NoiseLogsTableTable,
              NoiseLogsTableData
            >,
          ),
          NoiseLogsTableData,
          PrefetchHooks Function()
        > {
  $$NoiseLogsTableTableTableManager(
    _$MyoTwinDatabase db,
    $NoiseLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoiseLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoiseLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoiseLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> intensity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NoiseLogsTableCompanion(
                id: id,
                type: type,
                intensity: intensity,
                note: note,
                sourceType: sourceType,
                logDate: logDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                Value<int?> intensity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String sourceType,
                Value<DateTime> logDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NoiseLogsTableCompanion.insert(
                id: id,
                type: type,
                intensity: intensity,
                note: note,
                sourceType: sourceType,
                logDate: logDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoiseLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $NoiseLogsTableTable,
      NoiseLogsTableData,
      $$NoiseLogsTableTableFilterComposer,
      $$NoiseLogsTableTableOrderingComposer,
      $$NoiseLogsTableTableAnnotationComposer,
      $$NoiseLogsTableTableCreateCompanionBuilder,
      $$NoiseLogsTableTableUpdateCompanionBuilder,
      (
        NoiseLogsTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $NoiseLogsTableTable,
          NoiseLogsTableData
        >,
      ),
      NoiseLogsTableData,
      PrefetchHooks Function()
    >;
typedef $$KineticChainEdgesTableTableCreateCompanionBuilder =
    KineticChainEdgesTableCompanion Function({
      Value<int> id,
      required String sourceNode,
      required String targetNode,
      required double weight,
      required double correlationStrength,
      required double certaintyScore,
      required String edgeType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$KineticChainEdgesTableTableUpdateCompanionBuilder =
    KineticChainEdgesTableCompanion Function({
      Value<int> id,
      Value<String> sourceNode,
      Value<String> targetNode,
      Value<double> weight,
      Value<double> correlationStrength,
      Value<double> certaintyScore,
      Value<String> edgeType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$KineticChainEdgesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $KineticChainEdgesTableTable> {
  $$KineticChainEdgesTableTableFilterComposer({
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

  ColumnFilters<String> get sourceNode => $composableBuilder(
    column: $table.sourceNode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetNode => $composableBuilder(
    column: $table.targetNode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get correlationStrength => $composableBuilder(
    column: $table.correlationStrength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get edgeType => $composableBuilder(
    column: $table.edgeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KineticChainEdgesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $KineticChainEdgesTableTable> {
  $$KineticChainEdgesTableTableOrderingComposer({
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

  ColumnOrderings<String> get sourceNode => $composableBuilder(
    column: $table.sourceNode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetNode => $composableBuilder(
    column: $table.targetNode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get correlationStrength => $composableBuilder(
    column: $table.correlationStrength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get edgeType => $composableBuilder(
    column: $table.edgeType,
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
}

class $$KineticChainEdgesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $KineticChainEdgesTableTable> {
  $$KineticChainEdgesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceNode => $composableBuilder(
    column: $table.sourceNode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetNode => $composableBuilder(
    column: $table.targetNode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get correlationStrength => $composableBuilder(
    column: $table.correlationStrength,
    builder: (column) => column,
  );

  GeneratedColumn<double> get certaintyScore => $composableBuilder(
    column: $table.certaintyScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get edgeType =>
      $composableBuilder(column: $table.edgeType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KineticChainEdgesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $KineticChainEdgesTableTable,
          KineticChainEdgesTableData,
          $$KineticChainEdgesTableTableFilterComposer,
          $$KineticChainEdgesTableTableOrderingComposer,
          $$KineticChainEdgesTableTableAnnotationComposer,
          $$KineticChainEdgesTableTableCreateCompanionBuilder,
          $$KineticChainEdgesTableTableUpdateCompanionBuilder,
          (
            KineticChainEdgesTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $KineticChainEdgesTableTable,
              KineticChainEdgesTableData
            >,
          ),
          KineticChainEdgesTableData,
          PrefetchHooks Function()
        > {
  $$KineticChainEdgesTableTableTableManager(
    _$MyoTwinDatabase db,
    $KineticChainEdgesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KineticChainEdgesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$KineticChainEdgesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$KineticChainEdgesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sourceNode = const Value.absent(),
                Value<String> targetNode = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<double> correlationStrength = const Value.absent(),
                Value<double> certaintyScore = const Value.absent(),
                Value<String> edgeType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KineticChainEdgesTableCompanion(
                id: id,
                sourceNode: sourceNode,
                targetNode: targetNode,
                weight: weight,
                correlationStrength: correlationStrength,
                certaintyScore: certaintyScore,
                edgeType: edgeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sourceNode,
                required String targetNode,
                required double weight,
                required double correlationStrength,
                required double certaintyScore,
                required String edgeType,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KineticChainEdgesTableCompanion.insert(
                id: id,
                sourceNode: sourceNode,
                targetNode: targetNode,
                weight: weight,
                correlationStrength: correlationStrength,
                certaintyScore: certaintyScore,
                edgeType: edgeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KineticChainEdgesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $KineticChainEdgesTableTable,
      KineticChainEdgesTableData,
      $$KineticChainEdgesTableTableFilterComposer,
      $$KineticChainEdgesTableTableOrderingComposer,
      $$KineticChainEdgesTableTableAnnotationComposer,
      $$KineticChainEdgesTableTableCreateCompanionBuilder,
      $$KineticChainEdgesTableTableUpdateCompanionBuilder,
      (
        KineticChainEdgesTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $KineticChainEdgesTableTable,
          KineticChainEdgesTableData
        >,
      ),
      KineticChainEdgesTableData,
      PrefetchHooks Function()
    >;
typedef $$BodySegmentsTableTableCreateCompanionBuilder =
    BodySegmentsTableCompanion Function({
      Value<int> id,
      required String name,
      required String region,
      Value<String?> description,
      Value<double> integrityScore,
      Value<String?> heatIndex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BodySegmentsTableTableUpdateCompanionBuilder =
    BodySegmentsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> region,
      Value<String?> description,
      Value<double> integrityScore,
      Value<String?> heatIndex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$BodySegmentsTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $BodySegmentsTableTable> {
  $$BodySegmentsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get integrityScore => $composableBuilder(
    column: $table.integrityScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heatIndex => $composableBuilder(
    column: $table.heatIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodySegmentsTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $BodySegmentsTableTable> {
  $$BodySegmentsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get integrityScore => $composableBuilder(
    column: $table.integrityScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heatIndex => $composableBuilder(
    column: $table.heatIndex,
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
}

class $$BodySegmentsTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $BodySegmentsTableTable> {
  $$BodySegmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get integrityScore => $composableBuilder(
    column: $table.integrityScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get heatIndex =>
      $composableBuilder(column: $table.heatIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BodySegmentsTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $BodySegmentsTableTable,
          BodySegmentsTableData,
          $$BodySegmentsTableTableFilterComposer,
          $$BodySegmentsTableTableOrderingComposer,
          $$BodySegmentsTableTableAnnotationComposer,
          $$BodySegmentsTableTableCreateCompanionBuilder,
          $$BodySegmentsTableTableUpdateCompanionBuilder,
          (
            BodySegmentsTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $BodySegmentsTableTable,
              BodySegmentsTableData
            >,
          ),
          BodySegmentsTableData,
          PrefetchHooks Function()
        > {
  $$BodySegmentsTableTableTableManager(
    _$MyoTwinDatabase db,
    $BodySegmentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodySegmentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodySegmentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodySegmentsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> integrityScore = const Value.absent(),
                Value<String?> heatIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BodySegmentsTableCompanion(
                id: id,
                name: name,
                region: region,
                description: description,
                integrityScore: integrityScore,
                heatIndex: heatIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String region,
                Value<String?> description = const Value.absent(),
                Value<double> integrityScore = const Value.absent(),
                Value<String?> heatIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BodySegmentsTableCompanion.insert(
                id: id,
                name: name,
                region: region,
                description: description,
                integrityScore: integrityScore,
                heatIndex: heatIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodySegmentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $BodySegmentsTableTable,
      BodySegmentsTableData,
      $$BodySegmentsTableTableFilterComposer,
      $$BodySegmentsTableTableOrderingComposer,
      $$BodySegmentsTableTableAnnotationComposer,
      $$BodySegmentsTableTableCreateCompanionBuilder,
      $$BodySegmentsTableTableUpdateCompanionBuilder,
      (
        BodySegmentsTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $BodySegmentsTableTable,
          BodySegmentsTableData
        >,
      ),
      BodySegmentsTableData,
      PrefetchHooks Function()
    >;
typedef $$DriveSettingsTableTableCreateCompanionBuilder =
    DriveSettingsTableCompanion Function({
      Value<int> id,
      required String settingName,
      required double value,
      required String scope,
      Value<String?> nodeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DriveSettingsTableTableUpdateCompanionBuilder =
    DriveSettingsTableCompanion Function({
      Value<int> id,
      Value<String> settingName,
      Value<double> value,
      Value<String> scope,
      Value<String?> nodeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DriveSettingsTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $DriveSettingsTableTable> {
  $$DriveSettingsTableTableFilterComposer({
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

  ColumnFilters<String> get settingName => $composableBuilder(
    column: $table.settingName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriveSettingsTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $DriveSettingsTableTable> {
  $$DriveSettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get settingName => $composableBuilder(
    column: $table.settingName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
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
}

class $$DriveSettingsTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $DriveSettingsTableTable> {
  $$DriveSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get settingName => $composableBuilder(
    column: $table.settingName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DriveSettingsTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $DriveSettingsTableTable,
          DriveSettingsTableData,
          $$DriveSettingsTableTableFilterComposer,
          $$DriveSettingsTableTableOrderingComposer,
          $$DriveSettingsTableTableAnnotationComposer,
          $$DriveSettingsTableTableCreateCompanionBuilder,
          $$DriveSettingsTableTableUpdateCompanionBuilder,
          (
            DriveSettingsTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $DriveSettingsTableTable,
              DriveSettingsTableData
            >,
          ),
          DriveSettingsTableData,
          PrefetchHooks Function()
        > {
  $$DriveSettingsTableTableTableManager(
    _$MyoTwinDatabase db,
    $DriveSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriveSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriveSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriveSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> settingName = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String?> nodeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DriveSettingsTableCompanion(
                id: id,
                settingName: settingName,
                value: value,
                scope: scope,
                nodeId: nodeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String settingName,
                required double value,
                required String scope,
                Value<String?> nodeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DriveSettingsTableCompanion.insert(
                id: id,
                settingName: settingName,
                value: value,
                scope: scope,
                nodeId: nodeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriveSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $DriveSettingsTableTable,
      DriveSettingsTableData,
      $$DriveSettingsTableTableFilterComposer,
      $$DriveSettingsTableTableOrderingComposer,
      $$DriveSettingsTableTableAnnotationComposer,
      $$DriveSettingsTableTableCreateCompanionBuilder,
      $$DriveSettingsTableTableUpdateCompanionBuilder,
      (
        DriveSettingsTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $DriveSettingsTableTable,
          DriveSettingsTableData
        >,
      ),
      DriveSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$DeviceSyncStateTableTableCreateCompanionBuilder =
    DeviceSyncStateTableCompanion Function({
      Value<int> id,
      required String deviceId,
      required DateTime lastSyncTimestamp,
      required String direction,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DeviceSyncStateTableTableUpdateCompanionBuilder =
    DeviceSyncStateTableCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<DateTime> lastSyncTimestamp,
      Value<String> direction,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DeviceSyncStateTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $DeviceSyncStateTableTable> {
  $$DeviceSyncStateTableTableFilterComposer({
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

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncTimestamp => $composableBuilder(
    column: $table.lastSyncTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceSyncStateTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $DeviceSyncStateTableTable> {
  $$DeviceSyncStateTableTableOrderingComposer({
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

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncTimestamp => $composableBuilder(
    column: $table.lastSyncTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
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
}

class $$DeviceSyncStateTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $DeviceSyncStateTableTable> {
  $$DeviceSyncStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncTimestamp => $composableBuilder(
    column: $table.lastSyncTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DeviceSyncStateTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $DeviceSyncStateTableTable,
          DeviceSyncStateTableData,
          $$DeviceSyncStateTableTableFilterComposer,
          $$DeviceSyncStateTableTableOrderingComposer,
          $$DeviceSyncStateTableTableAnnotationComposer,
          $$DeviceSyncStateTableTableCreateCompanionBuilder,
          $$DeviceSyncStateTableTableUpdateCompanionBuilder,
          (
            DeviceSyncStateTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $DeviceSyncStateTableTable,
              DeviceSyncStateTableData
            >,
          ),
          DeviceSyncStateTableData,
          PrefetchHooks Function()
        > {
  $$DeviceSyncStateTableTableTableManager(
    _$MyoTwinDatabase db,
    $DeviceSyncStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceSyncStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceSyncStateTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DeviceSyncStateTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> lastSyncTimestamp = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DeviceSyncStateTableCompanion(
                id: id,
                deviceId: deviceId,
                lastSyncTimestamp: lastSyncTimestamp,
                direction: direction,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required DateTime lastSyncTimestamp,
                required String direction,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DeviceSyncStateTableCompanion.insert(
                id: id,
                deviceId: deviceId,
                lastSyncTimestamp: lastSyncTimestamp,
                direction: direction,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceSyncStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $DeviceSyncStateTableTable,
      DeviceSyncStateTableData,
      $$DeviceSyncStateTableTableFilterComposer,
      $$DeviceSyncStateTableTableOrderingComposer,
      $$DeviceSyncStateTableTableAnnotationComposer,
      $$DeviceSyncStateTableTableCreateCompanionBuilder,
      $$DeviceSyncStateTableTableUpdateCompanionBuilder,
      (
        DeviceSyncStateTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $DeviceSyncStateTableTable,
          DeviceSyncStateTableData
        >,
      ),
      DeviceSyncStateTableData,
      PrefetchHooks Function()
    >;
typedef $$InjuriesTableTableCreateCompanionBuilder =
    InjuriesTableCompanion Function({
      Value<int> id,
      required String bodyRegion,
      required String type,
      Value<double> integrityScore,
      Value<String?> functionalOffsets,
      Value<String?> narrative,
      required String status,
      required DateTime date,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$InjuriesTableTableUpdateCompanionBuilder =
    InjuriesTableCompanion Function({
      Value<int> id,
      Value<String> bodyRegion,
      Value<String> type,
      Value<double> integrityScore,
      Value<String?> functionalOffsets,
      Value<String?> narrative,
      Value<String> status,
      Value<DateTime> date,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$InjuriesTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $InjuriesTableTable> {
  $$InjuriesTableTableFilterComposer({
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

  ColumnFilters<String> get bodyRegion => $composableBuilder(
    column: $table.bodyRegion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get integrityScore => $composableBuilder(
    column: $table.integrityScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get functionalOffsets => $composableBuilder(
    column: $table.functionalOffsets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get narrative => $composableBuilder(
    column: $table.narrative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InjuriesTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $InjuriesTableTable> {
  $$InjuriesTableTableOrderingComposer({
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

  ColumnOrderings<String> get bodyRegion => $composableBuilder(
    column: $table.bodyRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get integrityScore => $composableBuilder(
    column: $table.integrityScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get functionalOffsets => $composableBuilder(
    column: $table.functionalOffsets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get narrative => $composableBuilder(
    column: $table.narrative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
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
}

class $$InjuriesTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $InjuriesTableTable> {
  $$InjuriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bodyRegion => $composableBuilder(
    column: $table.bodyRegion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get integrityScore => $composableBuilder(
    column: $table.integrityScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get functionalOffsets => $composableBuilder(
    column: $table.functionalOffsets,
    builder: (column) => column,
  );

  GeneratedColumn<String> get narrative =>
      $composableBuilder(column: $table.narrative, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InjuriesTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $InjuriesTableTable,
          InjuriesTableData,
          $$InjuriesTableTableFilterComposer,
          $$InjuriesTableTableOrderingComposer,
          $$InjuriesTableTableAnnotationComposer,
          $$InjuriesTableTableCreateCompanionBuilder,
          $$InjuriesTableTableUpdateCompanionBuilder,
          (
            InjuriesTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $InjuriesTableTable,
              InjuriesTableData
            >,
          ),
          InjuriesTableData,
          PrefetchHooks Function()
        > {
  $$InjuriesTableTableTableManager(
    _$MyoTwinDatabase db,
    $InjuriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InjuriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InjuriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InjuriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> bodyRegion = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> integrityScore = const Value.absent(),
                Value<String?> functionalOffsets = const Value.absent(),
                Value<String?> narrative = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InjuriesTableCompanion(
                id: id,
                bodyRegion: bodyRegion,
                type: type,
                integrityScore: integrityScore,
                functionalOffsets: functionalOffsets,
                narrative: narrative,
                status: status,
                date: date,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String bodyRegion,
                required String type,
                Value<double> integrityScore = const Value.absent(),
                Value<String?> functionalOffsets = const Value.absent(),
                Value<String?> narrative = const Value.absent(),
                required String status,
                required DateTime date,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InjuriesTableCompanion.insert(
                id: id,
                bodyRegion: bodyRegion,
                type: type,
                integrityScore: integrityScore,
                functionalOffsets: functionalOffsets,
                narrative: narrative,
                status: status,
                date: date,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InjuriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $InjuriesTableTable,
      InjuriesTableData,
      $$InjuriesTableTableFilterComposer,
      $$InjuriesTableTableOrderingComposer,
      $$InjuriesTableTableAnnotationComposer,
      $$InjuriesTableTableCreateCompanionBuilder,
      $$InjuriesTableTableUpdateCompanionBuilder,
      (
        InjuriesTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $InjuriesTableTable,
          InjuriesTableData
        >,
      ),
      InjuriesTableData,
      PrefetchHooks Function()
    >;
typedef $$EquipmentTableTableCreateCompanionBuilder =
    EquipmentTableCompanion Function({
      Value<int> id,
      required String name,
      required String modality,
      Value<String?> anchorPoint,
      Value<bool> active,
      Value<String?> currentConfiguration,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$EquipmentTableTableUpdateCompanionBuilder =
    EquipmentTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> modality,
      Value<String?> anchorPoint,
      Value<bool> active,
      Value<String?> currentConfiguration,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$EquipmentTableTableFilterComposer
    extends Composer<_$MyoTwinDatabase, $EquipmentTableTable> {
  $$EquipmentTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorPoint => $composableBuilder(
    column: $table.anchorPoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentConfiguration => $composableBuilder(
    column: $table.currentConfiguration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentTableTableOrderingComposer
    extends Composer<_$MyoTwinDatabase, $EquipmentTableTable> {
  $$EquipmentTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorPoint => $composableBuilder(
    column: $table.anchorPoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentConfiguration => $composableBuilder(
    column: $table.currentConfiguration,
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
}

class $$EquipmentTableTableAnnotationComposer
    extends Composer<_$MyoTwinDatabase, $EquipmentTableTable> {
  $$EquipmentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get modality =>
      $composableBuilder(column: $table.modality, builder: (column) => column);

  GeneratedColumn<String> get anchorPoint => $composableBuilder(
    column: $table.anchorPoint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get currentConfiguration => $composableBuilder(
    column: $table.currentConfiguration,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EquipmentTableTableTableManager
    extends
        RootTableManager<
          _$MyoTwinDatabase,
          $EquipmentTableTable,
          EquipmentTableData,
          $$EquipmentTableTableFilterComposer,
          $$EquipmentTableTableOrderingComposer,
          $$EquipmentTableTableAnnotationComposer,
          $$EquipmentTableTableCreateCompanionBuilder,
          $$EquipmentTableTableUpdateCompanionBuilder,
          (
            EquipmentTableData,
            BaseReferences<
              _$MyoTwinDatabase,
              $EquipmentTableTable,
              EquipmentTableData
            >,
          ),
          EquipmentTableData,
          PrefetchHooks Function()
        > {
  $$EquipmentTableTableTableManager(
    _$MyoTwinDatabase db,
    $EquipmentTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> modality = const Value.absent(),
                Value<String?> anchorPoint = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> currentConfiguration = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EquipmentTableCompanion(
                id: id,
                name: name,
                modality: modality,
                anchorPoint: anchorPoint,
                active: active,
                currentConfiguration: currentConfiguration,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String modality,
                Value<String?> anchorPoint = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> currentConfiguration = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EquipmentTableCompanion.insert(
                id: id,
                name: name,
                modality: modality,
                anchorPoint: anchorPoint,
                active: active,
                currentConfiguration: currentConfiguration,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyoTwinDatabase,
      $EquipmentTableTable,
      EquipmentTableData,
      $$EquipmentTableTableFilterComposer,
      $$EquipmentTableTableOrderingComposer,
      $$EquipmentTableTableAnnotationComposer,
      $$EquipmentTableTableCreateCompanionBuilder,
      $$EquipmentTableTableUpdateCompanionBuilder,
      (
        EquipmentTableData,
        BaseReferences<
          _$MyoTwinDatabase,
          $EquipmentTableTable,
          EquipmentTableData
        >,
      ),
      EquipmentTableData,
      PrefetchHooks Function()
    >;

class $MyoTwinDatabaseManager {
  final _$MyoTwinDatabase _db;
  $MyoTwinDatabaseManager(this._db);
  $$ExercisesTableTableTableManager get exercisesTable =>
      $$ExercisesTableTableTableManager(_db, _db.exercisesTable);
  $$WorkoutLogsTableTableTableManager get workoutLogsTable =>
      $$WorkoutLogsTableTableTableManager(_db, _db.workoutLogsTable);
  $$SymptomLogsTableTableTableManager get symptomLogsTable =>
      $$SymptomLogsTableTableTableManager(_db, _db.symptomLogsTable);
  $$HypothesesTableTableTableManager get hypothesesTable =>
      $$HypothesesTableTableTableManager(_db, _db.hypothesesTable);
  $$SourcesTableTableTableManager get sourcesTable =>
      $$SourcesTableTableTableManager(_db, _db.sourcesTable);
  $$PrinciplesTableTableTableManager get principlesTable =>
      $$PrinciplesTableTableTableManager(_db, _db.principlesTable);
  $$ResearchNotesTableTableTableManager get researchNotesTable =>
      $$ResearchNotesTableTableTableManager(_db, _db.researchNotesTable);
  $$NotificationContextTableTableTableManager get notificationContextTable =>
      $$NotificationContextTableTableTableManager(
        _db,
        _db.notificationContextTable,
      );
  $$KnowledgeSourcesTableTableTableManager get knowledgeSourcesTable =>
      $$KnowledgeSourcesTableTableTableManager(_db, _db.knowledgeSourcesTable);
  $$NoiseLogsTableTableTableManager get noiseLogsTable =>
      $$NoiseLogsTableTableTableManager(_db, _db.noiseLogsTable);
  $$KineticChainEdgesTableTableTableManager get kineticChainEdgesTable =>
      $$KineticChainEdgesTableTableTableManager(
        _db,
        _db.kineticChainEdgesTable,
      );
  $$BodySegmentsTableTableTableManager get bodySegmentsTable =>
      $$BodySegmentsTableTableTableManager(_db, _db.bodySegmentsTable);
  $$DriveSettingsTableTableTableManager get driveSettingsTable =>
      $$DriveSettingsTableTableTableManager(_db, _db.driveSettingsTable);
  $$DeviceSyncStateTableTableTableManager get deviceSyncStateTable =>
      $$DeviceSyncStateTableTableTableManager(_db, _db.deviceSyncStateTable);
  $$InjuriesTableTableTableManager get injuriesTable =>
      $$InjuriesTableTableTableManager(_db, _db.injuriesTable);
  $$EquipmentTableTableTableManager get equipmentTable =>
      $$EquipmentTableTableTableManager(_db, _db.equipmentTable);
}
