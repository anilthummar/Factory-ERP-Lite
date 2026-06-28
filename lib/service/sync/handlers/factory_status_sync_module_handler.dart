import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../modules/factory_status/model/local/factory_status_hive_model.dart';
import '../../../modules/factory_status/model/remote/factory_status_remote_model.dart';
import '../../hive/hive_manager.dart';
import 'sync_module_handler.dart';

/// Sync handler for factory status history records.
class FactoryStatusSyncModuleHandler implements SyncModuleHandler {
  /// Creates [FactoryStatusSyncModuleHandler].
  FactoryStatusSyncModuleHandler({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  @override
  SyncModuleType get moduleType => SyncModuleType.factoryStatus;

  Box<FactoryStatusHiveModel> get _box => _hiveManager.factoryStatusBox;

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    final FactoryStatusHiveModel? model = _box.get(recordId);
    if (model == null) {
      return null;
    }

    return FactoryStatusRemoteModel.fromEntity(model.toEntity()).toMap();
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    final FactoryStatusHiveModel? model = _box.get(recordId);
    if (model == null) {
      return;
    }

    final FactoryStatusEntity entity = model.toEntity();
    await _box.put(
      recordId,
      FactoryStatusHiveModel.fromEntity(
        FactoryStatusEntity(
          id: entity.id,
          createdAt: entity.createdAt,
          updatedAt: DateTime.now(),
          syncStatus: status,
          status: entity.status,
          notes: entity.notes,
        ),
      ),
    );
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final FactoryStatusEntity entity =
        FactoryStatusRemoteModel.fromMap(payload).toEntity();
    await _box.put(
      entity.id,
      FactoryStatusHiveModel.fromEntity(
        FactoryStatusEntity(
          id: entity.id,
          createdAt: entity.createdAt,
          updatedAt: entity.updatedAt,
          syncStatus: SyncStatus.synced,
          status: entity.status,
          notes: entity.notes,
        ),
      ),
    );
  }
}
