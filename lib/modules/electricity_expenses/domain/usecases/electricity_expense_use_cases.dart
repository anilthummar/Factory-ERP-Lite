import '../../../../core/domain/entities/expense_entity.dart';
import '../../../../service/network/response_handler.dart';
import '../../../expense/foundation/expense_module_use_cases.dart';
import '../../repository/electricity_expense_repository.dart';

class GetElectricityExpensesUseCase implements GetExpensesUseCaseBase {
  const GetElectricityExpensesUseCase(this._repository);
  final ElectricityExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call() => _repository.getAll();
}

class AddElectricityExpenseUseCase implements AddExpenseUseCaseBase {
  const AddElectricityExpenseUseCase(this._repository);
  final ElectricityExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.create(expense);
}

class UpdateElectricityExpenseUseCase implements UpdateExpenseUseCaseBase {
  const UpdateElectricityExpenseUseCase(this._repository);
  final ElectricityExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.update(expense);
}

class DeleteElectricityExpenseUseCase implements DeleteExpenseUseCaseBase {
  const DeleteElectricityExpenseUseCase(this._repository);
  final ElectricityExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<void>> call(String id) => _repository.delete(id);
}

class SearchElectricityExpensesUseCase implements SearchExpensesUseCaseBase {
  const SearchElectricityExpensesUseCase(this._repository);
  final ElectricityExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call(String query) =>
      _repository.search(query);
}
