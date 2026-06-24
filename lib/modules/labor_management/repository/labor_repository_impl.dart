import 'package:dio/dio.dart';

import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/repositories/labor_repository.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../service/network/base_error.dart';
import '../../../service/network/response_handler.dart';
import '../../../service/sync/offline_first_sync_support.dart';
import '../datasource/labor_local_data_source.dart';
import '../datasource/labor_local_exception.dart';

/// Hive-backed [LaborRepository] implementation (offline-first, no Firebase).
class LaborRepositoryImpl implements LaborRepository {
  /// Creates [LaborRepositoryImpl].
  LaborRepositoryImpl({
    required LaborLocalDataSource localDataSource,
    OfflineFirstSyncSupport? syncSupport,
  })  : _localDataSource = localDataSource,
        _syncSupport = syncSupport ?? const OfflineFirstSyncSupport(null);

  final LaborLocalDataSource _localDataSource;
  final OfflineFirstSyncSupport _syncSupport;

  @override
  Future<ResponseHandler<LaborEntity>> create(LaborEntity labor) {
    return _run(() async {
      final LaborEntity saved = await _localDataSource.addLabor(labor);
      await _syncSupport.afterCreate(
        module: SyncModuleType.laborManagement,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<LaborEntity?>> getById(String id) {
    return _run(() => _localDataSource.getLaborById(id));
  }

  @override
  Future<ResponseHandler<List<LaborEntity>>> getAll() {
    return _run(_localDataSource.getAllLabor);
  }

  @override
  Future<ResponseHandler<LaborEntity>> update(LaborEntity labor) {
    return _run(() async {
      final LaborEntity saved = await _localDataSource.updateLabor(labor);
      await _syncSupport.afterUpdate(
        module: SyncModuleType.laborManagement,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<void>> delete(String id) {
    return _run(() async {
      await _localDataSource.deleteLabor(id);
      await _syncSupport.afterDelete(
        module: SyncModuleType.laborManagement,
        recordId: id,
      );
    });
  }

  @override
  Future<ResponseHandler<List<LaborEntity>>> search(String query) {
    return _run(() => _localDataSource.searchLabor(query));
  }

  Future<ResponseHandler<T>> _run<T>(Future<T> Function() action) async {
    try {
      final T result = await action();
      return OnSuccessResponse<T>(response: result);
    } on LaborLocalException catch (e) {
      return OnFailureResponse<T>(
        error: ErrorResult(
          errorMessage: e.message,
          type: DioExceptionType.unknown,
        ),
      );
    } on Object catch (e) {
      return OnFailureResponse<T>(
        error: ErrorResult(
          errorMessage: e.toString(),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
