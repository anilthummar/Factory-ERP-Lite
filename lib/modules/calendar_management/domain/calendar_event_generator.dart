import '../../../core/domain/enums/recurring_expense_frequency.dart';

/// Generates recurring expense occurrence dates for calendar views.
class CalendarEventGenerator {
  /// Creates [CalendarEventGenerator].
  const CalendarEventGenerator();

  /// Expands [frequency] occurrences between [startDate] and [rangeEnd].
  List<DateTime> recurringOccurrences({
    required DateTime startDate,
    required RecurringExpenseFrequency frequency,
    DateTime? endDate,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    final DateTime effectiveEnd = endDate ?? rangeEnd;
    final DateTime boundedEnd =
        effectiveEnd.isBefore(rangeEnd) ? effectiveEnd : rangeEnd;

    if (startDate.isAfter(boundedEnd)) {
      return <DateTime>[];
    }

    final List<DateTime> dates = <DateTime>[];
    DateTime cursor = _dateOnly(startDate);

    while (!cursor.isAfter(boundedEnd)) {
      if (!cursor.isBefore(_dateOnly(rangeStart))) {
        dates.add(cursor);
      }
      cursor = _nextOccurrence(cursor, frequency);
      if (dates.length > 500) {
        break;
      }
    }

    return dates;
  }

  DateTime _nextOccurrence(
    DateTime current,
    RecurringExpenseFrequency frequency,
  ) {
    switch (frequency) {
      case RecurringExpenseFrequency.daily:
        return current.add(const Duration(days: 1));
      case RecurringExpenseFrequency.weekly:
        return current.add(const Duration(days: 7));
      case RecurringExpenseFrequency.monthly:
        return DateTime(current.year, current.month + 1, current.day);
      case RecurringExpenseFrequency.yearly:
        return DateTime(current.year + 1, current.month, current.day);
    }
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
