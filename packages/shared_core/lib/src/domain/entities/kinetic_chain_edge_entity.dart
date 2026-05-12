/// Domain entity: Kinetic chain edge between two body segment nodes.
class KineticChainEdgeEntity {
  const KineticChainEdgeEntity({
    this.id,
    required this.sourceNode,
    required this.targetNode,
    required this.weight,
    required this.correlationStrength,
    required this.certaintyScore,
    required this.edgeType,
    required this.createdAt,
    required this.updatedAt,
  });

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
  final int? id;
  final String sourceNode;
  final String targetNode;
  final double weight;
  final double correlationStrength;
  final double certaintyScore;
  final String edgeType;
  final DateTime createdAt;
  final DateTime updatedAt;

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
