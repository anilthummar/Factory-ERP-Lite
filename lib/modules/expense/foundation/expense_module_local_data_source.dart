import '../../../core/domain/entities/expense_entity.dart';

/// Local Hive contract for a module-scoped expense box.
abstract class ExpenseModuleLocalDataSource {
  /// Returns all expense records from local storage.
  Future<List<ExpenseEntity>> getAllExpenses();

  /// Returns an expense by [id], or null when not found.
  Future<ExpenseEntity?> getExpenseById(String id);

  /// Persists a new expense record.
  Future<ExpenseEntity> addExpense(ExpenseEntity expense);

  /// Updates an existing expense record.
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense);

  /// Deletes an expense record by [id].
  Future<void> deleteExpense(String id);

  /// Searches expenses by [query].
  Future<List<ExpenseEntity>> searchExpenses(String query);
}
