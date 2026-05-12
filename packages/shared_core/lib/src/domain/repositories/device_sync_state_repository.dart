import 'package:shared_core/core.dart';

/// Data access interface for DeviceSyncState entities.
/// Tracks last-sync timestamps for multi-device synchronization.
abstract class DeviceSyncStateRepository {
  /// Fetches sync state for the device identified by [deviceId].
  ///
  /// Returns `null` if no state exists for the device.
  Future<DeviceSyncStateEntity?> getByDeviceId(String deviceId);

  /// Inserts a new sync state or updates an existing one.
  ///
  /// Returns the state's ID.
  Future<int> upsert(DeviceSyncStateEntity state);

  /// Deletes sync state for the device identified by [deviceId].
  Future<void> deleteState(String deviceId);
}
