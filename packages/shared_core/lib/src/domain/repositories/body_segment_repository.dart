import 'package:shared_core/core.dart';

/// Repository interface for BodySegment data access.
/// Defines the contract for CRUD operations on body segment nodes.
abstract class BodySegmentRepository {
  /// Fetches all registered body segments.
  Future<List<BodySegmentEntity>> getAllSegments();

  /// Fetches a single body segment by ID.
  Future<BodySegmentEntity?> getSegmentById(int id);

  /// Fetches segments by anatomical region.
  Future<List<BodySegmentEntity>> getSegmentsByRegion(String region);

  /// Fetches integrity scores for multiple body segments by their IDs.
  Future<Map<String, double>> getManyIntegrityScores(List<String> muscleIds);

  /// Saves or updates a body segment.
  Future<int> upsert(BodySegmentEntity segment);

  /// Deletes a body segment by ID.
  Future<void> deleteSegment(int id);
}
