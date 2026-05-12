/// Domain entity: Symptom event recorded from user input.
/// Represents a single symptom observation event with intensity and category.
class SymptomEvent {
  const SymptomEvent({
    this.id,
    required this.muscleId,
    required this.intensity,
    this.note,
    this.category,
    required this.sourceType,
    required this.loggedAt,
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

  /// Unique ID of the symptom event.
  final int? id;

  /// Body segment ID (e.g. "Trapezius_L").
  final String muscleId;

  /// Pain/stiffness intensity (1-10).
  final int intensity;

  /// Optional natural language description.
  final String? note;

  /// Symptom category: Stiffness, Sharp Pain, Dull Ache, Weakness.
  final String? category;

  /// Source of the data point.
  final String sourceType;

  /// When the symptom was logged.
  final DateTime loggedAt;

  /// When inserted into database.
  final DateTime createdAt;

  /// Exports entity to map for database insertion.
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
