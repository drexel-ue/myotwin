/// Domain entity: Hypothesis in the scientific method loop.
/// Every exercise recommendation is wrapped in a Hypothesis with a certainty score.
class HypothesisEntity {
  const HypothesisEntity({
    this.id,
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

  factory HypothesisEntity.fromDb(Map<String, dynamic> row) {
    return HypothesisEntity(
      id: row['id'] as int,
      targetNode: row['targetNode'] as String,
      linkedNodes: (row['linkedNodes'] as String).split(',').where((e) => e.isNotEmpty).toList(),
      statement: row['statement'] as String,
      certaintyScore: (row['certaintyScore'] as num).toDouble(),
      status: row['status'] as String,
      sourcesCited: row['sourcesCited'] != null
          ? (row['sourcesCited'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : null,
      scientificRationale: row['scientificRationale'] as String?,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }
  final int? id;
  final String targetNode;
  final List<String> linkedNodes;
  final String statement;
  final double certaintyScore;
  final String status;
  final List<String>? sourcesCited;
  final String? scientificRationale;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'targetNode': targetNode,
      'linkedNodes': linkedNodes.join(','),
      'statement': statement,
      'certaintyScore': certaintyScore,
      'status': status,
      'sourcesCited': sourcesCited?.join(','),
      'scientificRationale': scientificRationale,
    };
  }

  HypothesisEntity copyWith({
    int? id,
    String? targetNode,
    List<String>? linkedNodes,
    String? statement,
    double? certaintyScore,
    String? status,
    List<String>? sourcesCited,
    String? scientificRationale,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HypothesisEntity(
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
}
