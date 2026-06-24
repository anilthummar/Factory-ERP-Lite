/// Offline-first sync state for records synced between Hive and Firebase.
enum SyncStatus {
  /// Saved locally; not yet confirmed on the remote store.
  pending,

  /// Local and remote stores are in agreement.
  synced,

  /// Sync was attempted but failed; eligible for retry.
  failed,
}

/// Parses [SyncStatus] from Hive map or Firestore string values.
SyncStatus syncStatusFromString(String? value) {
  return SyncStatus.values.firstWhere(
    (SyncStatus status) => status.name == value,
    orElse: () => SyncStatus.pending,
  );
}

/// Serializes [SyncStatus] for Hive maps and Firestore documents.
String syncStatusToString(SyncStatus status) => status.name;

/// Whether [status] indicates a pending local change.
bool isSyncPending(SyncStatus status) => status == SyncStatus.pending;

/// Whether [status] indicates a successful sync.
bool isSyncSynced(SyncStatus status) => status == SyncStatus.synced;

/// Whether [status] indicates a failed sync attempt.
bool isSyncFailed(SyncStatus status) => status == SyncStatus.failed;
