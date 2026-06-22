import '../../../utils/exports.dart';

/// Base event for custom pagination.
sealed class CustomPaginationEvent extends Equatable {
  /// Creates a custom pagination event.
  const CustomPaginationEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Triggered when initial fetch is required.
class CustomPaginationInitialFetchRequested extends CustomPaginationEvent {
  /// Creates initial fetch event.
  const CustomPaginationInitialFetchRequested();
}

/// Triggered when list reaches end and needs load-more.
class CustomPaginationLoadMoreRequested extends CustomPaginationEvent {
  /// Creates load more event.
  const CustomPaginationLoadMoreRequested();
}

/// Triggered on pull-to-refresh.
class CustomPaginationRefreshRequested extends CustomPaginationEvent {
  /// Creates refresh event.
  const CustomPaginationRefreshRequested();
}
