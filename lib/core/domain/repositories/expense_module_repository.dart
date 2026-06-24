import '../../../service/network/response_handler.dart';
import '../entities/expense_entity.dart';

/// Contract for module-scoped one-time expense data access.
abstract class ExpenseModuleRepository {
  /// Persists a new expense record.
  Future<ResponseHandler<ExpenseEntity>> create(ExpenseEntity expense);

  /// Returns an expense by [id], or null when not found.
  Future<ResponseHandler<ExpenseEntity?>> getById(String id);

  /// Returns all expense records for the module.
  Future<ResponseHandler<List<ExpenseEntity>>> getAll();

  /// Updates an existing expense record.
  Future<ResponseHandler<ExpenseEntity>> update(ExpenseEntity expense);

  /// Deletes an expense record by [id].
  Future<ResponseHandler<void>> delete(String id);

  /// Searches expenses by [query].
  Future<ResponseHandler<List<ExpenseEntity>>> search(String query);
}
