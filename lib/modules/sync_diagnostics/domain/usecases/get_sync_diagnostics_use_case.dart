import '../../repository/sync_diagnostics_repository.dart';
import '../entities/sync_diagnostics_data.dart';

/// Loads sync diagnostics for the developer screen.
class GetSyncDiagnosticsUseCase {
  /// Creates [GetSyncDiagnosticsUseCase].
  const GetSyncDiagnosticsUseCase(this._repository);

  final SyncDiagnosticsRepository _repository;

  /// Returns the current diagnostics snapshot.
  Future<SyncDiagnosticsData> call() => _repository.loadDiagnostics();
}
