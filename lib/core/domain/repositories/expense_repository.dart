import '../../../service/network/response_handler.dart';
import '../entities/expense_entity.dart';
import '../enums/expense_category.dart';

/// Contract for expense data access (domain layer only).
abstract class ExpenseRepository {
  Future<ResponseHandler<ExpenseEntity>> create(ExpenseEntity expense);

  Future<ResponseHandler<ExpenseEntity?>> getById(String id);

  Future<ResponseHandler<List<ExpenseEntity>>> getAll({
    ExpenseCategory? category,
  });

  Future<ResponseHandler<ExpenseEntity>> update(ExpenseEntity expense);

  Future<ResponseHandler<void>> delete(String id);

  Future<ResponseHandler<List<ExpenseEntity>>> search(
    String query, {
    ExpenseCategory? category,
  });
}
