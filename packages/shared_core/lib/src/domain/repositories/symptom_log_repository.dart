import 'package:shared_core/core.dart';

/// Repository interface for SymptomLog data access.
/// Tracks real-time symptom events reported by the user.
abstract class SymptomLogRepository {
  /// Fetches recent symptom logs for a body region.
  Future<List<SymptomEvent>> getRecentSymptoms(
    String muscleId, {
    int limit = 10,
  });

  /// Gets the average symptom intensity for a region over last N days.
  Future<double> getAvgIntensity(String muscleId, int days);

  /// Fetches all symptom logs.
  Future<List<SymptomEvent>> getAllSymptoms();

  /// Logs a new symptom event.
  Future<int> logSymptom(SymptomEvent symptom);

  /// Logs batch symptoms.
  Future<List<int>> logBatch([List<SymptomEvent> symptoms]);

  /// Deletes a symptom entry by ID.
  Future<void> deleteSymptom(int id);
}
