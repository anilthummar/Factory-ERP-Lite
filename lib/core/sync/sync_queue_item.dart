import 'package:equatable/equatable.dart';

import '../enums/sync_status.dart';
import 'sync_module_type.dart';
import 'sync_operation.dart';
import 'sync_queue_keys.dart';

/// Lifecycle state of an item in the Hive sync queue.
enum SyncQueueItemStatus {
  /// Waiting to be processed.
  pending,

  /// Currently being pushed to the remote store.
  processing,

  /// Permanently failed after max retry attempts.
  deadLetter,

  /// Eligible for retry after a failed attempt.
  failed,
}

/// Offline sync queue entry persisted in Hive.
class SyncQueueItem extends Equatable {
  /// Creates [SyncQueueItem].
  const SyncQueueItem({
    required this.queueId,
    required this.module,
    required this.recordId,
    required this.operation,
    required this.status,
    required this.attemptCount,
    required this.createdAt,
    required this.updatedAt,
    this.lastError,
    this.factoryId,
  });

  /// Builds a new queue item for a local mutation.
  factory SyncQueueItem.forMutation({
    required String queueId,
    required SyncModuleType module,
    required String recordId,
    required SyncOperation operation,
    String? factoryId,
  }) {
    final DateTime now = DateTime.now();
    return SyncQueueItem(
      queueId: queueId,
      module: module,
      recordId: recordId,
      operation: operation,
      status: SyncQueueItemStatus.pending,
      attemptCount: 0,
      createdAt: now,
      updatedAt: now,
      factoryId: factoryId,
    );
  }

  /// Restores a queue item from a Hive map.
  factory SyncQueueItem.fromMap(Map<dynamic, dynamic> map) {
    return SyncQueueItem(
      queueId: map[SyncQueueKeys.queueId] as String,
      module: syncModuleTypeFromString(map[SyncQueueKeys.module] as String?),
      recordId: map[SyncQueueKeys.recordId] as String,
      operation: syncOperationFromString(map[SyncQueueKeys.operation] as String?),
      status: _queueStatusFromString(map[SyncQueueKeys.status] as String?),
      attemptCount: map[SyncQueueKeys.attemptCount] as int? ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[SyncQueueKeys.createdAtMs] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map[SyncQueueKeys.updatedAtMs] as int,
      ),
      lastError: map[SyncQueueKeys.lastError] as String?,
      factoryId: map[SyncQueueKeys.factoryId] as String?,
    );
  }

  /// Unique queue entry identifier.
  final String queueId;

  /// ERP module that owns [recordId].
  final SyncModuleType module;

  /// Local record identifier to sync.
  final String recordId;

  /// Mutation type to apply remotely.
  final SyncOperation operation;

  /// Queue item processing state.
  final SyncQueueItemStatus status;

  /// Number of sync attempts made for this queue item.
  final int attemptCount;

  /// When the queue item was created.
  final DateTime createdAt;

  /// When the queue item was last updated.
  final DateTime updatedAt;

  /// Last remote sync error message, if any.
  final String? lastError;

  /// Optional factory scope for multi-factory deployments.
  final String? factoryId;

  /// Whether this queue item can be retried.
  bool get canRetry =>
      status == SyncQueueItemStatus.pending ||
      status == SyncQueueItemStatus.failed;

  /// Converts this item to a Hive map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      SyncQueueKeys.queueId: queueId,
      SyncQueueKeys.module: syncModuleTypeToString(module),
      SyncQueueKeys.recordId: recordId,
      SyncQueueKeys.operation: syncOperationToString(operation),
      SyncQueueKeys.status: status.name,
      SyncQueueKeys.attemptCount: attemptCount,
      SyncQueueKeys.createdAtMs: createdAt.millisecondsSinceEpoch,
      SyncQueueKeys.updatedAtMs: updatedAt.millisecondsSinceEpoch,
      if (lastError != null) SyncQueueKeys.lastError: lastError,
      if (factoryId != null) SyncQueueKeys.factoryId: factoryId,
    };
  }

  /// Returns a copy with selective overrides.
  SyncQueueItem copyWith({
    SyncQueueItemStatus? status,
    int? attemptCount,
    DateTime? updatedAt,
    String? lastError,
    bool clearLastError = false,
  }) {
    return SyncQueueItem(
      queueId: queueId,
      module: module,
      recordId: recordId,
      operation: operation,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastError: clearLastError ? null : lastError ?? this.lastError,
      factoryId: factoryId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        queueId,
        module,
        recordId,
        operation,
        status,
        attemptCount,
        createdAt,
        updatedAt,
        lastError,
        factoryId,
      ];
}

SyncQueueItemStatus _queueStatusFromString(String? value) {
  return SyncQueueItemStatus.values.firstWhere(
    (SyncQueueItemStatus status) => status.name == value,
    orElse: () => SyncQueueItemStatus.pending,
  );
}

/// Maps a successful remote sync to entity [SyncStatus].
SyncStatus syncStatusAfterSuccess(SyncQueueItem item) => SyncStatus.synced;

/// Maps a failed remote sync to entity [SyncStatus].
SyncStatus syncStatusAfterFailure(SyncQueueItem item) => SyncStatus.failed;
