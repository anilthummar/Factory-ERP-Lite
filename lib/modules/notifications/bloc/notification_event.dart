import 'package:equatable/equatable.dart';

import '../domain/models/scheduled_notification_item.dart';

/// Events for notification BLoC.
sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initializes notification channels and FCM.
final class NotificationInitializeRequested extends NotificationEvent {
  /// Creates [NotificationInitializeRequested].
  const NotificationInitializeRequested();
}

/// Reloads scheduled reminders from repository data.
final class NotificationRefreshRequested extends NotificationEvent {
  /// Creates [NotificationRefreshRequested].
  const NotificationRefreshRequested();
}

/// Cancels a scheduled notification.
final class NotificationCancelRequested extends NotificationEvent {
  /// Creates [NotificationCancelRequested].
  const NotificationCancelRequested(this.notificationId);

  /// Local notification id to cancel.
  final int notificationId;

  @override
  List<Object?> get props => <Object?>[notificationId];
}

/// Updates a scheduled notification.
final class NotificationUpdateRequested extends NotificationEvent {
  /// Creates [NotificationUpdateRequested].
  const NotificationUpdateRequested(this.item);

  /// Replacement reminder payload.
  final ScheduledNotificationItem item;

  @override
  List<Object?> get props => <Object?>[item];
}
