/// Directed edge between two nodes in the kinetic chain graph.
///
/// Represents a biomechanical relationship (e.g. compensatory link)
/// between body segments with configurable weight and evidence.
class KineticChainEdgeEntity {
  /// Creates a kinetic chain edge record.
  const KineticChainEdgeEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Source body segment node ID of the relationship.
    required this.sourceNode,

    /// Target body segment node ID of the relationship.
    required this.targetNode,

    /// Relative weight of this edge in the kinetic model.
    required this.weight,

    /// Statistical correlation strength between nodes.
    required this.correlationStrength,

    /// Confidence in this relationship (0.0 to 1.0).
    required this.certaintyScore,

    /// Relationship type (e.g. "compensatory", "synergistic").
    required this.edgeType,

    /// Timestamp when the edge was first created.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [KineticChainEdgeEntity] from a database row map.
  factory KineticChainEdgeEntity.fromDb(Map<String, dynamic> row) {
    return KineticChainEdgeEntity(
      id: row['id'] as int,
      sourceNode: row['sourceNode'] as String,
      targetNode: row['targetNode'] as String,
      weight: (row['weight'] as num).toDouble(),
      correlationStrength: (row['correlationStrength'] as num).toDouble(),
      certaintyScore: (row['certaintyScore'] as num).toDouble(),
      edgeType: row['edgeType'] as String,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Source body segment node ID of the relationship.
  final String sourceNode;

  /// Target body segment node ID of the relationship.
  final String targetNode;

  /// Relative weight of this edge in the kinetic model.
  final double weight;

  /// Statistical correlation strength between nodes.
  final double correlationStrength;

  /// Confidence in this relationship (0.0 to 1.0).
  final double certaintyScore;

  /// Relationship type (e.g. "compensatory", "synergistic").
  final String edgeType;

  /// Timestamp when the edge was first created.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'sourceNode': sourceNode,
      'targetNode': targetNode,
      'weight': weight,
      'correlationStrength': correlationStrength,
      'certaintyScore': certaintyScore,
      'edgeType': edgeType,
    };
  }
}
