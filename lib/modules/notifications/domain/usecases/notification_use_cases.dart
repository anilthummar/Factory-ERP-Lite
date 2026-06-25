import '../../repository/notification_repository.dart';
import '../../service/notification_service.dart';
import '../models/notification_type.dart';
import '../models/scheduled_notification_item.dart';

/// Initializes local notifications and FCM handlers.
class InitializeNotificationsUseCase {
  /// Creates [InitializeNotificationsUseCase].
  const InitializeNotificationsUseCase(this._service);

  final NotificationService _service;

  /// Sets up flutter_local_notifications and FCM foreground delivery.
  Future<void> call() async {
    await _service.initLocalNotifications();
    await _service.initFcm();
  }
}

/// Rebuilds all scheduled reminders from repository data.
class RefreshScheduledRemindersUseCase {
  /// Creates [RefreshScheduledRemindersUseCase].
  const RefreshScheduledRemindersUseCase(
    this._service,
    this._repository,
  );

  final NotificationService _service;
  final NotificationRepository _repository;

  /// Cancels existing schedules and re-registers upcoming reminders.
  Future<int> call({int lookaheadDays = 14}) async {
    final List<ScheduledNotificationItem> items =
        await _repository.loadUpcomingReminders(
      lookaheadDays: lookaheadDays,
    );

    await _service.cancelAll();
    for (final ScheduledNotificationItem item in items) {
      await _service.schedule(item);
    }
    return items.length;
  }
}

/// Cancels a single scheduled notification.
class CancelNotificationUseCase {
  /// Creates [CancelNotificationUseCase].
  const CancelNotificationUseCase(this._service);

  final NotificationService _service;

  /// Cancels the notification with [notificationId].
  Future<void> call(int notificationId) => _service.cancel(notificationId);
}

/// Updates a scheduled notification (cancel + reschedule).
class UpdateNotificationUseCase {
  /// Creates [UpdateNotificationUseCase].
  const UpdateNotificationUseCase(this._service);

  final NotificationService _service;

  /// Replaces an existing scheduled reminder.
  Future<void> call(ScheduledNotificationItem item) =>
      _service.update(item);
}

/// Shows a local alert when sync queue items fail.
class ShowSyncFailureNotificationUseCase {
  /// Creates [ShowSyncFailureNotificationUseCase].
  const ShowSyncFailureNotificationUseCase(this._service);

  final NotificationService _service;

  /// Displays a sync failure notification for [failedCount] items.
  Future<void> call(int failedCount) {
    if (failedCount <= 0) {
      return Future<void>.value();
    }

    return _service.showNow(
      id: syncFailureNotificationId(failedCount),
      title: 'Sync Failed',
      body:
          '$failedCount item${failedCount == 1 ? '' : 's'} failed to sync. '
          'Open Sync Diagnostics to retry.',
      type: NotificationType.syncFailure,
    );
  }
}
