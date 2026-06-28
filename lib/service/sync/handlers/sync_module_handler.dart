import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';

/// Loads local Hive payloads and updates entity sync status after sync attempts.
abstract class SyncModuleHandler {
  /// Module handled by this implementation.
  SyncModuleType get moduleType;

  /// Loads a Firestore-ready payload for [recordId], or null when missing.
  Future<Map<String, dynamic>?> loadPayload(String recordId);

  /// Updates the local entity sync status after a remote attempt.
  Future<void> updateRecordSyncStatus(String recordId, SyncStatus status);

  /// Applies a remote payload when conflict resolution accepts remote data.
  ///
  /// Firebase datasource phase will provide full merge logic per module.
  Future<void> applyRemotePayload(Map<String, dynamic> payload);
}
