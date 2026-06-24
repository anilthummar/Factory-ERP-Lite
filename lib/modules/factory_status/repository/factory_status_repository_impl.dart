import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/domain/repositories/factory_status_repository.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../service/sync/offline_first_sync_support.dart';
import '../datasource/factory_status_local_data_source.dart';
import '../datasource/factory_status_local_exception.dart';

/// Hive-backed [FactoryStatusRepository] implementation.
class FactoryStatusRepositoryImpl implements FactoryStatusRepository {
  /// Creates [FactoryStatusRepositoryImpl].
  FactoryStatusRepositoryImpl({
    required FactoryStatusLocalDataSource localDataSource,
    OfflineFirstSyncSupport? syncSupport,
  })  : _localDataSource = localDataSource,
        _syncSupport = syncSupport ?? const OfflineFirstSyncSupport(null);

  final FactoryStatusLocalDataSource _localDataSource;
  final OfflineFirstSyncSupport _syncSupport;

  @override
  Future<FactoryStatusEntity> create(FactoryStatusEntity status) async {
    try {
      final FactoryStatusEntity saved = await _localDataSource.add(status);
      await _syncSupport.afterCreate(
        module: SyncModuleType.factoryStatus,
        recordId: saved.id,
      );
      return saved;
    } on FactoryStatusLocalException {
      rethrow;
    }
  }

  @override
  Future<FactoryStatusEntity?> getById(String id) {
    return _localDataSource.getById(id);
  }

  @override
  Future<List<FactoryStatusEntity>> getAll() {
    return _localDataSource.getAll();
  }

  @override
  Future<FactoryStatusEntity> update(FactoryStatusEntity status) async {
    try {
      final FactoryStatusEntity saved =
          await _localDataSource.update(status);
      await _syncSupport.afterUpdate(
        module: SyncModuleType.factoryStatus,
        recordId: saved.id,
      );
      return saved;
    } on FactoryStatusLocalException {
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _localDataSource.delete(id);
      await _syncSupport.afterDelete(
        module: SyncModuleType.factoryStatus,
        recordId: id,
      );
    } on FactoryStatusLocalException {
      rethrow;
    }
  }

  @override
  Future<FactoryStatusEntity?> getCurrent() async {
    final List<FactoryStatusEntity> statuses = await getAll();
    if (statuses.isEmpty) {
      return null;
    }
    return statuses.first;
  }

  /// Appends a new status change to history.
  Future<FactoryStatusEntity> changeStatus({
    required FactoryStatusEntity status,
  }) async {
    final FactoryStatusEntity pending = FactoryStatusEntity(
      id: status.id,
      createdAt: status.createdAt,
      updatedAt: status.updatedAt,
      syncStatus: SyncStatus.pending,
      status: status.status,
      notes: status.notes,
    );
    return create(pending);
  }
}
