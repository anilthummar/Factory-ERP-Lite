import '../../repository/calendar_repository.dart';
import '../../ui/widget/calendar_event_type.dart';

/// Loads calendar events for a date range from local Hive repositories.
class GetCalendarEventsUseCase {
  /// Creates [GetCalendarEventsUseCase].
  const GetCalendarEventsUseCase(this._repository);

  final CalendarRepository _repository;

  /// Returns events between [rangeStart] and [rangeEnd].
  Future<List<CalendarEventData>> call({
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    return _repository.loadEvents(
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
  }
}
