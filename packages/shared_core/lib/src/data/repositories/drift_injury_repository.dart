import 'package:shared_core/core.dart';
import 'package:shared_core/src/data/database.dart';

/// Drift-backed implementation of the [InjuryRepository].
class DriftInjuryRepository implements InjuryRepository {
  /// Constructs a [DriftInjuryRepository].
  DriftInjuryRepository(this.db);

  /// The database instance used for persistence.
  final MyoTwinDatabase db;

  @override
  Future<List<InjuryEntity>> getAllInjuries() async {
    throw UnimplementedError('DriftInjuryRepository.getAllInjuries not yet implemented');
  }

  @override
  Future<List<InjuryEntity>> getAcuteInjuries(String bodyRegion) async {
    throw UnimplementedError('DriftInjuryRepository.getAcuteInjuries not yet implemented');
  }

  @override
  Future<List<InjuryEntity>> getDormantInjuries(String bodyRegion) async {
    throw UnimplementedError('DriftInjuryRepository.getDormantInjuries not yet implemented');
  }

  @override
  Future<List<InjuryEntity>> getChronicInjuries(String bodyRegion) async {
    throw UnimplementedError('DriftInjuryRepository.getChronicInjuries not yet implemented');
  }

  @override
  Future<void> updateIntegrityScore(int injuryId, double newIntegrity, {String? reason}) async {
    throw UnimplementedError('DriftInjuryRepository.updateIntegrityScore not yet implemented');
  }

  @override
  Future<int> upsert(InjuryEntity injury) async {
    throw UnimplementedError('DriftInjuryRepository.upsert not yet implemented');
  }

  @override
  Future<void> deleteInjury(int id) async {
    throw UnimplementedError('DriftInjuryRepository.deleteInjury not yet implemented');
  }
}
