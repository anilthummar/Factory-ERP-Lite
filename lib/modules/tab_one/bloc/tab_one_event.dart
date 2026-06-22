import '../../../utils/exports.dart';

/// Base event for tab one.
sealed class TabOneEvent extends Equatable {
  /// Creates a tab one event.
  const TabOneEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event to fetch user details.
class TabOneFetchRequested extends TabOneEvent {
  /// Creates fetch request event.
  const TabOneFetchRequested();
}
