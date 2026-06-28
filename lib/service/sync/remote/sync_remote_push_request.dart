import '../../../core/sync/sync_queue_item.dart';

/// A single remote sync push request for batch operations.
class SyncRemotePushRequest {
  /// Creates [SyncRemotePushRequest].
  const SyncRemotePushRequest({
    required this.item,
    required this.payload,
  });

  /// Queue item to push.
  final SyncQueueItem item;

  /// Local Hive payload to write remotely.
  final Map<String, dynamic> payload;
}
