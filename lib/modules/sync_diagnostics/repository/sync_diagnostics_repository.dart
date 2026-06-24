import '../domain/entities/sync_diagnostics_data.dart';

/// Contract for loading sync diagnostics metrics.
abstract class SyncDiagnosticsRepository {
  /// Loads current sync queue and connectivity diagnostics.
  Future<SyncDiagnosticsData> loadDiagnostics();

  /// Triggers a manual sync retry for pending and failed queue items.
  Future<void> retrySync();
}
