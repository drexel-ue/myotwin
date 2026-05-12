/// Research note from background auditor findings in MyoTwin.
///
/// Records observations from the local-only research process,
/// optionally linked to a hypothesis for full audit trail support.
class ResearchNoteEntity {
  /// Creates a research note from the background auditor.
  const ResearchNoteEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Free-text content of the research finding.
    required this.content,

    /// Note type category (e.g. "observation", "anomaly").
    required this.type,

    /// Related HypothesisEntity ID if applicable.
    this.relatedHypothesisId,

    /// Certainty score of this finding (0.0 to 1.0).
    this.certaintyScore,

    /// Timestamp when inserted into the database.
    required this.createdAt,
  });

  /// Constructs a [ResearchNoteEntity] from a database row map.
  factory ResearchNoteEntity.fromDb(Map<String, dynamic> row) {
    return ResearchNoteEntity(
      id: row['id'] as int,
      content: row['content'] as String,
      type: row['type'] as String,
      relatedHypothesisId: row['relatedHypothesisId'] as String?,
      certaintyScore: (row['certaintyScore'] as num?)?.toDouble(),
      createdAt: row['createdAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Free-text content of the research finding.
  final String content;

  /// Note type category (e.g. "observation", "anomaly").
  final String type;

  /// Related HypothesisEntity ID if applicable.
  final String? relatedHypothesisId;

  /// Certainty score of this finding (0.0 to 1.0).
  final double? certaintyScore;

  /// Timestamp when inserted into the database.
  final DateTime createdAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'content': content,
      'type': type,
      'relatedHypothesisId': relatedHypothesisId,
      'certaintyScore': certaintyScore,
    };
  }
}
