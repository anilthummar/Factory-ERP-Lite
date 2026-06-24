import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/dashboard_data.dart';

/// Dashboard loading status.
enum DashboardStatus {
  /// Initial state before first load.
  initial,

  /// Loading dashboard metrics.
  loading,

  /// Dashboard data loaded successfully.
  success,

  /// Failed to load dashboard metrics.
  failure,
}

/// Dashboard BLoC state.
class DashboardState extends Equatable {
  /// Creates [DashboardState].
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.data,
    this.errorMessage,
  });

  /// Current loading status.
  final DashboardStatus status;

  /// Loaded dashboard metrics.
  final DashboardData? data;

  /// Error message when [status] is [DashboardStatus.failure].
  final String? errorMessage;

  /// Returns a copy with selective overrides.
  DashboardState copyWith({
    DashboardStatus? status,
    DashboardData? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, data, errorMessage];
}
