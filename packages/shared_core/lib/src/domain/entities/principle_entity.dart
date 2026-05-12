/// Biomechanical principle ingested during the MyoTwin research process.
///
/// Captures domain principles that guide the local-only coaching
/// and analysis engine without any remote dependency.
class PrincipleEntity {
  /// Creates an ingested biomechanical principle record.
  const PrincipleEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Display name of the principle.
    required this.name,

    /// Statement of the principle.
    required this.statement,

    /// Classification category (e.g. "load-management").
    required this.category,

    /// ID of the KnowledgeSourceEntity this was drawn from.
    this.knowledgeSourceId,

    /// Timestamp when the principle was ingested.
    required this.createdAt,
  });

  /// Constructs a [PrincipleEntity] from a database row map.
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

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Display name of the principle (e.g. "Progressive Overload").
  final String name;

  /// Statement of the principle.
  final String statement;

  /// Classification category (e.g. "load-management").
  final String category;

  /// ID of the KnowledgeSourceEntity this was drawn from.
  final String? knowledgeSourceId;

  /// Timestamp when the principle was ingested.
  final DateTime createdAt;

  /// Exports the entity to a database row map for persistence.
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
