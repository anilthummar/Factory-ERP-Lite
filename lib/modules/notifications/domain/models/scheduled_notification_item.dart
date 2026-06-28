import 'notification_type.dart';

/// A reminder to be scheduled as a local notification.
class ScheduledNotificationItem {
  /// Creates [ScheduledNotificationItem].
  const ScheduledNotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.scheduledAt,
    required this.sourceId,
  });

  /// Stable notification id for cancel/update.
  final int id;

  /// Reminder category.
  final NotificationType type;

  /// Notification title.
  final String title;

  /// Notification body.
  final String body;

  /// When the reminder should fire.
  final DateTime scheduledAt;

  /// Source record id (calendar event, etc.).
  final String sourceId;
}
