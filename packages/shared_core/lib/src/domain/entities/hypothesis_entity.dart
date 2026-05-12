/// Hypothesis in the scientific method loop for recovery and rehab.
///
/// Wraps exercise recommendations with a certainty score so the
/// local-only research process remains auditable and traceable.
class HypothesisEntity {
  /// Creates a hypothesis for the scientific method loop.
  const HypothesisEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Target body segment node ID.
    required this.targetNode,

    /// Linked body segment node IDs in the kinetic chain.
    required this.linkedNodes,

    /// The hypothesis statement (e.g. "Strengthening X improves Y").
    required this.statement,

    /// Certainty score between 0.0 and 1.0.
    required this.certaintyScore,

    /// Current status: Active, Proven, Disproved, etc.
    required this.status,

    /// Cited source IDs, comma-separated in the database.
    this.sourcesCited,

    /// Evidence or theory motivating this hypothesis.
    this.scientificRationale,

    /// Timestamp when the hypothesis was first logged.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [HypothesisEntity] from a database row map.
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

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Target body segment node ID.
  final String targetNode;

  /// Linked body segment node IDs in the kinetic chain.
  final List<String> linkedNodes;

  /// The hypothesis statement (e.g. "Strengthening X improves Y").
  final String statement;

  /// Certainty score between 0.0 and 1.0.
  final double certaintyScore;

  /// Status of the hypothesis: Active, Proven, Disproved, etc.
  final String status;

  /// Cited source IDs (null when none cited).
  final List<String>? sourcesCited;

  /// Evidence or theory motivating this hypothesis.
  final String? scientificRationale;

  /// Timestamp when the hypothesis was first logged.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
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

  /// Creates a copy of this entity with the given fields replaced.
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
