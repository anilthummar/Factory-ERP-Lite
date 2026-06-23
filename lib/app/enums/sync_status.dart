/// Offline-first sync state for Hive entities synced to Firebase.
enum SyncStatus {
  /// Saved locally; not yet confirmed on Firebase.
  pending,

  /// Local and Firebase are in agreement.
  synced,

  /// Sync attempted but failed; eligible for retry.
  failed,
}

/// Parses [SyncStatus] from Hive/Firestore string values.
SyncStatus syncStatusFromString(String? value) {
  return SyncStatus.values.firstWhere(
    (SyncStatus status) => status.name == value,
    orElse: () => SyncStatus.pending,
  );
}
