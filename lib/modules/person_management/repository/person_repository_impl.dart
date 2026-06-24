import 'package:dio/dio.dart';

import '../../../core/domain/entities/person_entity.dart';
import '../../../core/domain/repositories/person_repository.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../service/network/base_error.dart';
import '../../../service/network/response_handler.dart';
import '../../../service/sync/offline_first_sync_support.dart';
import '../datasource/person_local_data_source.dart';
import '../datasource/person_local_exception.dart';

/// Hive-backed [PersonRepository] implementation (offline-first, no Firebase).
class PersonRepositoryImpl implements PersonRepository {
  /// Creates [PersonRepositoryImpl].
  PersonRepositoryImpl({
    required PersonLocalDataSource localDataSource,
    OfflineFirstSyncSupport? syncSupport,
  })  : _localDataSource = localDataSource,
        _syncSupport = syncSupport ?? const OfflineFirstSyncSupport(null);

  final PersonLocalDataSource _localDataSource;
  final OfflineFirstSyncSupport _syncSupport;

  @override
  Future<ResponseHandler<PersonEntity>> create(PersonEntity person) {
    return _run(() async {
      final PersonEntity saved = await _localDataSource.addPerson(person);
      await _syncSupport.afterCreate(
        module: SyncModuleType.personManagement,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<PersonEntity?>> getById(String id) {
    return _run(() => _localDataSource.getPersonById(id));
  }

  @override
  Future<ResponseHandler<List<PersonEntity>>> getAll() {
    return _run(_localDataSource.getAllPersons);
  }

  @override
  Future<ResponseHandler<PersonEntity>> update(PersonEntity person) {
    return _run(() async {
      final PersonEntity saved = await _localDataSource.updatePerson(person);
      await _syncSupport.afterUpdate(
        module: SyncModuleType.personManagement,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<void>> delete(String id) {
    return _run(() async {
      await _localDataSource.deletePerson(id);
      await _syncSupport.afterDelete(
        module: SyncModuleType.personManagement,
        recordId: id,
      );
    });
  }

  @override
  Future<ResponseHandler<List<PersonEntity>>> search(String query) {
    return _run(() => _localDataSource.searchPersons(query));
  }

  Future<ResponseHandler<T>> _run<T>(Future<T> Function() action) async {
    try {
      final T result = await action();
      return OnSuccessResponse<T>(response: result);
    } on PersonLocalException catch (e) {
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
