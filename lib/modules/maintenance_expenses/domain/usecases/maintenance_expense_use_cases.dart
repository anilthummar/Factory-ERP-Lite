import '../../../../core/domain/entities/expense_entity.dart';
import '../../../../service/network/response_handler.dart';
import '../../../expense/foundation/expense_module_use_cases.dart';
import '../../repository/maintenance_expense_repository.dart';

class GetMaintenanceExpensesUseCase implements GetExpensesUseCaseBase {
  const GetMaintenanceExpensesUseCase(this._repository);
  final MaintenanceExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call() => _repository.getAll();
}

class AddMaintenanceExpenseUseCase implements AddExpenseUseCaseBase {
  const AddMaintenanceExpenseUseCase(this._repository);
  final MaintenanceExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.create(expense);
}

class UpdateMaintenanceExpenseUseCase implements UpdateExpenseUseCaseBase {
  const UpdateMaintenanceExpenseUseCase(this._repository);
  final MaintenanceExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.update(expense);
}

class DeleteMaintenanceExpenseUseCase implements DeleteExpenseUseCaseBase {
  const DeleteMaintenanceExpenseUseCase(this._repository);
  final MaintenanceExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<void>> call(String id) => _repository.delete(id);
}

class SearchMaintenanceExpensesUseCase implements SearchExpensesUseCaseBase {
  const SearchMaintenanceExpensesUseCase(this._repository);
  final MaintenanceExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call(String query) =>
      _repository.search(query);
}
