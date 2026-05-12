import 'package:shared_core/core.dart';

/// Repository interface for Equipment data access.
/// Tracks user's registered equipment with availability configuration.
abstract class EquipmentRepository {
  /// Fetches all registered equipment.
  Future<List<EquipmentEntity>> getAllEquipment();

  /// Fetches available (active) equipment.
  Future<List<EquipmentEntity>> getAvailableEquipment();

  /// Fetches specific equipment by ID.
  Future<EquipmentEntity?> getEquipmentById(int id);

  /// Fetches equipment of a specific modality.
  Future<List<EquipmentEntity>> getByModality(String modality);

  /// Updates equipment availability and configuration.
  Future<void> updateStatus(
    int id, {
    required bool isAvailable,
    Map<String, dynamic>? configuration,
  });

  /// Saves or updates equipment.
  Future<int> upsert(EquipmentEntity equipment);

  /// Deletes equipment by ID.
  Future<void> deleteEquipment(int id);
}
