import 'package:equatable/equatable.dart';

/// Dashboard BLoC events.
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads dashboard metrics from local repositories.
final class DashboardLoadRequested extends DashboardEvent {
  /// Creates [DashboardLoadRequested].
  const DashboardLoadRequested();
}

/// Refreshes dashboard metrics.
final class DashboardRefreshRequested extends DashboardEvent {
  /// Creates [DashboardRefreshRequested].
  const DashboardRefreshRequested();
}
