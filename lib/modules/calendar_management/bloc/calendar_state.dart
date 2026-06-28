import 'package:equatable/equatable.dart';

import '../ui/widget/calendar_event_type.dart';

/// Calendar BLoC loading status.
enum CalendarBlocStatus {
  /// Initial state.
  initial,

  /// Loading events.
  loading,

  /// Events loaded successfully.
  success,

  /// Failed to load events.
  failure,
}

/// Calendar BLoC state.
class CalendarBlocState extends Equatable {
  /// Creates [CalendarBlocState].
  const CalendarBlocState({
    this.status = CalendarBlocStatus.initial,
    this.events = const <CalendarEventData>[],
    this.errorMessage,
  });

  /// Current loading status.
  final CalendarBlocStatus status;

  /// Loaded calendar events.
  final List<CalendarEventData> events;

  /// Error message when [status] is [CalendarBlocStatus.failure].
  final String? errorMessage;

  /// Returns a copy with selective overrides.
  CalendarBlocState copyWith({
    CalendarBlocStatus? status,
    List<CalendarEventData>? events,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CalendarBlocState(
      status: status ?? this.status,
      events: events ?? this.events,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, events, errorMessage];
}
