import '../../domain/models/reminder_type.dart';
import '../../service/flutter_local_notification_service.dart';

/// Shows a local notification when sync queue items fail.
class ShowSyncFailedNotificationUseCase {
  /// Creates [ShowSyncFailedNotificationUseCase].
  const ShowSyncFailedNotificationUseCase(this._notificationService);

  final FlutterLocalNotificationService _notificationService;

  /// Displays a sync failure notification for [failedCount] items.
  Future<void> call(int failedCount) {
    if (failedCount <= 0) {
      return Future<void>.value();
    }

    return _notificationService.showNow(
      id: ReminderType.syncFailed.index,
      title: 'Sync Failed',
      body:
          '$failedCount item${failedCount == 1 ? '' : 's'} failed to sync. '
          'Open Sync Diagnostics to retry.',
      type: ReminderType.syncFailed,
    );
  }
}
