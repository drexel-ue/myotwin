import 'package:shared_core/core.dart';

/// Repository interface for DriveSettings data access.
/// Manages global and per-node intensity/drive values.
abstract class DriveSettingsRepository {
  /// Fetches all drive settings.
  Future<List<DriveSettingsEntity>> getAll();

  /// Fetches global drive settings.
  Future<List<DriveSettingsEntity>> getGlobalSettings();

  /// Fetches per-node drive settings for a specific node.
  Future<List<DriveSettingsEntity>> getByNodeId(String nodeId);

  /// Saves or updates a drive setting.
  Future<int> upsert(DriveSettingsEntity setting);

  /// Deletes a drive setting by ID.
  Future<void> deleteSetting(int id);
}
