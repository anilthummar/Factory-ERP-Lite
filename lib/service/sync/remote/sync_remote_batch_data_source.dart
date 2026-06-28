import '../../../core/sync/sync_result.dart';
import 'sync_remote_data_source.dart';
import 'sync_remote_push_request.dart';

/// Optional batch extension for [SyncRemoteDataSource] implementations.
abstract class SyncRemoteBatchDataSource implements SyncRemoteDataSource {
  /// Pushes multiple queue items using a Firestore batch write.
  Future<List<SyncResult>> pushBatch(List<SyncRemotePushRequest> requests);
}
