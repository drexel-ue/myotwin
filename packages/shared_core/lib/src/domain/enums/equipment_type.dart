/// Inventory of available equipment types for the equipment registry.
enum EquipmentType {
  /// Gymnastics rings.
  rings,

  /// Parallettes.
  parallettes,

  /// Mace.
  mace,

  /// No equipment (bodyweight only).
  none,
}

/// Extension providing database-safe string representation for [EquipmentType].
extension EquipmentTypeX on EquipmentType {
  String get value {
    switch (this) {
      case EquipmentType.rings:
        return 'rings';
      case EquipmentType.parallettes:
        return 'parallettes';
      case EquipmentType.mace:
        return 'mace';
      case EquipmentType.none:
        return 'none';
    }
  }
}
