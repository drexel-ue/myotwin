/// Domain entity: Body segment node in the kinetic graph.
class BodySegmentEntity {
  const BodySegmentEntity({
    this.id,
    required this.name,
    required this.region,
    this.description,
    this.integrityScore = 1.0,
    this.heatIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BodySegmentEntity.fromDb(Map<String, dynamic> row) {
    return BodySegmentEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      region: row['region'] as String,
      description: row['description'] as String?,
      integrityScore: (row['integrityScore'] as num).toDouble(),
      heatIndex: row['heatIndex'] as String?,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }
  final int? id;
  final String name;
  final String region;
  final String? description;
  final double integrityScore;
  final String? heatIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'region': region,
      'description': description,
      'integrityScore': integrityScore,
      'heatIndex': heatIndex,
    };
  }
}
