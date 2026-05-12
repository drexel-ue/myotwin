/// Mock test doubles for MyoTwin domain interfaces.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shared_core/core.dart';

/// Mock for [BodySegmentRepository] for use in tests.
class MockBodySegmentRepository implements BodySegmentRepository {
  @override
  Future<List<BodySegmentEntity>> getAllSegments() async => [];

  @override
  Future<BodySegmentEntity?> getSegmentById(int id) async => null;

  @override
  Future<List<BodySegmentEntity>> getSegmentsByRegion(String region) async => [];

  @override
  Future<Map<String, double>> getManyIntegrityScores(
    List<String> muscleIds,
  ) async => {};

  @override
  Future<int> upsert(BodySegmentEntity segment) async => 1;

  @override
  Future<void> deleteSegment(int id) async {}
}

/// Mock for [InjuryRepository] for use in tests.
class MockInjuryRepository implements InjuryRepository {
  @override
  Future<List<InjuryEntity>> getAllInjuries() async => [];

  @override
  Future<List<InjuryEntity>> getAcuteInjuries(String bodyRegion) async => [];

  @override
  Future<List<InjuryEntity>> getDormantInjuries(String bodyRegion) async => [];

  @override
  Future<List<InjuryEntity>> getChronicInjuries(String bodyRegion) async => [];

  @override
  Future<void> updateIntegrityScore(
    int injuryId,
    double newIntegrity, {
    String? reason,
  }) async {}

  @override
  Future<int> upsert(InjuryEntity injury) async => 1;

  @override
  Future<void> deleteInjury(int id) async {}
}

/// Mock for [EquipmentRepository] for use in tests.
class MockEquipmentRepository implements EquipmentRepository {
  @override
  Future<List<EquipmentEntity>> getAllEquipment() async => [];

  @override
  Future<List<EquipmentEntity>> getAvailableEquipment() async => [];

  @override
  Future<EquipmentEntity?> getEquipmentById(int id) async => null;

  @override
  Future<List<EquipmentEntity>> getByModality(String modality) async => [];

  @override
  Future<void> updateStatus(
    int id, {
    required bool isAvailable,
    Map<String, dynamic>? configuration,
  }) async {}

  @override
  Future<int> upsert(EquipmentEntity equipment) async => 1;

  @override
  Future<void> deleteEquipment(int id) async {}
}

/// Mock for [HypothesisRepository] for use in tests.
class MockHypothesisRepository implements HypothesisRepository {
  @override
  Future<List<HypothesisEntity>> getActiveHypotheses() async => [];

  @override
  Future<List<HypothesisEntity>> getByTargetNode(String targetNode) async => [];

  @override
  Future<int> create(HypothesisEntity hypothesis) async => 1;

  @override
  Future<void> updateCertainty(
    int hypothesisId,
    double newCertainty,
    String feedbackType,
  ) async {}

  @override
  Future<void> dismiss(int hypothesisId, {String? reason}) async {}

  @override
  Future<int> upsert(HypothesisEntity hypothesis) async => 1;

  @override
  Future<void> deleteHypothesis(int id) async {}
}

/// Mock for [SymptomLogRepository] for use in tests.
class MockSymptomLogRepository implements SymptomLogRepository {
  @override
  Future<List<SymptomEvent>> getRecentSymptoms(
    String muscleId, {
    int limit = 10,
  }) async => [];

  @override
  Future<double> getAvgIntensity(String muscleId, int days) async => 0.0;

  @override
  Future<List<SymptomEvent>> getAllSymptoms() async => [];

  @override
  Future<int> logSymptom(SymptomEvent symptom) async => 1;

  @override
  Future<List<int>> logBatch([List<SymptomEvent> symptoms = const []]) async => [];

  @override
  Future<void> deleteSymptom(int id) async {}
}

/// Mock for [KnowledgeSourceRepository] for use in tests.
class MockKnowledgeSourceRepository implements KnowledgeSourceRepository {
  @override
  Future<List<KnowledgeSourceEntity>> getAll() async => [];

  @override
  Future<List<KnowledgeSourceEntity>> getByCategory(String category) async => [];

  @override
  Future<int> ingest({
    required String contentType,
    required String content,
    String? title,
    String? category,
  }) async => 1;

  @override
  Future<void> delete(int id) async {}
}

/// Mock for [ExerciseRepository] for use in tests.
class MockExerciseRepository implements ExerciseRepository {
  @override
  Future<List<ExerciseEntity>> getAll() async => [];

  @override
  Future<List<ExerciseEntity>> getByCategory(String category) async => [];

  @override
  Future<List<ExerciseEntity>> getByEquipment(String equipment) async => [];

  @override
  Future<ExerciseEntity?> getExerciseById(int id) async => null;

  @override
  Future<int> upsert(ExerciseEntity exercise) async => 1;

  @override
  Future<void> deleteExercise(int id) async {}
}

/// Mock for [WorkoutLogRepository] for use in tests.
class MockWorkoutLogRepository implements WorkoutLogRepository {
  @override
  Future<List<WorkoutLogEntity>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async => [];

  @override
  Future<List<WorkoutLogEntity>> getTodaysLogs() async => [];

  @override
  Future<int> log(WorkoutLogEntity logEntry) async => 1;

  @override
  Future<void> deleteLog(int id) async {}
}

/// Mock for [ResearchNoteRepository] for use in tests.
class MockResearchNoteRepository implements ResearchNoteRepository {
  @override
  Future<List<ResearchNoteEntity>> getAll() async => [];

  @override
  Future<List<ResearchNoteEntity>> getByHypothesisId(
    String hypothesisId,
  ) async => [];

  @override
  Future<int> save(ResearchNoteEntity note) async => 1;

  @override
  Future<void> deleteNote(int id) async {}
}

/// Mock for [PrincipleRepository] for use in tests.
class MockPrincipleRepository implements PrincipleRepository {
  @override
  Future<List<PrincipleEntity>> getAll() async => [];

  @override
  Future<List<PrincipleEntity>> getByCategory(String category) async => [];

  @override
  Future<List<PrincipleEntity>> getByKnowledgeSource(
    String knowledgeSourceId,
  ) async => [];

  @override
  Future<int> save(PrincipleEntity principle) async => 1;

  @override
  Future<void> deletePrinciple(int id) async {}
}

/// Mock for [NoiseLogRepository] for use in tests.
class MockNoiseLogRepository implements NoiseLogRepository {
  @override
  Future<List<NoiseLogEntity>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async => [];

  @override
  Future<List<NoiseLogEntity>> getByType(String type) async => [];

  @override
  Future<int> save(NoiseLogEntity entry) async => 1;

  @override
  Future<void> deleteNoiseLog(int id) async {}
}

/// Mock for [KineticChainEdgeRepository] for use in tests.
class MockKineticChainEdgeRepository implements KineticChainEdgeRepository {
  @override
  Future<List<KineticChainEdgeEntity>> getAll() async => [];

  @override
  Future<List<KineticChainEdgeEntity>> getBySourceNode(
    String sourceNode,
  ) async => [];

  @override
  Future<List<KineticChainEdgeEntity>> getBetweenNodes(
    String source,
    String target,
  ) async => [];

  @override
  Future<int> create(KineticChainEdgeEntity edge) async => 1;

  @override
  Future<void> updateEdge(
    int id, {
    double? weight,
    double? correlation,
  }) async {}

  @override
  Future<void> deleteEdge(int id) async {}
}

/// Mock for [NotificationContextRepository] for use in tests.
class MockNotificationContextRepository implements NotificationContextRepository {
  @override
  Future<List<NotificationContextEntity>> getPending() async => [];

  @override
  Future<List<NotificationContextEntity>> getAll() async => [];

  @override
  Future<NotificationContextEntity?> getByUuid(String uuid) async => null;

  @override
  Future<String> schedule({
    required String title,
    required String body,
    required String contextUuid,
    required int delayMinutes,
    required String deepLink,
  }) async => 'mock-uuid';

  @override
  Future<void> markAsRead(String uuid) async {}

  @override
  Future<void> deleteByUuid(String uuid) async {}
}

/// Mock for [DriveSettingsRepository] for use in tests.
class MockDriveSettingsRepository implements DriveSettingsRepository {
  @override
  Future<List<DriveSettingsEntity>> getAll() async => [];

  @override
  Future<List<DriveSettingsEntity>> getGlobalSettings() async => [];

  @override
  Future<List<DriveSettingsEntity>> getByNodeId(String nodeId) async => [];

  @override
  Future<int> upsert(DriveSettingsEntity setting) async => 1;

  @override
  Future<void> deleteSetting(int id) async {}
}

/// Mock for [DeviceSyncStateRepository] for use in tests.
class MockDeviceSyncStateRepository implements DeviceSyncStateRepository {
  @override
  Future<DeviceSyncStateEntity?> getByDeviceId(String deviceId) async => null;

  @override
  Future<int> upsert(DeviceSyncStateEntity state) async => 1;

  @override
  Future<void> deleteState(String deviceId) async {}
}

/// Mock for [SourceRepository] for use in tests.
class MockSourceRepository implements SourceRepository {
  @override
  Future<List<SourceEntity>> getAll() async => [];

  @override
  Future<List<SourceEntity>> getByCategory(String category) async => [];

  @override
  Future<int> save(SourceEntity source) async => 1;

  @override
  Future<void> deleteSource(int id) async {}
}

/// Fake [HypothesisEntity] for tests.
class MockFailure extends Failure {
  MockFailure(String message, {String? code}) : super(message, code: code);
}

class MockMotusCoordinator implements MotusCoordinator {
  @override
  Future<bool> get externalModelAvailable async => false;

  @override
  String get currentMode => 'local';

  @override
  Either<String, Failure> sendMessage(
    String message, {
    Map<String, dynamic>? context,
    String? mode,
  }) {
    return Either.left('Response from mock Motus.');
  }

  @override
  Future<Stream<Either<String, Failure>>> sendMessageStreaming(
    String message, {
    Map<String, dynamic>? context,
    String? mode,
  }) async {
    return Stream.fromIterable([Either.left('Response from mock Motus streaming.')]);
  }

  @override
  Either<bool, Failure> logSymptomViaMotus({
    required String muscleId,
    required int intensity,
    String? note,
    String? category,
  }) {
    return Either.left(true);
  }

  @override
  Future<Map<String, double>> fetchIntegrityScores(
    List<String> muscleIds,
  ) async => {for (final id in muscleIds) id: 1.0};

  @override
  Future<String> getContextSnapshot() async => '{}';
}
