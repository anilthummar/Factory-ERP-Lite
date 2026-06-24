import 'package:dio/dio.dart';

import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/repositories/recurring_expense_repository.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../service/network/base_error.dart';
import '../../../service/network/response_handler.dart';
import '../../../service/sync/offline_first_sync_support.dart';
import '../datasource/recurring_expense_local_data_source.dart';
import '../datasource/recurring_expense_local_exception.dart';

/// Hive-backed [RecurringExpenseRepository] implementation.
class RecurringExpenseRepositoryImpl implements RecurringExpenseRepository {
  /// Creates [RecurringExpenseRepositoryImpl].
  RecurringExpenseRepositoryImpl({
    required RecurringExpenseLocalDataSource localDataSource,
    OfflineFirstSyncSupport? syncSupport,
  })  : _localDataSource = localDataSource,
        _syncSupport = syncSupport ?? const OfflineFirstSyncSupport(null);

  final RecurringExpenseLocalDataSource _localDataSource;
  final OfflineFirstSyncSupport _syncSupport;

  @override
  Future<ResponseHandler<RecurringExpenseEntity>> create(
    RecurringExpenseEntity expense,
  ) {
    return _run(() async {
      final RecurringExpenseEntity saved =
          await _localDataSource.addRecurringExpense(expense);
      await _syncSupport.afterCreate(
        module: SyncModuleType.recurringExpenses,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<RecurringExpenseEntity?>> getById(String id) =>
      _run(() => _localDataSource.getRecurringExpenseById(id));

  @override
  Future<ResponseHandler<List<RecurringExpenseEntity>>> getAll() =>
      _run(_localDataSource.getAllRecurringExpenses);

  @override
  Future<ResponseHandler<RecurringExpenseEntity>> update(
    RecurringExpenseEntity expense,
  ) {
    return _run(() async {
      final RecurringExpenseEntity saved =
          await _localDataSource.updateRecurringExpense(expense);
      await _syncSupport.afterUpdate(
        module: SyncModuleType.recurringExpenses,
        recordId: saved.id,
      );
      return saved;
    });
  }

  @override
  Future<ResponseHandler<void>> delete(String id) {
    return _run(() async {
      await _localDataSource.deleteRecurringExpense(id);
      await _syncSupport.afterDelete(
        module: SyncModuleType.recurringExpenses,
        recordId: id,
      );
    });
  }

  @override
  Future<ResponseHandler<List<RecurringExpenseEntity>>> search(String query) =>
      _run(() => _localDataSource.searchRecurringExpenses(query));

  Future<ResponseHandler<T>> _run<T>(Future<T> Function() action) async {
    try {
      return OnSuccessResponse<T>(response: await action());
    } on RecurringExpenseLocalException catch (e) {
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
