import 'package:shared_core/core.dart';

/// Data access interface for InjuryEntity entities.
/// Tracks old and new injuries with integrity scores and
/// functional offsets.
abstract class InjuryRepository {
  /// Fetches all injuries grouped by region.
  Future<List<InjuryEntity>> getAllInjuries();

  /// Fetches acute injuries for the anatomical region [bodyRegion].
  Future<List<InjuryEntity>> getAcuteInjuries(String bodyRegion);

  /// Fetches dormant injuries for the anatomical region [bodyRegion].
  Future<List<InjuryEntity>> getDormantInjuries(String bodyRegion);

  /// Fetches chronic injuries for the anatomical region [bodyRegion].
  Future<List<InjuryEntity>> getChronicInjuries(String bodyRegion);

  /// Updates the integrity score of the injury identified by [injuryId].
  ///
  /// Optionally records a [reason] for the update.
  Future<void> updateIntegrityScore(
    int injuryId,
    double newIntegrity, {
    String? reason,
  });

  /// Inserts a new injury or updates an existing one.
  ///
  /// Returns the injury ID.
  Future<int> upsert(InjuryEntity injury);

  /// Deletes the injury with the given [id].
  Future<void> deleteInjury(int id);
}
