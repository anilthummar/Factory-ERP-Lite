import '../../../core/domain/entities/recurring_expense_entity.dart';

/// Local Hive contract for recurring expense records.
abstract class RecurringExpenseLocalDataSource {
  Future<List<RecurringExpenseEntity>> getAllRecurringExpenses();

  Future<RecurringExpenseEntity?> getRecurringExpenseById(String id);

  Future<RecurringExpenseEntity> addRecurringExpense(
    RecurringExpenseEntity expense,
  );

  Future<RecurringExpenseEntity> updateRecurringExpense(
    RecurringExpenseEntity expense,
  );

  Future<void> deleteRecurringExpense(String id);

  Future<List<RecurringExpenseEntity>> searchRecurringExpenses(String query);
}
