/// Synchronization state between two local devices in MyoTwin.
///
/// Ensures data stays consistent across paired devices in the
/// local-only privacy-first architecture via push/pull/bi-dir sync.
class DeviceSyncStateEntity {
  /// Creates a device sync state record.
  const DeviceSyncStateEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Peer device identifier.
    required this.deviceId,

    /// Timestamp of the most recent sync event.
    required this.lastSyncTimestamp,

    /// Sync direction: push, pull, or bidirectional.
    required this.direction,

    /// Timestamp when the sync record was first created.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [DeviceSyncStateEntity] from a database row map.
  factory DeviceSyncStateEntity.fromDb(Map<String, dynamic> row) {
    return DeviceSyncStateEntity(
      id: row['id'] as int,
      deviceId: row['deviceId'] as String,
      lastSyncTimestamp: row['lastSyncTimestamp'] as DateTime,
      direction: row['direction'] as String,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Peer device identifier (e.g. UUID).
  final String deviceId;

  /// Timestamp of the most recent sync event.
  final DateTime lastSyncTimestamp;

  /// Sync direction: push, pull, or bidirectional.
  final String direction;

  /// Timestamp when the sync record was first created.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'lastSyncTimestamp': lastSyncTimestamp,
      'direction': direction,
    };
  }
}
