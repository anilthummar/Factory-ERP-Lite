import '../domain/models/scheduled_notification_item.dart';

/// Loads upcoming reminders and tracks scheduled notification metadata.
abstract class NotificationRepository {
  /// Returns reminders to schedule within the lookahead window.
  Future<List<ScheduledNotificationItem>> loadUpcomingReminders({
    int lookaheadDays = 14,
  });
}
