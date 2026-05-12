/// Domain entity: Workout log entry for completed sets/workouts.
class WorkoutLogEntity {
  const WorkoutLogEntity({
    this.id,
    required this.exerciseId,
    required this.volume,
    this.durationSecs,
    this.notes,
    this.intensity,
    required this.sourceType,
    required this.logDate,
    required this.createdAt,
  });

  factory WorkoutLogEntity.fromDb(Map<String, dynamic> row) {
    return WorkoutLogEntity(
      id: row['id'] as int,
      exerciseId: row['exerciseId'] as int,
      volume: row['volume'] as int,
      durationSecs: row['durationSecs'] as int?,
      notes: row['notes'] as String?,
      intensity: (row['intensity'] as num?)?.toDouble(),
      sourceType: row['sourceType'] as String,
      logDate: row['logDate'] as DateTime,
      createdAt: row['createdAt'] as DateTime,
    );
  }
  final int? id;
  final int exerciseId;
  final int volume;
  final int? durationSecs;
  final String? notes;
  final double? intensity;
  final String sourceType;
  final DateTime logDate;
  final DateTime createdAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'exerciseId': exerciseId,
      'volume': volume,
      'durationSecs': durationSecs,
      'notes': notes,
      'intensity': intensity,
      'sourceType': sourceType,
      'logDate': logDate,
    };
  }
}
