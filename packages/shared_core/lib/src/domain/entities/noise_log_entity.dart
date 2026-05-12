/// Domain entity: Noise log entry for environmental/mental/stress data.
class NoiseLogEntity {
  const NoiseLogEntity({
    this.id,
    required this.type,
    this.intensity,
    this.note,
    required this.sourceType,
    required this.loggedAt,
    required this.createdAt,
  });

  factory NoiseLogEntity.fromDb(Map<String, dynamic> row) {
    return NoiseLogEntity(
      id: row['id'] as int,
      type: row['type'] as String,
      intensity: row['intensity'] as int?,
      note: row['note'] as String?,
      sourceType: row['sourceType'] as String,
      loggedAt: row['logDate'] as DateTime,
      createdAt: row['createdAt'] as DateTime,
    );
  }
  final int? id;
  final String type;
  final int? intensity;
  final String? note;
  final String sourceType;
  final DateTime loggedAt;
  final DateTime createdAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'intensity': intensity,
      'note': note,
      'sourceType': sourceType,
      'logDate': loggedAt,
    };
  }
}
