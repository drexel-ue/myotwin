/// Inventory of available equipment types for the equipment registry.
enum EquipmentType {
  /// Gymnastics rings
  rings,

  /// Parallel bars
  parallettes,

  /// Heavy weight with offset center of mass
  mace,

  /// No equipment (bodyweight only).
  none,
}

/// Extension providing database-safe string representation for EquipmentType.
extension EquipmentTypeX on EquipmentType {
  /// Returns the database-safe string value of this EquipmentType.
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
