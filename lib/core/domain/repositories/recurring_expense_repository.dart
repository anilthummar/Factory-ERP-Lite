import '../entities/recurring_expense_entity.dart';

/// Contract for recurring expense data access (domain layer only).
abstract class RecurringExpenseRepository {
  /// Persists a new recurring expense record.
  Future<RecurringExpenseEntity> create(RecurringExpenseEntity expense);

  /// Returns a recurring expense by [id], or null if not found.
  Future<RecurringExpenseEntity?> getById(String id);

  /// Returns all recurring expense records.
  Future<List<RecurringExpenseEntity>> getAll();

  /// Updates an existing recurring expense record.
  Future<RecurringExpenseEntity> update(RecurringExpenseEntity expense);

  /// Deletes a recurring expense record by [id].
  Future<void> delete(String id);
}
