import '../../../core/sync/sync_queue_item.dart';
import '../../../core/sync/sync_result.dart';

/// Contract for pushing queued local mutations to the remote store.
///
/// Firebase-backed implementations are added in the Firebase datasource phase.
abstract class SyncRemoteDataSource {
  /// Pushes [item] payload to the configured remote collection.
  Future<SyncResult> push(SyncQueueItem item, Map<String, dynamic> payload);
}

/// Thrown when no remote datasource has been registered for sync.
class SyncRemoteNotConfiguredException implements Exception {
  /// Creates [SyncRemoteNotConfiguredException].
  const SyncRemoteNotConfiguredException([
    this.message = 'Remote sync datasource is not configured yet.',
  ]);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'SyncRemoteNotConfiguredException: $message';
}
