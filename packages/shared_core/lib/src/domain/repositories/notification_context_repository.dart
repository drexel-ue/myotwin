import 'package:shared_core/core.dart';

/// Data access interface for NotificationContext entities.
/// Manages notification payloads with deep-link UUIDs.
abstract class NotificationContextRepository {
  /// Fetches all pending (unread) notifications.
  Future<List<NotificationContextEntity>> getPending();

  /// Fetches all notifications regardless of read status.
  Future<List<NotificationContextEntity>> getAll();

  /// Fetches a notification by its [uuid].
  ///
  /// Returns `null` if no notification with the given UUID exists.
  Future<NotificationContextEntity?> getByUuid(String uuid);

  /// Schedules a notification to be delivered after [delayMinutes].
  ///
  /// [title] is the notification title. [body] is the message body.
  /// [contextUuid] associates context data. [deepLink] is the target URI.
  /// Returns the scheduled notification UUID.
  Future<String> schedule({
    required String title,
    required String body,
    required String contextUuid,
    required int delayMinutes,
    required String deepLink,
  });

  /// Marks the notification with the given [uuid] as read.
  Future<void> markAsRead(String uuid);

  /// Deletes the notification with the given [uuid].
  Future<void> deleteByUuid(String uuid);
}
