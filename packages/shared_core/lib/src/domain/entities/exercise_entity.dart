/// Exercise definition in the MyoTwin research and coaching loop.
///
/// Captures biomechanical properties (target muscles, equipment, ring
/// height) and the scientific rationale behind the exercise design.
class ExerciseEntity {
  /// Creates an exercise definition record.
  const ExerciseEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Display name of the exercise.
    required this.name,

    /// Optional free-text description.
    this.description,

    /// Category label (e.g. "mobility", "strengthening").
    required this.category,

    /// Comma-separated list of target muscles.
    required this.targetMuscles,

    /// Equipment needed to perform this exercise.
    this.requiredEquipment,

    /// Optimal ring height in metres for the exercise setup.
    this.ringHeight,

    /// Duration of one set in seconds.
    this.durationSecs,

    /// Evidence or theory motivating this exercise choice.
    this.scientificRationale,

    /// Notes about equipment modifications or substitutions.
    this.equipmentNotes,

    /// Timestamp when the exercise was first logged.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [ExerciseEntity] from a database row map.
  factory ExerciseEntity.fromDb(Map<String, dynamic> row) {
    return ExerciseEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      description: row['description'] as String?,
      category: row['category'] as String,
      targetMuscles: row['targetMuscles'] as String,
      requiredEquipment: row['requiredEquipment'] as String?,
      ringHeight: (row['ringHeight'] as num?)?.toDouble(),
      durationSecs: row['durationSecs'] as int?,
      scientificRationale: row['scientificRationale'] as String?,
      equipmentNotes: row['equipmentNotes'] as String?,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Display name of the exercise (e.g. "Scapular Retraction").
  final String name;

  /// Free-text description of the exercise.
  final String? description;

  /// Category label (e.g. "mobility", "strengthening").
  final String category;

  /// Comma-separated list of targeted muscle groups.
  final String targetMuscles;

  /// Equipment needed to perform this exercise.
  final String? requiredEquipment;

  /// Optimal ring height in metres for setup.
  final double? ringHeight;

  /// Duration of one set in seconds.
  final int? durationSecs;

  /// Evidence or theory motivating this exercise choice.
  final String? scientificRationale;

  /// Notes about equipment modifications or substitutions.
  final String? equipmentNotes;

  /// Timestamp when the exercise was first logged.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'targetMuscles': targetMuscles,
      'requiredEquipment': requiredEquipment,
      'ringHeight': ringHeight,
      'durationSecs': durationSecs,
      'scientificRationale': scientificRationale,
      'equipmentNotes': equipmentNotes,
    };
  }
}
