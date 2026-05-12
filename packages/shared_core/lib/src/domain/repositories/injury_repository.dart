import 'package:shared_core/core.dart';

/// Repository interface for InjuryVault data access.
/// Tracks old and new injuries with integrity scores and functional offsets.
abstract class InjuryRepository {
  /// Fetches all injuries grouped by region.
  Future<List<InjuryEntity>> getAllInjuries();

  /// Fetches acute injuries for a body region.
  Future<List<InjuryEntity>> getAcuteInjuries(String bodyRegion);

  /// Fetches dormant injuries for a body region.
  Future<List<InjuryEntity>> getDormantInjuries(String bodyRegion);

  /// Fetches chronic injuries for a body region.
  Future<List<InjuryEntity>> getChronicInjuries(String bodyRegion);

  /// Updates integrity score for an injury with optional reason.
  Future<void> updateIntegrityScore(
    int injuryId,
    double newIntegrity, {
    String? reason,
  });

  /// Saves or updates an injury.
  Future<int> upsert(InjuryEntity injury);

  /// Deletes an injury by ID.
  Future<void> deleteInjury(int id);
}
