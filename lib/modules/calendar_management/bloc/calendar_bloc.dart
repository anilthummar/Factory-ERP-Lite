import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_calendar_events_use_case.dart';
import '../ui/widget/calendar_event_type.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

/// BLoC for factory calendar events.
class CalendarBloc extends Bloc<CalendarBlocEvent, CalendarBlocState> {
  /// Creates [CalendarBloc].
  CalendarBloc({
    required GetCalendarEventsUseCase getCalendarEventsUseCase,
  })  : _getCalendarEventsUseCase = getCalendarEventsUseCase,
        super(const CalendarBlocState()) {
    on<CalendarLoadRequested>(_onLoad);
  }

  final GetCalendarEventsUseCase _getCalendarEventsUseCase;

  Future<void> _onLoad(
    CalendarLoadRequested event,
    Emitter<CalendarBlocState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CalendarBlocStatus.loading,
        clearError: true,
      ),
    );

    try {
      final List<CalendarEventData> events = await _getCalendarEventsUseCase(
        rangeStart: event.rangeStart,
        rangeEnd: event.rangeEnd,
      );
      emit(
        state.copyWith(
          status: CalendarBlocStatus.success,
          events: events,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: CalendarBlocStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
