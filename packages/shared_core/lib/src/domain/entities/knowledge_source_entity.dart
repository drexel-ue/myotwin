/// Ingested knowledge source from user-provided local input.
///
/// Stores any material the user enters (PDFs, links, notes) that
/// feeds into the MyoTwin local-only research reasoning loop.
class KnowledgeSourceEntity {
  /// Creates an ingested knowledge source record.
  const KnowledgeSourceEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Media type: "pdf", "text", "url", etc.
    required this.contentType,

    /// Raw content of the knowledge source.
    required this.content,

    /// Optional human-readable title.
    this.title,

    /// Optional classification category.
    this.category,

    /// Timestamp when the source was ingested.
    required this.createdAt,
  });

  /// Constructs a [KnowledgeSourceEntity] from a database row map.
  factory KnowledgeSourceEntity.fromDb(Map<String, dynamic> row) {
    return KnowledgeSourceEntity(
      id: row['id'] as int,
      contentType: row['contentType'] as String,
      content: row['content'] as String,
      title: row['title'] as String?,
      category: row['category'] as String?,
      createdAt: row['createdAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Media type: "pdf", "text", "url", etc.
  final String contentType;

  /// Raw content of the knowledge source.
  final String content;

  /// Human-readable title (null if not provided).
  final String? title;

  /// Classification category (null if unclassified).
  final String? category;

  /// Timestamp when the source was ingested.
  final DateTime createdAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'contentType': contentType,
      'content': content,
      'title': title,
      'category': category,
    };
  }
}
