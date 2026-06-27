/// Sync engine configuration constants.
abstract final class SyncConfig {
  /// Maximum retry attempts before a queue item is marked dead-letter.
  static const int maxRetryAttempts = 5;

  /// Meta box key storing the timestamp of the last successful sync run.
  static const String lastSuccessfulSyncAtKey = 'lastSuccessfulSyncAtMs';

  /// Meta box key storing the timestamp of the last sync attempt.
  static const String lastSyncAttemptAtKey = 'lastSyncAttemptAtMs';

  /// Meta box key storing the timestamp of the last Firestore pull.
  static const String lastRemotePullAtKey = 'lastRemotePullAtMs';

  /// Interval between background sync attempts while the app is running.
  static const Duration backgroundSyncInterval = Duration(minutes: 15);
}
