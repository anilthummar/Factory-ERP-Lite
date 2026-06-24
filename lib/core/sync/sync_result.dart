import 'package:equatable/equatable.dart';

import 'sync_queue_item.dart';

/// Result of attempting to push a queue item to the remote store.
sealed class SyncResult extends Equatable {
  const SyncResult({required this.queueItem});

  /// Queue item that was processed.
  final SyncQueueItem queueItem;

  @override
  List<Object?> get props => <Object?>[queueItem];
}

/// Remote sync completed successfully.
final class SyncSuccess extends SyncResult {
  /// Creates [SyncSuccess].
  const SyncSuccess({required super.queueItem});
}

/// Remote sync failed and may be retried.
final class SyncFailure extends SyncResult {
  /// Creates [SyncFailure].
  const SyncFailure({
    required super.queueItem,
    required this.message,
    this.isRetryable = true,
  });

  /// Human-readable failure description.
  final String message;

  /// Whether the sync engine should schedule another attempt.
  final bool isRetryable;

  @override
  List<Object?> get props => <Object?>[queueItem, message, isRetryable];
}

/// Local and remote versions of the same record differ.
final class SyncConflict extends SyncResult {
  /// Creates [SyncConflict].
  const SyncConflict({
    required super.queueItem,
    required this.localPayload,
    required this.remotePayload,
  });

  /// Local Hive payload.
  final Map<String, dynamic> localPayload;

  /// Remote Firestore payload.
  final Map<String, dynamic> remotePayload;

  @override
  List<Object?> get props => <Object?>[queueItem, localPayload, remotePayload];
}
