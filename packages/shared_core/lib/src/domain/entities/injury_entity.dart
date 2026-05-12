/// Injury tracked in the MyoTwin recovery and research loop.
///
/// Captures the body region, type, integrity degradation, and any
/// functional offsets caused by the injury (e.g. gait changes).
class InjuryEntity {
  /// Creates an injury record for the tracking system.
  const InjuryEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Body region affected (e.g. "Lower Back").
    required this.bodyRegion,

    /// Injury type: Acute, Dormant, or Chronic.
    required this.type,

    /// Tissue integrity score. 0.0 is most degraded.
    this.integrityScore = 0.0,

    /// Functional offsets caused by injury (e.g. "Left Hip").
    this.functionalOffsets,

    /// Free-text narrative about the injury event.
    this.narrative,

    /// Status: Active, Healed, etc.
    required this.status,

    /// Date the injury was sustained or last assessed.
    required this.date,

    /// Timestamp when the injury was first logged.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [InjuryEntity] from a database row map.
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

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Body region affected (e.g. "Lower Back").
  final String bodyRegion;

  /// Injury type: Acute, Dormant, or Chronic.
  final String type;

  /// Tissue integrity score. 0.0 is most degraded.
  final double integrityScore;

  /// Functional offsets caused by injury (e.g. "Left Hip").
  final List<String>? functionalOffsets;

  /// Free-text narrative about the injury event.
  final String? narrative;

  /// Status: Active, Healed, or other lifecycle states.
  final String status;

  /// Date the injury was sustained or last assessed.
  final DateTime date;

  /// Timestamp when the injury was first logged.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
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

  /// Creates a copy of this entity with the given fields replaced.
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
