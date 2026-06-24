/// Base exception for sync queue local storage operations.
class SyncQueueLocalException implements Exception {
  /// Creates [SyncQueueLocalException].
  const SyncQueueLocalException(this.message);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'SyncQueueLocalException: $message';
}
