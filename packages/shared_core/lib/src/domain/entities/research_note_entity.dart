/// Domain entity: Research note from background auditor findings.
class ResearchNoteEntity {
  const ResearchNoteEntity({
    this.id,
    required this.content,
    required this.type,
    this.relatedHypothesisId,
    this.certaintyScore,
    required this.createdAt,
  });

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
  final int? id;
  final String content;
  final String type;
  final String? relatedHypothesisId;
  final double? certaintyScore;
  final DateTime createdAt;

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
