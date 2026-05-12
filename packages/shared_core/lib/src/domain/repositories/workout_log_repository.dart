import 'package:shared_core/core.dart';

/// Data access interface for WorkoutLog entities.
/// Tracks completed workouts and sets.
abstract class WorkoutLogRepository {
  /// Fetches workout logs within the date range [start] to [end].
  Future<List<WorkoutLogEntity>> getByDateRange(DateTime start, DateTime end);

  /// Fetches today's workout logs.
  Future<List<WorkoutLogEntity>> getTodaysLogs();

  /// Persists a new [log] entry.
  ///
  /// Returns the log ID.
  Future<int> log(WorkoutLogEntity log);

  /// Deletes the workout log with the given [id].
  Future<void> deleteLog(int id);
}
