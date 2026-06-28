import '../../repository/sync_diagnostics_repository.dart';

/// Triggers a manual sync retry from the diagnostics screen.
class RetrySyncUseCase {
  /// Creates [RetrySyncUseCase].
  const RetrySyncUseCase(this._repository);

  final SyncDiagnosticsRepository _repository;

  /// Processes pending and retry-eligible failed queue items.
  Future<void> call() => _repository.retrySync();
}
