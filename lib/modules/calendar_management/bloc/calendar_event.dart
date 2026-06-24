import 'package:equatable/equatable.dart';

/// Calendar BLoC events.
sealed class CalendarBlocEvent extends Equatable {
  const CalendarBlocEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads events for the visible calendar range.
final class CalendarLoadRequested extends CalendarBlocEvent {
  /// Creates [CalendarLoadRequested].
  const CalendarLoadRequested({
    required this.rangeStart,
    required this.rangeEnd,
  });

  /// Range start (inclusive).
  final DateTime rangeStart;

  /// Range end (inclusive).
  final DateTime rangeEnd;

  @override
  List<Object?> get props => <Object?>[rangeStart, rangeEnd];
}
