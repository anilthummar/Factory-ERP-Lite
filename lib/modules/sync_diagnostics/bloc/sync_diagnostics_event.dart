import 'package:equatable/equatable.dart';

/// Sync diagnostics BLoC events.
sealed class SyncDiagnosticsEvent extends Equatable {
  const SyncDiagnosticsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads sync diagnostics metrics.
final class SyncDiagnosticsLoadRequested extends SyncDiagnosticsEvent {
  /// Creates [SyncDiagnosticsLoadRequested].
  const SyncDiagnosticsLoadRequested();
}

/// Retries pending and failed sync queue items.
final class SyncDiagnosticsRetryRequested extends SyncDiagnosticsEvent {
  /// Creates [SyncDiagnosticsRetryRequested].
  const SyncDiagnosticsRetryRequested();
}
