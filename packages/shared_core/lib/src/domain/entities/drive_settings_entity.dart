/// Domain entity: Drive settings for global or per-node intensity.
class DriveSettingsEntity {
  const DriveSettingsEntity({
    this.id,
    required this.settingName,
    required this.value,
    required this.scope,
    this.nodeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriveSettingsEntity.fromDb(Map<String, dynamic> row) {
    return DriveSettingsEntity(
      id: row['id'] as int,
      settingName: row['settingName'] as String,
      value: (row['value'] as num).toDouble(),
      scope: row['scope'] as String,
      nodeId: row['nodeId'] as String?,
      createdAt: row['createdAt'] as DateTime,
      updatedAt: row['updatedAt'] as DateTime,
    );
  }
  final int? id;
  final String settingName;
  final double value;
  final String scope; // global, per-node
  final String? nodeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'settingName': settingName,
      'value': value,
      'scope': scope,
      'nodeId': nodeId,
    };
  }
}
