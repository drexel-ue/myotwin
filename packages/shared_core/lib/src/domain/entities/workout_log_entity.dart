/// Workout log entry for completed sets or full workouts in MyoTwin.
///
/// Records training volume, intensity, and notes tied to an exercise
/// for longitudinal biomechanical research on-this-device.
class WorkoutLogEntity {
  /// Creates a workout log entry.
  const WorkoutLogEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// ExerciseEntity ID this log entry refers to.
    required this.exerciseId,

    /// Total training volume (e.g. sets x reps x weight).
    required this.volume,

    /// Duration of the set or workout in seconds.
    this.durationSecs,

    /// Optional user notes about the workout.
    this.notes,

    /// Subjective exercise intensity rating.
    this.intensity,

    /// Source of the workout data point.
    required this.sourceType,

    /// Date the workout was performed.
    required this.logDate,

    /// Timestamp when inserted into the database.
    required this.createdAt,
  });

  /// Constructs a [WorkoutLogEntity] from a database row map.
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

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// ExerciseEntity ID this log entry refers to.
  final int exerciseId;

  /// Total training volume (e.g. sets x reps x weight).
  final int volume;

  /// Duration of the set or workout in seconds.
  final int? durationSecs;

  /// Free-text notes about the workout.
  final String? notes;

  /// Subjective exercise intensity rating.
  final double? intensity;

  /// Source of the workout data point.
  final String sourceType;

  /// Date the workout was performed.
  final DateTime logDate;

  /// Timestamp when inserted into the database.
  final DateTime createdAt;

  /// Exports the entity to a database row map for persistence.
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
