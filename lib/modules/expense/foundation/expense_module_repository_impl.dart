import 'package:dio/dio.dart';

import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/repositories/expense_module_repository.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../service/network/base_error.dart';
import '../../../service/network/response_handler.dart';
import '../../../service/sync/offline_first_sync_support.dart';
import '../datasource/expense_local_exception.dart';
import 'expense_module_local_data_source.dart';

/// Hive-backed [ExpenseModuleRepository] implementation (offline-first).
class ExpenseModuleRepositoryImpl implements ExpenseModuleRepository {
  /// Creates [ExpenseModuleRepositoryImpl].
  ExpenseModuleRepositoryImpl({
    required ExpenseModuleLocalDataSource localDataSource,
    required SyncModuleType syncModuleType,
    OfflineFirstSyncSupport? syncSupport,
  })  : _localDataSource = localDataSource,
        _syncModuleType = syncModuleType,
        _syncSupport = syncSupport ?? const OfflineFirstSyncSupport(null);

  final ExpenseModuleLocalDataSource _localDataSource;
  final SyncModuleType _syncModuleType;
  final OfflineFirstSyncSupport _syncSupport;

  @override
  Future<ResponseHandler<ExpenseEntity>> create(ExpenseEntity expense) {
    return _run(() async {
      final ExpenseEntity saved = await _localDataSource.addExpense(expense);
      await _syncSupport.afterCreate(
        module: _syncModuleType,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<ExpenseEntity?>> getById(String id) =>
      _run(() => _localDataSource.getExpenseById(id));

  @override
  Future<ResponseHandler<List<ExpenseEntity>>> getAll() =>
      _run(_localDataSource.getAllExpenses);

  @override
  Future<ResponseHandler<ExpenseEntity>> update(ExpenseEntity expense) {
    return _run(() async {
      final ExpenseEntity saved = await _localDataSource.updateExpense(expense);
      await _syncSupport.afterUpdate(
        module: _syncModuleType,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<void>> delete(String id) {
    return _run(() async {
      await _localDataSource.deleteExpense(id);
      await _syncSupport.afterDelete(
        module: _syncModuleType,
        recordId: id,
      );
    });
  }

  @override
  Future<ResponseHandler<List<ExpenseEntity>>> search(String query) =>
      _run(() => _localDataSource.searchExpenses(query));

  Future<ResponseHandler<T>> _run<T>(Future<T> Function() action) async {
    try {
      return OnSuccessResponse<T>(response: await action());
    } on ExpenseLocalException catch (error) {
      return OnFailureResponse<T>(
        error: ErrorResult(
          errorMessage: error.message,
          type: DioExceptionType.unknown,
        ),
      );
    } on Object catch (error) {
      return OnFailureResponse<T>(
        error: ErrorResult(
          errorMessage: error.toString(),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
