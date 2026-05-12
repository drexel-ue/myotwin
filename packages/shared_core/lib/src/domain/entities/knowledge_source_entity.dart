/// Domain entity: Knowledge source ingested from user input.
class KnowledgeSourceEntity {
  const KnowledgeSourceEntity({
    this.id,
    required this.contentType,
    required this.content,
    this.title,
    this.category,
    required this.createdAt,
  });

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
  final int? id;
  final String contentType; // pdf, text, url
  final String content;
  final String? title;
  final String? category;
  final DateTime createdAt;

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
