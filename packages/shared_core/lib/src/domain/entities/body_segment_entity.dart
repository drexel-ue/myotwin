/// Body segment node in the biomechanical kinetic graph.
///
/// Represents an anatomical region with integrity metrics and
/// heat-based prioritization for the local research loop.
class BodySegmentEntity {
  /// Creates a body segment node in the kinetic chain graph.
  const BodySegmentEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Display name of the body segment.
    required this.name,

    /// Anatomical region label (e.g. "upper-body").
    required this.region,

    /// Optional free-text description.
    this.description,

    /// Tissue integrity score. 1.0 is healthy, lower means degraded.
    this.integrityScore = 1.0,

    /// Optional heat-index tag for prioritization of attention.
    this.heatIndex,

    /// Timestamp when this segment was first recorded.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [BodySegmentEntity] from a database row map.
  factory BodySegmentEntity.fromDb(Map<String, dynamic> row) {
    return BodySegmentEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      region: row['region'] as String,
      description: row['description'] as String?,
      integrityScore: (row['integrityScore'] as num).toDouble(),
      heatIndex: row['heatIndex'] as String?,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Display name of the body segment (e.g. "Left Trapezius").
  final String name;

  /// Anatomical region label (e.g. "upper-body").
  final String region;

  /// Free-text description of the segment.
  final String? description;

  /// Tissue integrity score. 1.0 is healthy, lower values mean degraded.
  final double integrityScore;

  /// Heat-index tag for attention prioritization.
  final String? heatIndex;

  /// Timestamp when this segment was first recorded.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'region': region,
      'description': description,
      'integrityScore': integrityScore,
      'heatIndex': heatIndex,
    };
  }
}
