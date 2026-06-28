import 'package:factory_erp_lite/core/domain/sync_metadata_keys.dart';
import 'package:factory_erp_lite/core/enums/sync_status.dart';
import 'package:factory_erp_lite/core/sync/sync_module_type.dart';
import 'package:factory_erp_lite/service/sync/handlers/sync_module_handler.dart';

/// Map-backed [SyncModuleHandler] for sync integration tests.
class StubSyncModuleHandler implements SyncModuleHandler {
  /// Creates [StubSyncModuleHandler].
  StubSyncModuleHandler({
    required this.moduleType,
    Map<String, Map<String, dynamic>>? payloads,
  }) : _payloads = payloads ?? <String, Map<String, dynamic>>{};

  @override
  final SyncModuleType moduleType;

  final Map<String, Map<String, dynamic>> _payloads;
  final Map<String, SyncStatus> _statuses = <String, SyncStatus>{};

  void seedRecord({
    required String id,
    required Map<String, dynamic> payload,
    SyncStatus status = SyncStatus.pending,
  }) {
    _payloads[id] = payload;
    _statuses[id] = status;
  }

  SyncStatus? statusFor(String recordId) => _statuses[recordId];

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    return _payloads[recordId];
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    _statuses[recordId] = status;
    final Map<String, dynamic>? payload = _payloads[recordId];
    if (payload != null) {
      _payloads[recordId] = <String, dynamic>{
        ...payload,
        SyncMetadataKeys.syncStatus: syncStatusToString(status),
      };
    }
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final String id = payload[SyncMetadataKeys.id] as String;
    _payloads[id] = payload;
    _statuses[id] = SyncStatus.synced;
  }
}
