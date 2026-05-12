import 'package:shared_core/core.dart';

/// Repository interface for NotificationContext data access.
/// Manages notification payloads with deep-link UUIDs.
abstract class NotificationContextRepository {
  /// Fetches all pending notifications.
  Future<List<NotificationContextEntity>> getPending();

  /// Fetches all notifications.
  Future<List<NotificationContextEntity>> getAll();

  /// Fetches a notification by its UUID.
  Future<NotificationContextEntity?> getByUuid(String uuid);

  /// Schedules a notification with delay.
  Future<String> schedule({
    required String title,
    required String body,
    required String contextUuid,
    required int delayMinutes,
    required String deepLink,
  });

  /// Marks a notification as read.
  Future<void> markAsRead(String uuid);

  /// Deletes a notification by UUID.
  Future<void> deleteByUuid(String uuid);
}
