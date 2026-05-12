import 'package:shared_core/core.dart';

/// Repository interface for Exercise data access.
/// Manages exercise definitions and metadata.
abstract class ExerciseRepository {
  /// Fetches all exercises.
  Future<List<ExerciseEntity>> getAll();

  /// Fetches exercises by category.
  Future<List<ExerciseEntity>> getByCategory(String category);

  /// Fetches exercises requiring specific equipment.
  Future<List<ExerciseEntity>> getByEquipment(String equipment);

  /// Fetches a specific exercise by ID.
  Future<ExerciseEntity?> getExerciseById(int id);

  /// Saves or updates an exercise.
  Future<int> upsert(ExerciseEntity exercise);

  /// Deletes an exercise by ID.
  Future<void> deleteExercise(int id);
}
