import '../../../service/network/response_handler.dart';
import '../entities/recurring_expense_entity.dart';

/// Contract for recurring expense data access (domain layer only).
abstract class RecurringExpenseRepository {
  Future<ResponseHandler<RecurringExpenseEntity>> create(
    RecurringExpenseEntity expense,
  );

  Future<ResponseHandler<RecurringExpenseEntity?>> getById(String id);

  Future<ResponseHandler<List<RecurringExpenseEntity>>> getAll();

  Future<ResponseHandler<RecurringExpenseEntity>> update(
    RecurringExpenseEntity expense,
  );

  Future<ResponseHandler<void>> delete(String id);

  Future<ResponseHandler<List<RecurringExpenseEntity>>> search(String query);
}
