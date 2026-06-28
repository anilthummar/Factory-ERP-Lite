/// Factory notification categories.
enum NotificationType {
  /// Recurring expense due reminder.
  recurringExpense,

  /// Maintenance expense reminder.
  maintenance,

  /// Calendar / factory event reminder.
  calendarEvent,

  /// Offline sync failure alert.
  syncFailure,
}

/// Stable local notification id for [type] and [sourceId].
int notificationIdFor(NotificationType type, String sourceId) {
  return Object.hash(type.name, sourceId);
}

/// ID reserved for immediate sync-failure alerts.
int syncFailureNotificationId(int failedCount) {
  return Object.hash(NotificationType.syncFailure.name, failedCount);
}
