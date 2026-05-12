import 'package:shared_core/core.dart';

/// Data access interface for Equipment entities.
/// Tracks user-registered equipment with availability configuration.
abstract class EquipmentRepository {
  /// Fetches all registered equipment items.
  Future<List<EquipmentEntity>> getAllEquipment();

  /// Fetches only available (active) equipment items.
  Future<List<EquipmentEntity>> getAvailableEquipment();

  /// Fetches specific equipment by [id].
  ///
  /// Returns `null` if no equipment with the given ID exists.
  Future<EquipmentEntity?> getEquipmentById(int id);

  /// Fetches equipment whose modality matches [modality].
  Future<List<EquipmentEntity>> getByModality(String modality);

  /// Updates the availability and optional [configuration] of
  /// the equipment identified by [id].
  Future<void> updateStatus(
    int id, {
    required bool isAvailable,
    Map<String, dynamic>? configuration,
  });

  /// Inserts a new equipment item or updates an existing one.
  ///
  /// Returns the equipment ID.
  Future<int> upsert(EquipmentEntity equipment);

  /// Deletes the equipment with the given [id].
  Future<void> deleteEquipment(int id);
}
