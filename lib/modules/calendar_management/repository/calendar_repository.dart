import '../ui/widget/calendar_event_type.dart';

/// Contract for aggregating calendar events from local Hive data.
abstract class CalendarRepository {
  /// Loads calendar events between [rangeStart] and [rangeEnd].
  Future<List<CalendarEventData>> loadEvents({
    required DateTime rangeStart,
    required DateTime rangeEnd,
  });
}
