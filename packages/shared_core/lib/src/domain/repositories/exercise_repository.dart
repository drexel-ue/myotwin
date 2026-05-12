import 'package:shared_core/core.dart';

/// Data access interface for Exercise entities.
/// Manages exercise definitions and metadata.
abstract class ExerciseRepository {
  /// Fetches all exercises.
  Future<List<ExerciseEntity>> getAll();

  /// Fetches exercises whose category matches [category].
  Future<List<ExerciseEntity>> getByCategory(String category);

  /// Fetches exercises requiring equipment matching [equipment].
  Future<List<ExerciseEntity>> getByEquipment(String equipment);

  /// Fetches a specific exercise by [id].
  ///
  /// Returns `null` if no exercise with the given ID exists.
  Future<ExerciseEntity?> getExerciseById(int id);

  /// Inserts a new exercise or updates an existing one.
  ///
  /// Returns the exercise ID.
  Future<int> upsert(ExerciseEntity exercise);

  /// Deletes the exercise with the given [id].
  Future<void> deleteExercise(int id);
}
