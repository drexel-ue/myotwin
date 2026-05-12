/// Domain entity: Exercise definition.
class ExerciseEntity {
  const ExerciseEntity({
    this.id,
    required this.name,
    this.description,
    required this.category,
    required this.targetMuscles,
    this.requiredEquipment,
    this.ringHeight,
    this.durationSecs,
    this.scientificRationale,
    this.equipmentNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseEntity.fromDb(Map<String, dynamic> row) {
    return ExerciseEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      description: row['description'] as String?,
      category: row['category'] as String,
      targetMuscles: row['targetMuscles'] as String,
      requiredEquipment: row['requiredEquipment'] as String?,
      ringHeight: (row['ringHeight'] as num?)?.toDouble(),
      durationSecs: row['durationSecs'] as int?,
      scientificRationale: row['scientificRationale'] as String?,
      equipmentNotes: row['equipmentNotes'] as String?,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }
  final int? id;
  final String name;
  final String? description;
  final String category;
  final String targetMuscles;
  final String? requiredEquipment;
  final double? ringHeight;
  final int? durationSecs;
  final String? scientificRationale;
  final String? equipmentNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'targetMuscles': targetMuscles,
      'requiredEquipment': requiredEquipment,
      'ringHeight': ringHeight,
      'durationSecs': durationSecs,
      'scientificRationale': scientificRationale,
      'equipmentNotes': equipmentNotes,
    };
  }
}
