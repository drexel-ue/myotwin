/// Research source material for MyoTwin's local knowledge base.
///
/// Stores bibliographic references tied to recovery hypotheses so
/// the local-only research process can audit evidence chains.
class SourceEntity {
  /// Creates a research source record.
  const SourceEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Title of the research material.
    required this.title,

    /// Author names (null if not available).
    this.authors,

    /// URL to the full reference (null if none).
    this.link,

    /// Main takeaway from this source.
    this.keyTakeaway,

    /// How it relates to the active hypothesis.
    this.relationshipToHypothesis,

    /// Timestamp when inserted into the database.
    required this.createdAt,
  });

  /// Constructs a [SourceEntity] from a database row map.
  factory SourceEntity.fromDb(Map<String, dynamic> row) {
    return SourceEntity(
      id: row['id'] as int,
      title: row['title'] as String,
      authors: row['authors'] as String?,
      link: row['link'] as String?,
      keyTakeaway: row['keyTakeaway'] as String?,
      relationshipToHypothesis: row['relationshipToHypothesis'] as String?,
      createdAt: row['createdAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Title of the research material.
  final String title;

  /// Author names (null if not available).
  final String? authors;

  /// URL to the full reference (null if none).
  final String? link;

  /// Main takeaway from this source.
  final String? keyTakeaway;

  /// How it relates to the active hypothesis.
  final String? relationshipToHypothesis;

  /// Timestamp when inserted into the database.
  final DateTime createdAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'authors': authors,
      'link': link,
      'keyTakeaway': keyTakeaway,
      'relationshipToHypothesis': relationshipToHypothesis,
    };
  }
}
