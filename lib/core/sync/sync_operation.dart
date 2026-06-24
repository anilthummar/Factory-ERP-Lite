/// Mutation type enqueued for remote sync.
enum SyncOperation {
  /// Record was created locally.
  create,

  /// Record was updated locally.
  update,

  /// Record was deleted locally.
  delete,
}

/// Parses [SyncOperation] from persisted queue values.
SyncOperation syncOperationFromString(String? value) {
  return SyncOperation.values.firstWhere(
    (SyncOperation operation) => operation.name == value,
    orElse: () => SyncOperation.create,
  );
}

/// Serializes [operation] for the Hive sync queue.
String syncOperationToString(SyncOperation operation) => operation.name;
