import 'package:shared_core/core.dart';

/// Repository interface for DeviceSyncState data access.
/// Tracks last-sync timestamps for multi-device sync.
abstract class DeviceSyncStateRepository {
  /// Fetches sync state for a specific device.
  Future<DeviceSyncStateEntity?> getByDeviceId(String deviceId);

  /// Saves or updates device sync state.
  Future<int> upsert(DeviceSyncStateEntity state);

  /// Deletes sync state for a device.
  Future<void> deleteState(String deviceId);
}
