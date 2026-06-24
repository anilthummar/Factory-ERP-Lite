import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/repositories/expense_module_repository.dart';
import '../../../service/network/response_handler.dart';

/// Loads all expense records for a module.
abstract class GetExpensesUseCaseBase {
  /// Returns all expenses wrapped in [ResponseHandler].
  Future<ResponseHandler<List<ExpenseEntity>>> call();
}

/// Persists a new expense record for a module.
abstract class AddExpenseUseCaseBase {
  /// Creates [expense] and returns the saved record.
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense);
}

/// Updates an existing expense record for a module.
abstract class UpdateExpenseUseCaseBase {
  /// Updates [expense] and returns the saved record.
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense);
}

/// Deletes an expense record by identifier.
abstract class DeleteExpenseUseCaseBase {
  /// Deletes the expense with [id].
  Future<ResponseHandler<void>> call(String id);
}

/// Searches expense records by query text.
abstract class SearchExpensesUseCaseBase {
  /// Returns expenses matching [query].
  Future<ResponseHandler<List<ExpenseEntity>>> call(String query);
}

/// Loads all expense records for a module.
class GetExpenseModuleUseCase implements GetExpensesUseCaseBase {
  /// Creates [GetExpenseModuleUseCase].
  const GetExpenseModuleUseCase(this._repository);

  final ExpenseModuleRepository _repository;

  /// Returns all expenses wrapped in [ResponseHandler].
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call() {
    return _repository.getAll();
  }
}

/// Persists a new expense record for a module.
class AddExpenseModuleUseCase implements AddExpenseUseCaseBase {
  /// Creates [AddExpenseModuleUseCase].
  const AddExpenseModuleUseCase(this._repository);

  final ExpenseModuleRepository _repository;

  /// Creates [expense] and returns the saved record.
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) {
    return _repository.create(expense);
  }
}

/// Updates an existing expense record for a module.
class UpdateExpenseModuleUseCase implements UpdateExpenseUseCaseBase {
  /// Creates [UpdateExpenseModuleUseCase].
  const UpdateExpenseModuleUseCase(this._repository);

  final ExpenseModuleRepository _repository;

  /// Updates [expense] and returns the saved record.
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) {
    return _repository.update(expense);
  }
}

/// Deletes an expense record by identifier.
class DeleteExpenseModuleUseCase implements DeleteExpenseUseCaseBase {
  /// Creates [DeleteExpenseModuleUseCase].
  const DeleteExpenseModuleUseCase(this._repository);

  final ExpenseModuleRepository _repository;

  /// Deletes the expense with [id].
  @override
  Future<ResponseHandler<void>> call(String id) {
    return _repository.delete(id);
  }
}

/// Searches expense records by query text.
class SearchExpenseModuleUseCase implements SearchExpensesUseCaseBase {
  /// Creates [SearchExpenseModuleUseCase].
  const SearchExpenseModuleUseCase(this._repository);

  final ExpenseModuleRepository _repository;

  /// Returns expenses matching [query].
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call(String query) {
    return _repository.search(query);
  }
}
