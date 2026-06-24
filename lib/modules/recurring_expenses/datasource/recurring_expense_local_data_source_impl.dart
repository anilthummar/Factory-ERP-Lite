import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../service/hive/hive_manager.dart';
import '../model/local/recurring_expense_hive_model.dart';
import 'recurring_expense_local_data_source.dart';
import 'recurring_expense_local_exception.dart';

/// Hive implementation of [RecurringExpenseLocalDataSource].
class RecurringExpenseLocalDataSourceImpl
    implements RecurringExpenseLocalDataSource {
  RecurringExpenseLocalDataSourceImpl({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  Box<RecurringExpenseHiveModel> get _box => _hiveManager.recurringExpenseBox;

  @override
  Future<List<RecurringExpenseEntity>> getAllRecurringExpenses() async {
    return _runStorage('load recurring expenses', () async {
      final List<RecurringExpenseEntity> records = _box.values
          .map((RecurringExpenseHiveModel model) => model.toEntity())
          .toList(growable: false);
      return _sort(records);
    });
  }

  @override
  Future<RecurringExpenseEntity?> getRecurringExpenseById(String id) async {
    return _runStorage('load recurring expense', () async {
      return _box.get(id)?.toEntity();
    });
  }

  @override
  Future<RecurringExpenseEntity> addRecurringExpense(
    RecurringExpenseEntity expense,
  ) async {
    return _runStorage('add recurring expense', () async {
      if (_box.containsKey(expense.id)) {
        throw RecurringExpenseAlreadyExistsException(expense.id);
      }
      final RecurringExpenseHiveModel model =
          RecurringExpenseHiveModel.fromEntity(expense);
      await _box.put(expense.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<RecurringExpenseEntity> updateRecurringExpense(
    RecurringExpenseEntity expense,
  ) async {
    return _runStorage('update recurring expense', () async {
      if (!_box.containsKey(expense.id)) {
        throw RecurringExpenseNotFoundException(expense.id);
      }
      final RecurringExpenseHiveModel model =
          RecurringExpenseHiveModel.fromEntity(expense);
      await _box.put(expense.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<void> deleteRecurringExpense(String id) async {
    await _runStorage('delete recurring expense', () async {
      if (!_box.containsKey(id)) {
        throw RecurringExpenseNotFoundException(id);
      }
      await _box.delete(id);
    });
  }

  @override
  Future<List<RecurringExpenseEntity>> searchRecurringExpenses(
    String query,
  ) async {
    return _runStorage('search recurring expenses', () async {
      final String normalizedQuery = query.trim().toLowerCase();
      if (normalizedQuery.isEmpty) {
        return getAllRecurringExpenses();
      }
      final List<RecurringExpenseEntity> matches = _box.values
          .map((RecurringExpenseHiveModel model) => model.toEntity())
          .where(
            (RecurringExpenseEntity expense) =>
                _matchesQuery(expense, normalizedQuery),
          )
          .toList(growable: false);
      return _sort(matches);
    });
  }

  Future<T> _runStorage<T>(String operation, Future<T> Function() action) async {
    if (!_hiveManager.isInitialized) {
      throw RecurringExpenseLocalStorageException(
        'Hive is not initialized. Cannot $operation.',
      );
    }
    if (!_hiveManager.isRecurringExpenseBoxOpen) {
      throw RecurringExpenseLocalStorageException(
        'Recurring expense Hive box is not open. Cannot $operation.',
      );
    }
    try {
      return await action();
    } on RecurringExpenseLocalException {
      rethrow;
    } on HiveError catch (error) {
      throw RecurringExpenseLocalStorageException(
        'Hive error while trying to $operation: ${error.message}',
      );
    } on Object catch (error) {
      throw RecurringExpenseLocalStorageException(
        'Unexpected error while trying to $operation: $error',
      );
    }
  }

  List<RecurringExpenseEntity> _sort(List<RecurringExpenseEntity> records) {
    final List<RecurringExpenseEntity> sorted =
        List<RecurringExpenseEntity>.from(records)
          ..sort(
            (RecurringExpenseEntity a, RecurringExpenseEntity b) =>
                b.updatedAt.compareTo(a.updatedAt),
          );
    return sorted;
  }

  bool _matchesQuery(RecurringExpenseEntity expense, String query) {
    return expense.title.toLowerCase().contains(query) ||
        expense.amount.toString().contains(query) ||
        expense.frequency.name.toLowerCase().contains(query) ||
        (expense.notes?.toLowerCase().contains(query) ?? false);
  }
}
