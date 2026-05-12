/// Domain entity: Device sync state for multi-device synchronization.
class DeviceSyncStateEntity {
  const DeviceSyncStateEntity({
    this.id,
    required this.deviceId,
    required this.lastSyncTimestamp,
    required this.direction,
    required this.createdAt,
    required this.updatedAt,
  });

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
  final int? id;
  final String deviceId;
  final DateTime lastSyncTimestamp;
  final String direction; // push, pull, bidirectional
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'lastSyncTimestamp': lastSyncTimestamp,
      'direction': direction,
    };
  }
}
