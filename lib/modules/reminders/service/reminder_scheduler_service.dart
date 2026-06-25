import '../../../modules/calendar_management/domain/usecases/get_calendar_events_use_case.dart';
import '../../../modules/calendar_management/ui/widget/calendar_event_type.dart';
import '../domain/models/reminder_type.dart';
import 'flutter_local_notification_service.dart';

/// Schedules upcoming factory reminders as local notifications.
class ReminderSchedulerService {
  /// Creates [ReminderSchedulerService].
  ReminderSchedulerService({
    required FlutterLocalNotificationService notificationService,
    required GetCalendarEventsUseCase getCalendarEventsUseCase,
  })  : _notificationService = notificationService,
        _getCalendarEventsUseCase = getCalendarEventsUseCase;

  final FlutterLocalNotificationService _notificationService;
  final GetCalendarEventsUseCase _getCalendarEventsUseCase;

  static const int _lookaheadDays = 14;

  /// Refreshes scheduled reminders for the next [_lookaheadDays] days.
  Future<void> refreshScheduledReminders() async {
    await _notificationService.cancelAll();

    final DateTime today = DateTime.now();
    final DateTime rangeStart = DateTime(today.year, today.month, today.day);
    final DateTime rangeEnd = rangeStart.add(
      const Duration(days: _lookaheadDays),
    );

    final List<CalendarEventData> events =
        await _getCalendarEventsUseCase(
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );

    for (final CalendarEventData event in events) {
      final ReminderType? type = _mapEventType(event.type);
      if (type == null) {
        continue;
      }

      final DateTime reminderAt = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        9,
      );

      await _notificationService.schedule(
        id: event.id.hashCode,
        title: _titleFor(type),
        body: event.title,
        scheduledDate: reminderAt,
        type: type,
      );
    }
  }

  ReminderType? _mapEventType(CalendarEventType type) {
    return switch (type) {
      CalendarEventType.recurringExpense => ReminderType.recurringExpense,
      CalendarEventType.maintenanceReminder => ReminderType.maintenance,
      CalendarEventType.factoryEvent => ReminderType.calendarEvent,
      CalendarEventType.holiday => null,
    };
  }

  String _titleFor(ReminderType type) {
    return switch (type) {
      ReminderType.recurringExpense => 'Recurring Expense Reminder',
      ReminderType.maintenance => 'Maintenance Reminder',
      ReminderType.calendarEvent => 'Factory Event Reminder',
      ReminderType.syncFailed => 'Sync Failed',
    };
  }
}
