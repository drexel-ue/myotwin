/// Global or per-node intensity rule for the MyoTwin drive mode.
///
/// Tells the coaching engine how strongly to apply research-backed
/// biomechanical adjustments across segments or a single node.
class DriveSettingsEntity {
  /// Creates a drive settings record.
  const DriveSettingsEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// Config name (e.g. "intensity", "cadence").
    required this.settingName,

    /// Numeric setting value.
    required this.value,

    /// Scope: "global" or "per-node".
    required this.scope,

    /// Target node ID (null when scope is global).
    this.nodeId,

    /// Timestamp when the setting was first created.
    required this.createdAt,

    /// Timestamp of the most recent update.
    required this.updatedAt,
  });

  /// Constructs a [DriveSettingsEntity] from a database row map.
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

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// Config name (e.g. "intensity", "cadence").
  final String settingName;

  /// Numeric setting value.
  final double value;

  /// Scope: "global" or "per-node".
  final String scope;

  /// Target node ID (null when scope is global).
  final String? nodeId;

  /// Timestamp when the setting was first created.
  final DateTime createdAt;

  /// Timestamp of the most recent update.
  final DateTime updatedAt;

  /// Exports the entity to a database row map for persistence.
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
