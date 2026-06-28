import '../../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../../core/domain/repositories/recurring_expense_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Loads all recurring expense records.
class GetRecurringExpensesUseCase {
  /// Creates [GetRecurringExpensesUseCase].
  const GetRecurringExpensesUseCase(this._repository);

  final RecurringExpenseRepository _repository;

  /// Returns all recurring expenses.
  @override
  Future<ResponseHandler<List<RecurringExpenseEntity>>> call() {
    return _repository.getAll();
  }
}

/// Persists a new recurring expense record.
class AddRecurringExpenseUseCase {
  /// Creates [AddRecurringExpenseUseCase].
  const AddRecurringExpenseUseCase(this._repository);

  final RecurringExpenseRepository _repository;

  /// Creates [expense] and returns the saved record.
  @override
  Future<ResponseHandler<RecurringExpenseEntity>> call(
    RecurringExpenseEntity expense,
  ) {
    return _repository.create(expense);
  }
}

/// Updates an existing recurring expense record.
class UpdateRecurringExpenseUseCase {
  /// Creates [UpdateRecurringExpenseUseCase].
  const UpdateRecurringExpenseUseCase(this._repository);

  final RecurringExpenseRepository _repository;

  /// Updates [expense] and returns the saved record.
  @override
  Future<ResponseHandler<RecurringExpenseEntity>> call(
    RecurringExpenseEntity expense,
  ) {
    return _repository.update(expense);
  }
}

/// Deletes a recurring expense record by id.
class DeleteRecurringExpenseUseCase {
  /// Creates [DeleteRecurringExpenseUseCase].
  const DeleteRecurringExpenseUseCase(this._repository);

  final RecurringExpenseRepository _repository;

  /// Deletes the expense with [id].
  @override
  Future<ResponseHandler<void>> call(String id) {
    return _repository.delete(id);
  }
}

/// Searches recurring expense records by query.
class SearchRecurringExpensesUseCase {
  /// Creates [SearchRecurringExpensesUseCase].
  const SearchRecurringExpensesUseCase(this._repository);

  final RecurringExpenseRepository _repository;

  /// Returns expenses matching [query].
  @override
  Future<ResponseHandler<List<RecurringExpenseEntity>>> call(String query) {
    return _repository.search(query);
  }
}
