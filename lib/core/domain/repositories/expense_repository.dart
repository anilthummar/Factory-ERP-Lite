import '../entities/expense_entity.dart';

/// Contract for expense data access (domain layer only).
abstract class ExpenseRepository {
  /// Persists a new expense record.
  Future<ExpenseEntity> create(ExpenseEntity expense);

  /// Returns an expense by [id], or null if not found.
  Future<ExpenseEntity?> getById(String id);

  /// Returns all expense records.
  Future<List<ExpenseEntity>> getAll();

  /// Updates an existing expense record.
  Future<ExpenseEntity> update(ExpenseEntity expense);

  /// Deletes an expense record by [id].
  Future<void> delete(String id);
}
