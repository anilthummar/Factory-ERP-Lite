import '../../../core/sync/sync_queue_item.dart';
import '../../../core/sync/sync_result.dart';
import 'sync_remote_data_source.dart';

/// Placeholder remote datasource used until Firebase module datasources exist.
class NoOpSyncRemoteDataSource implements SyncRemoteDataSource {
  /// Creates [NoOpSyncRemoteDataSource].
  const NoOpSyncRemoteDataSource();

  @override
  Future<SyncResult> push(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    return SyncFailure(
      queueItem: item,
      message: const SyncRemoteNotConfiguredException().message,
      isRetryable: true,
    );
  }
}
