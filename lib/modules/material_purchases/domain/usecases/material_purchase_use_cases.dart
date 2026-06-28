import '../../../../core/domain/entities/expense_entity.dart';
import '../../../../service/network/response_handler.dart';
import '../../../expense/foundation/expense_module_use_cases.dart';
import '../../repository/material_purchase_repository.dart';

/// Loads all material purchase expense records.
class GetMaterialPurchasesUseCase implements GetExpensesUseCaseBase {
  /// Creates [GetMaterialPurchasesUseCase].
  const GetMaterialPurchasesUseCase(this._repository);

  final MaterialPurchaseRepository _repository;

  /// Returns all material purchases.
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call() {
    return _repository.getAll();
  }
}

/// Persists a new material purchase expense.
class AddMaterialPurchaseUseCase implements AddExpenseUseCaseBase {
  /// Creates [AddMaterialPurchaseUseCase].
  const AddMaterialPurchaseUseCase(this._repository);

  final MaterialPurchaseRepository _repository;

  /// Creates [expense] and returns the saved record.
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) {
    return _repository.create(expense);
  }
}

/// Updates an existing material purchase expense.
class UpdateMaterialPurchaseUseCase implements UpdateExpenseUseCaseBase {
  /// Creates [UpdateMaterialPurchaseUseCase].
  const UpdateMaterialPurchaseUseCase(this._repository);

  final MaterialPurchaseRepository _repository;

  /// Updates [expense] and returns the saved record.
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) {
    return _repository.update(expense);
  }
}

/// Deletes a material purchase expense by id.
class DeleteMaterialPurchaseUseCase implements DeleteExpenseUseCaseBase {
  /// Creates [DeleteMaterialPurchaseUseCase].
  const DeleteMaterialPurchaseUseCase(this._repository);

  final MaterialPurchaseRepository _repository;

  /// Deletes the expense with [id].
  @override
  Future<ResponseHandler<void>> call(String id) {
    return _repository.delete(id);
  }
}

/// Searches material purchase expenses by query.
class SearchMaterialPurchasesUseCase implements SearchExpensesUseCaseBase {
  /// Creates [SearchMaterialPurchasesUseCase].
  const SearchMaterialPurchasesUseCase(this._repository);

  final MaterialPurchaseRepository _repository;

  /// Returns expenses matching [query].
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call(String query) {
    return _repository.search(query);
  }
}
