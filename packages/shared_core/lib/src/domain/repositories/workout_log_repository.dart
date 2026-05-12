import 'package:shared_core/core.dart';

/// Repository interface for WorkoutLog data access.
/// Tracks completed workouts and sets.
abstract class WorkoutLogRepository {
  /// Fetches workout logs for a date range.
  Future<List<WorkoutLogEntity>> getByDateRange(DateTime start, DateTime end);

  /// Fetches today's workout logs.
  Future<List<WorkoutLogEntity>> getTodaysLogs();

  /// Saves a workout log entry.
  Future<int> log(WorkoutLogEntity log);

  /// Deletes a workout log by ID.
  Future<void> deleteLog(int id);
}
