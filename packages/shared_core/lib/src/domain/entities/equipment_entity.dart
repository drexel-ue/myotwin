/// Registered exercise equipment in the MyoTwin system.
///
/// Tracks modality, availability, and configuration so the app
/// can calibrate biomechanical exercises to the right tools.
class EquipmentEntity {
  /// Creates an equipment registration record.
  const EquipmentEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Display name of the equipment.
    required this.name,

    /// Modality type (e.g. "band", "dumbbell", "machine").
    required this.modality,

    /// Fixed anchor point in space (e.g. "ceiling").
    this.anchorPoint,

    /// Whether the equipment is currently active/available.
    this.active = true,

    /// Current JSON configuration string.
    this.currentConfiguration,

    /// Timestamp when the equipment was first registered.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [EquipmentEntity] from a database row map.
  factory EquipmentEntity.fromDb(Map<String, dynamic> row) {
    return EquipmentEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      modality: row['modality'] as String,
      anchorPoint: row['anchorPoint'] as String?,
      active: (row['active'] as int) == 1,
      currentConfiguration: row['currentConfiguration'] as String?,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Display name of the equipment (e.g. "Resistance Band").
  final String name;

  /// Modality type (e.g. "band", "dumbbell", "machine").
  final String modality;

  /// Fixed anchor point in space (e.g. "ceiling").
  final String? anchorPoint;

  /// Whether the equipment is currently active and available.
  final bool active;

  /// Current JSON configuration string.
  final String? currentConfiguration;

  /// Timestamp when the equipment was first registered.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'modality': modality,
      'anchorPoint': anchorPoint,
      'active': active ? 1 : 0,
      'currentConfiguration': currentConfiguration,
    };
  }

  /// Creates a copy of this entity with the given fields replaced.
  EquipmentEntity copyWith({
    int? id,
    String? name,
    String? modality,
    String? anchorPoint,
    bool? active,
    String? currentConfiguration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EquipmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      modality: modality ?? this.modality,
      anchorPoint: anchorPoint ?? this.anchorPoint,
      active: active ?? this.active,
      currentConfiguration: currentConfiguration ?? this.currentConfiguration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
