import '../../../../utils/exports.dart';

/// Calendar event categories (UI only).
enum CalendarEventType {
  /// Recurring expense due date.
  recurringExpense,

  /// Factory-wide event.
  factoryEvent,

  /// Maintenance reminder.
  maintenanceReminder,

  /// Holiday.
  holiday,
}

/// Localized labels and styling for [CalendarEventType].
extension CalendarEventTypeUi on CalendarEventType {
  /// Localized type label.
  String label(AppString strings) {
    switch (this) {
      case CalendarEventType.recurringExpense:
        return strings.calendarEventRecurringExpenseKey;
      case CalendarEventType.factoryEvent:
        return strings.calendarEventFactoryEventKey;
      case CalendarEventType.maintenanceReminder:
        return strings.calendarEventMaintenanceReminderKey;
      case CalendarEventType.holiday:
        return strings.calendarEventHolidayKey;
    }
  }

  /// Type icon for list cards and indicators.
  IconData get icon {
    switch (this) {
      case CalendarEventType.recurringExpense:
        return Icons.autorenew;
      case CalendarEventType.factoryEvent:
        return Icons.factory_outlined;
      case CalendarEventType.maintenanceReminder:
        return Icons.build_outlined;
      case CalendarEventType.holiday:
        return Icons.celebration_outlined;
    }
  }

  /// Indicator / accent color for this event type.
  Color color(ColorScheme colorScheme) {
    switch (this) {
      case CalendarEventType.recurringExpense:
        return colorScheme.tertiary;
      case CalendarEventType.factoryEvent:
        return colorScheme.primary;
      case CalendarEventType.maintenanceReminder:
        return colorScheme.secondary;
      case CalendarEventType.holiday:
        return colorScheme.error;
    }
  }
}

/// Calendar layout mode.
enum CalendarViewMode {
  /// Monthly grid view.
  month,

  /// Chronological list view.
  agenda,
}

/// Display data for a calendar event (UI only).
class CalendarEventData {
  /// Creates [CalendarEventData].
  const CalendarEventData({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.onTap,
  });

  /// Unique event identifier.
  final String id;

  /// Event title.
  final String title;

  /// Event date (time ignored for display).
  final DateTime date;

  /// Event category.
  final CalendarEventType type;

  /// Card tap callback placeholder.
  final VoidCallback? onTap;
}

/// Date helpers for calendar UI.
DateTime calendarDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Whether two dates fall on the same calendar day.
bool calendarIsSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Events occurring on [date].
List<CalendarEventData> calendarEventsForDate(
  List<CalendarEventData> events,
  DateTime date,
) {
  return events
      .where(
        (CalendarEventData event) =>
            calendarIsSameDay(event.date, date),
      )
      .toList();
}

/// Events in the same month as [month].
List<CalendarEventData> calendarEventsForMonth(
  List<CalendarEventData> events,
  DateTime month,
) {
  return events
      .where(
        (CalendarEventData event) =>
            event.date.year == month.year && event.date.month == month.month,
      )
      .toList()
    ..sort(
      (CalendarEventData a, CalendarEventData b) => a.date.compareTo(b.date),
    );
}

/// Distinct event types on [date] for month-grid indicators.
List<CalendarEventType> calendarEventTypesForDate(
  List<CalendarEventData> events,
  DateTime date,
) {
  final List<CalendarEventType> types = <CalendarEventType>[];
  for (final CalendarEventData event in calendarEventsForDate(events, date)) {
    if (!types.contains(event.type)) {
      types.add(event.type);
    }
  }
  return types;
}
