import 'package:equatable/equatable.dart';

import '../domain/entities/sync_diagnostics_data.dart';

/// Sync diagnostics screen status.
enum SyncDiagnosticsStatus {
  /// Initial state.
  initial,

  /// Loading diagnostics.
  loading,

  /// Diagnostics loaded.
  success,

  /// Retry in progress.
  retrying,

  /// Operation failed.
  failure,
}

/// Sync diagnostics BLoC state.
class SyncDiagnosticsState extends Equatable {
  /// Creates [SyncDiagnosticsState].
  const SyncDiagnosticsState({
    this.status = SyncDiagnosticsStatus.initial,
    this.data,
    this.errorMessage,
  });

  /// Current screen status.
  final SyncDiagnosticsStatus status;

  /// Loaded diagnostics snapshot.
  final SyncDiagnosticsData? data;

  /// Error message when [status] is [SyncDiagnosticsStatus.failure].
  final String? errorMessage;

  /// Returns a copy with selective overrides.
  SyncDiagnosticsState copyWith({
    SyncDiagnosticsStatus? status,
    SyncDiagnosticsData? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SyncDiagnosticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        data,
        errorMessage,
      ];
}
