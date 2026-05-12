/// Domain entity: Injury tracking with integrity score and functional offsets.
class InjuryEntity {
  const InjuryEntity({
    this.id,
    required this.bodyRegion,
    required this.type,
    this.integrityScore = 0.0,
    this.functionalOffsets,
    this.narrative,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InjuryEntity.fromDb(Map<String, dynamic> row) {
    return InjuryEntity(
      id: row['id'] as int,
      bodyRegion: row['bodyRegion'] as String,
      type: row['type'] as String,
      integrityScore: (row['integrityScore'] as num).toDouble(),
      functionalOffsets: row['functionalOffsets'] != null
          ? (row['functionalOffsets'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : null,
      narrative: row['narrative'] as String?,
      status: row['status'] as String,
      date: row['date'] as DateTime,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }
  final int? id;
  final String bodyRegion;
  final String type; // Acute, Dormant, Chronic
  final double integrityScore;
  final List<String>? functionalOffsets;
  final String? narrative;
  final String status; // Active, Healed, etc.
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'bodyRegion': bodyRegion,
      'type': type,
      'integrityScore': integrityScore,
      'functionalOffsets': functionalOffsets?.join(','),
      'narrative': narrative,
      'status': status,
      'date': date,
    };
  }

  InjuryEntity copyWith({
    int? id,
    String? bodyRegion,
    String? type,
    double? integrityScore,
    List<String>? functionalOffsets,
    String? narrative,
    String? status,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InjuryEntity(
      id: id ?? this.id,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      type: type ?? this.type,
      integrityScore: integrityScore ?? this.integrityScore,
      functionalOffsets: functionalOffsets ?? this.functionalOffsets,
      narrative: narrative ?? this.narrative,
      status: status ?? this.status,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
