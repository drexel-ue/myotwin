/// Domain entity: Notification context with deep-link UUID.
class NotificationContextEntity {
  const NotificationContextEntity({
    this.id,
    required this.uuid,
    required this.title,
    required this.body,
    required this.deepLink,
    required this.delayMinutes,
    required this.contextUuid,
    this.status = 'pending',
    this.scheduledAt,
    required this.createdAt,
  });

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
  final int? id;
  final String uuid;
  final String title;
  final String body;
  final String deepLink;
  final int delayMinutes;
  final String contextUuid;
  final String status;
  final DateTime? scheduledAt;
  final DateTime createdAt;

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
