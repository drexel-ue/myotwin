/// Domain entity: Source research material.
class SourceEntity {
  const SourceEntity({
    this.id,
    required this.title,
    this.authors,
    this.link,
    this.keyTakeaway,
    this.relationshipToHypothesis,
    required this.createdAt,
  });

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
  final int? id;
  final String title;
  final String? authors;
  final String? link;
  final String? keyTakeaway;
  final String? relationshipToHypothesis;
  final DateTime createdAt;

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
