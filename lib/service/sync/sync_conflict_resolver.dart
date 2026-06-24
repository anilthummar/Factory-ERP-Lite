import '../../core/domain/sync_metadata_keys.dart';

/// How the sync engine resolves a local vs remote conflict.
enum SyncConflictResolution {
  /// Keep the local Hive record and re-push to remote.
  keepLocal,

  /// Accept the remote record and overwrite local Hive.
  acceptRemote,
}

/// Local and remote payloads in conflict for the same record.
class SyncConflictData {
  /// Creates [SyncConflictData].
  const SyncConflictData({
    required this.localPayload,
    required this.remotePayload,
  });

  /// Local Hive payload.
  final Map<String, dynamic> localPayload;

  /// Remote Firestore payload.
  final Map<String, dynamic> remotePayload;

  /// Parsed local [updatedAt].
  DateTime get localUpdatedAt => _parseUpdatedAt(localPayload);

  /// Parsed remote [updatedAt].
  DateTime get remoteUpdatedAt => _parseUpdatedAt(remotePayload);

  DateTime _parseUpdatedAt(Map<String, dynamic> payload) {
    final Object? raw = payload[SyncMetadataKeys.updatedAt];
    if (raw is String) {
      return DateTime.parse(raw);
    }
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}

/// Resolves sync conflicts using a last-write-wins strategy on [updatedAt].
class SyncConflictResolver {
  /// Creates [SyncConflictResolver].
  const SyncConflictResolver();

  /// Returns whether local or remote should win.
  SyncConflictResolution resolve(SyncConflictData data) {
    if (data.localUpdatedAt.isAfter(data.remoteUpdatedAt)) {
      return SyncConflictResolution.keepLocal;
    }
    if (data.remoteUpdatedAt.isAfter(data.localUpdatedAt)) {
      return SyncConflictResolution.acceptRemote;
    }
    return SyncConflictResolution.keepLocal;
  }
}
