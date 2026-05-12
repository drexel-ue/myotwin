import 'package:shared_core/core.dart';

/// Data access interface for DriveSettings entities.
/// Manages global and per-node intensity/drive values.
abstract class DriveSettingsRepository {
  /// Fetches all drive settings.
  Future<List<DriveSettingsEntity>> getAll();

  /// Fetches global drive settings.
  Future<List<DriveSettingsEntity>> getGlobalSettings();

  /// Fetches per-node drive settings for the node identified by [nodeId].
  Future<List<DriveSettingsEntity>> getByNodeId(String nodeId);

  /// Inserts a new setting or updates an existing one.
  ///
  /// Returns the setting ID.
  Future<int> upsert(DriveSettingsEntity setting);

  /// Deletes the setting with the given [id].
  Future<void> deleteSetting(int id);
}
