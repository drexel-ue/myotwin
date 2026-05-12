/// Domain entity: Ingested biomechanical principle.
class PrincipleEntity {
  const PrincipleEntity({
    this.id,
    required this.name,
    required this.statement,
    required this.category,
    this.knowledgeSourceId,
    required this.createdAt,
  });

  factory PrincipleEntity.fromDb(Map<String, dynamic> row) {
    return PrincipleEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      statement: row['statement'] as String,
      category: row['category'] as String,
      knowledgeSourceId: row['knowledgeSourceId'] as String?,
      createdAt: row['createdAt'] as DateTime,
    );
  }
  final int? id;
  final String name;
  final String statement;
  final String category;
  final String? knowledgeSourceId;
  final DateTime createdAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'statement': statement,
      'category': category,
      'knowledgeSourceId': knowledgeSourceId,
    };
  }
}
