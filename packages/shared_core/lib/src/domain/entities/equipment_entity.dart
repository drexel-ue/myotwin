/// Domain entity: Equipment registration with availability and configuration.
class EquipmentEntity {
  const EquipmentEntity({
    this.id,
    required this.name,
    required this.modality,
    this.anchorPoint,
    this.active = true,
    this.currentConfiguration,
    required this.createdAt,
    required this.updatedAt,
  });

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
  final int? id;
  final String name;
  final String modality;
  final String? anchorPoint;
  final bool active;
  final String? currentConfiguration;
  final DateTime createdAt;
  final DateTime updatedAt;

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
