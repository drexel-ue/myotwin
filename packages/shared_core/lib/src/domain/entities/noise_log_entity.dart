/// Environmental, mental, or stress noise logged for context.
///
/// Captures confounding factors that may affect injury recovery
/// or exercise data on this local-first privacy-preserving stack.
class NoiseLogEntity {
  /// Creates a noise log entry record.
  const NoiseLogEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Noise category (e.g. "stress", "environment", "fatigue").
    required this.type,

    /// Subjective intensity rating of the noise event.
    this.intensity,

    /// Optional free-text note about the noise event.
    this.note,

    /// Source type of the noise data point.
    required this.sourceType,

    /// When the noise event occurred.
    required this.loggedAt,

    /// Timestamp when inserted into the database.
    required this.createdAt,
  });

  /// Constructs a [NoiseLogEntity] from a database row map.
  factory NoiseLogEntity.fromDb(Map<String, dynamic> row) {
    return NoiseLogEntity(
      id: row['id'] as int,
      type: row['type'] as String,
      intensity: row['intensity'] as int?,
      note: row['note'] as String?,
      sourceType: row['sourceType'] as String,
      loggedAt: row['logDate'] as DateTime,
      createdAt: row['createdAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Noise category (e.g. "stress", "environment", "fatigue").
  final String type;

  /// Subjective intensity rating of the noise event.
  final int? intensity;

  /// Free-text note about the noise event.
  final String? note;

  /// Source type of the noise data point.
  final String sourceType;

  /// When the noise event occurred.
  final DateTime loggedAt;

  /// Timestamp when inserted into the database.
  final DateTime createdAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'intensity': intensity,
      'note': note,
      'sourceType': sourceType,
      'logDate': loggedAt,
    };
  }
}
