/// Symptom event recorded from user input for MyoTwin tracking.
///
/// Represents a single symptom observation with intensity and
/// category tied to a body segment for the pain monitoring loop.
class SymptomEvent {
  /// Creates a symptom observation event.
  const SymptomEvent({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Body segment ID the symptom is in (e.g. "Trapezius_L").
    required this.muscleId,

    /// Pain/stiffness intensity on a 1-10 scale.
    required this.intensity,

    /// Optional free-text description of the symptom.
    this.note,

    /// Symptom category: Stiffness, Sharp Pain, Dull Ache, Weakness.
    this.category,

    /// Source of the data point.
    required this.sourceType,

    /// When the symptom was logged by the user.
    required this.loggedAt,

    /// When inserted into the database.
    required this.createdAt,
  });

  /// Converts database row map to [SymptomEvent].
  factory SymptomEvent.fromDb(Map<String, dynamic> row) {
    return SymptomEvent(
      id: row['id'] as int,
      muscleId: row['muscleId'] as String,
      intensity: row['intensity'] as int,
      note: row['note'] as String?,
      category: row['category'] as String?,
      sourceType: row['sourceType'] as String,
      loggedAt: row['logDate'] as DateTime,
      createdAt: row['createdAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Body segment ID the symptom is in (e.g. "Trapezius_L").
  final String muscleId;

  /// Pain/stiffness intensity on a 1-10 scale.
  final int intensity;

  /// Free-text description of the symptom.
  final String? note;

  /// Symptom category: Stiffness, Sharp Pain, Dull Ache, Weakness.
  final String? category;

  /// Source of the data point.
  final String sourceType;

  /// When the symptom was logged by the user.
  final DateTime loggedAt;

  /// When inserted into the database.
  final DateTime createdAt;

  /// Exports entity to map for database insertion.
  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'muscleId': muscleId,
      'intensity': intensity,
      'note': note,
      'category': category,
      'sourceType': sourceType,
      'logDate': loggedAt,
    };
  }

  /// Creates a copy of this entity with the given fields replaced.
  SymptomEvent copyWith({
    int? id,
    String? muscleId,
    int? intensity,
    String? note,
    String? category,
    String? sourceType,
    DateTime? loggedAt,
    DateTime? createdAt,
  }) {
    return SymptomEvent(
      id: id ?? this.id,
      muscleId: muscleId ?? this.muscleId,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      category: category ?? this.category,
      sourceType: sourceType ?? this.sourceType,
      loggedAt: loggedAt ?? this.loggedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
