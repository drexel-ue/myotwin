/// Notification context with deep-link UUID for MyoTwin alerts.
///
/// Carries the deep-link and delay so the app resumes the correct
/// local coaching or research flow when the user taps the alert.
class NotificationContextEntity {
  /// Creates a notification context record.
  const NotificationContextEntity({
    /// Unique database ID, null for unsaved entities.
    this.id,

    /// UUID for this notification.
    required this.uuid,

    /// Notification title text.
    required this.title,

    /// Notification body text.
    required this.body,

    /// Deep-link string to open on tap.
    required this.deepLink,

    /// Delay before dispatch in minutes.
    required this.delayMinutes,

    /// UUID of the context this alert belongs to.
    required this.contextUuid,

    /// Status: pending, sent, dismissed, etc.
    this.status = 'pending',

    /// When the notification was scheduled.
    this.scheduledAt,

    /// Timestamp when inserted into the database.
    required this.createdAt,
  });

  /// Constructs a [NotificationContextEntity] from a database row map.
  factory NotificationContextEntity.fromDb(Map<String, dynamic> row) {
    return NotificationContextEntity(
      id: row['id'] as int,
      uuid: row['uuid'] as String,
      title: row['title'] as String,
      body: row['body'] as String,
      deepLink: row['deepLink'] as String,
      delayMinutes: row['delayMinutes'] as int,
      contextUuid: row['contextUuid'] as String,
      status: row['status'] as String,
      scheduledAt: row['scheduledAt'] as DateTime?,
      createdAt: row['createdAt'] as DateTime,
    );
  }

  /// Unique database ID. Null before the entity is persisted.
  final int? id;

  /// UUID for this notification.
  final String uuid;

  /// Notification title text.
  final String title;

  /// Notification body text.
  final String body;

  /// Deep-link string to open on tap.
  final String deepLink;

  /// Delay before notification dispatch in minutes.
  final int delayMinutes;

  /// UUID of the context this alert belongs to.
  final String contextUuid;

  /// Status: pending, sent, dismissed, etc.
  final String status;

  /// When the notification was scheduled (null if unscheduled).
  final DateTime? scheduledAt;

  /// Timestamp when inserted into the database.
  final DateTime createdAt;

  /// Exports the entity to a database row map for persistence.
  Map<String, dynamic> toDb() {
    return {
      if (id != null) 'id': id,
      'uuid': uuid,
      'title': title,
      'body': body,
      'deepLink': deepLink,
      'delayMinutes': delayMinutes,
      'contextUuid': contextUuid,
      'status': status,
      'scheduledAt': scheduledAt,
    };
  }
}
