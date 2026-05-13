import 'package:shared_core/core.dart';
import 'package:shared_core/src/data/database.dart';

/// Drift-backed implementation of the [BodySegmentRepository].
class DriftBodySegmentRepository implements BodySegmentRepository {
  /// Constructs a [DriftBodySegmentRepository].
  DriftBodySegmentRepository(this.db);

  /// The database instance used for persistence.
  final MyoTwinDatabase db;

  @override
  Future<List<BodySegmentEntity>> getAllSegments() async {
    throw UnimplementedError('DriftBodySegmentRepository.getAllSegments not yet implemented');
  }

  @override
  Future<BodySegmentEntity?> getSegmentById(int id) async {
    throw UnimplementedError('DriftBodySegmentRepository.getSegmentById not yet implemented');
  }

  @override
  Future<List<BodySegmentEntity>> getSegmentsByRegion(String region) async {
    throw UnimplementedError('DriftBodySegmentRepository.getSegmentsByRegion not yet implemented');
  }

  @override
  Future<Map<String, double>> getManyIntegrityScores(List<String> muscleIds) async {
    throw UnimplementedError('DriftBodySegmentRepository.getManyIntegrityScores not yet implemented');
  }

  @override
  Future<int> upsert(BodySegmentEntity segment) async {
    throw UnimplementedError('DriftBodySegmentRepository.upsert not yet implemented');
  }

  @override
  Future<void> deleteSegment(int id) async {
    throw UnimplementedError('DriftBodySegmentRepository.deleteSegment not yet implemented');
  }
}
