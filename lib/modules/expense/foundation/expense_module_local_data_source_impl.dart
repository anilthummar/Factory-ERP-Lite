import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/expense_entity.dart';
import '../../../service/hive/hive_manager.dart';
import '../datasource/expense_local_exception.dart';
import '../model/local/expense_hive_model.dart';
import 'expense_module_config.dart';
import 'expense_module_local_data_source.dart';

/// Hive implementation of [ExpenseModuleLocalDataSource].
class ExpenseModuleLocalDataSourceImpl implements ExpenseModuleLocalDataSource {
  /// Creates [ExpenseModuleLocalDataSourceImpl].
  ExpenseModuleLocalDataSourceImpl({
    required ExpenseModuleConfig config,
    HiveManager? hiveManager,
  })  : _config = config,
        _hiveManager = hiveManager ?? HiveManager.instance;

  final ExpenseModuleConfig _config;
  final HiveManager _hiveManager;

  Box<ExpenseHiveModel> get _box => _config.boxAccessor(_hiveManager);

  @override
  Future<List<ExpenseEntity>> getAllExpenses() async {
    return _runStorage('load expenses', () async {
      final List<ExpenseEntity> records = _box.values
          .map((ExpenseHiveModel model) => model.toEntity())
          .toList(growable: false);
      return _sort(records);
    });
  }

  @override
  Future<ExpenseEntity?> getExpenseById(String id) async {
    return _runStorage('load expense', () async {
      return _box.get(id)?.toEntity();
    });
  }

  @override
  Future<ExpenseEntity> addExpense(ExpenseEntity expense) async {
    return _runStorage('add expense', () async {
      if (_box.containsKey(expense.id)) {
        throw ExpenseAlreadyExistsException(expense.id);
      }
      final ExpenseHiveModel model = ExpenseHiveModel.fromEntity(expense);
      await _box.put(expense.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense) async {
    return _runStorage('update expense', () async {
      if (!_box.containsKey(expense.id)) {
        throw ExpenseNotFoundException(expense.id);
      }
      final ExpenseHiveModel model = ExpenseHiveModel.fromEntity(expense);
      await _box.put(expense.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _runStorage('delete expense', () async {
      if (!_box.containsKey(id)) {
        throw ExpenseNotFoundException(id);
      }
      await _box.delete(id);
    });
  }

  @override
  Future<List<ExpenseEntity>> searchExpenses(String query) async {
    return _runStorage('search expenses', () async {
      final String normalizedQuery = query.trim().toLowerCase();
      final Iterable<ExpenseEntity> records =
          _box.values.map((ExpenseHiveModel model) => model.toEntity());
      if (normalizedQuery.isEmpty) {
        return _sort(records);
      }
      final List<ExpenseEntity> matches = records
          .where(
            (ExpenseEntity expense) => _matchesQuery(expense, normalizedQuery),
          )
          .toList(growable: false);
      return _sort(matches);
    });
  }

  Future<T> _runStorage<T>(String operation, Future<T> Function() action) async {
    if (!_hiveManager.isInitialized) {
      throw ExpenseLocalStorageException(
        'Hive is not initialized. Cannot $operation.',
      );
    }
    if (!_config.isBoxOpenAccessor(_hiveManager)) {
      throw ExpenseLocalStorageException(
        'Expense Hive box "${_config.boxName}" is not open. Cannot $operation.',
      );
    }
    try {
      return await action();
    } on ExpenseLocalException {
      rethrow;
    } on HiveError catch (error) {
      throw ExpenseLocalStorageException(
        'Hive error while trying to $operation: ${error.message}',
      );
    } on Object catch (error) {
      throw ExpenseLocalStorageException(
        'Unexpected error while trying to $operation: $error',
      );
    }
  }

  List<ExpenseEntity> _sort(Iterable<ExpenseEntity> records) {
    final List<ExpenseEntity> sorted = records.toList(growable: false)
      ..sort(
        (ExpenseEntity a, ExpenseEntity b) =>
            b.updatedAt.compareTo(a.updatedAt),
      );
    return sorted;
  }

  bool _matchesQuery(ExpenseEntity expense, String query) {
    return expense.title.toLowerCase().contains(query) ||
        expense.amount.toString().contains(query) ||
        (expense.notes?.toLowerCase().contains(query) ?? false);
  }
}
