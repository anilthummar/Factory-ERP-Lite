import '../../../../core/domain/entities/expense_entity.dart';
import '../../../../service/network/response_handler.dart';
import '../../../expense/foundation/expense_module_use_cases.dart';
import '../../repository/truck_expense_repository.dart';

class GetTruckExpensesUseCase implements GetExpensesUseCaseBase {
  const GetTruckExpensesUseCase(this._repository);
  final TruckExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call() => _repository.getAll();
}

class AddTruckExpenseUseCase implements AddExpenseUseCaseBase {
  const AddTruckExpenseUseCase(this._repository);
  final TruckExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.create(expense);
}

class UpdateTruckExpenseUseCase implements UpdateExpenseUseCaseBase {
  const UpdateTruckExpenseUseCase(this._repository);
  final TruckExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.update(expense);
}

class DeleteTruckExpenseUseCase implements DeleteExpenseUseCaseBase {
  const DeleteTruckExpenseUseCase(this._repository);
  final TruckExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<void>> call(String id) => _repository.delete(id);
}

class SearchTruckExpensesUseCase implements SearchExpensesUseCaseBase {
  const SearchTruckExpensesUseCase(this._repository);
  final TruckExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call(String query) =>
      _repository.search(query);
}
