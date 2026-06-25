import '../../../modules/calendar_management/domain/usecases/get_calendar_events_use_case.dart';
import '../../../modules/calendar_management/ui/widget/calendar_event_type.dart';
import '../domain/models/notification_type.dart';
import '../domain/models/scheduled_notification_item.dart';
import 'notification_repository.dart';

/// Calendar-backed implementation of [NotificationRepository].
class NotificationRepositoryImpl implements NotificationRepository {
  /// Creates [NotificationRepositoryImpl].
  NotificationRepositoryImpl({
    required GetCalendarEventsUseCase getCalendarEventsUseCase,
  }) : _getCalendarEventsUseCase = getCalendarEventsUseCase;

  final GetCalendarEventsUseCase _getCalendarEventsUseCase;

  @override
  Future<List<ScheduledNotificationItem>> loadUpcomingReminders({
    int lookaheadDays = 14,
  }) async {
    final DateTime today = DateTime.now();
    final DateTime rangeStart = DateTime(today.year, today.month, today.day);
    final DateTime rangeEnd = rangeStart.add(Duration(days: lookaheadDays));

    final List<CalendarEventData> events = await _getCalendarEventsUseCase(
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );

    final List<ScheduledNotificationItem> reminders =
        <ScheduledNotificationItem>[];

    for (final CalendarEventData event in events) {
      final NotificationType? type = _mapEventType(event.type);
      if (type == null) {
        continue;
      }

      final DateTime scheduledAt = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        9,
      );

      reminders.add(
        ScheduledNotificationItem(
          id: notificationIdFor(type, event.id),
          type: type,
          title: _titleFor(type),
          body: event.title,
          scheduledAt: scheduledAt,
          sourceId: event.id,
        ),
      );
    }

    return reminders;
  }

  NotificationType? _mapEventType(CalendarEventType type) {
    return switch (type) {
      CalendarEventType.recurringExpense =>
        NotificationType.recurringExpense,
      CalendarEventType.maintenanceReminder => NotificationType.maintenance,
      CalendarEventType.factoryEvent => NotificationType.calendarEvent,
      CalendarEventType.holiday => null,
    };
  }

  String _titleFor(NotificationType type) {
    return switch (type) {
      NotificationType.recurringExpense => 'Recurring Expense Reminder',
      NotificationType.maintenance => 'Maintenance Reminder',
      NotificationType.calendarEvent => 'Calendar Event Reminder',
      NotificationType.syncFailure => 'Sync Failed',
    };
  }
}
