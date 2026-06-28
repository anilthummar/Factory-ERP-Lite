import '../../../../core/domain/entities/expense_entity.dart';
import '../../../../service/network/response_handler.dart';
import '../../../expense/foundation/expense_module_use_cases.dart';
import '../../repository/miscellaneous_expense_repository.dart';

class GetMiscellaneousExpensesUseCase implements GetExpensesUseCaseBase {
  const GetMiscellaneousExpensesUseCase(this._repository);
  final MiscellaneousExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call() => _repository.getAll();
}

class AddMiscellaneousExpenseUseCase implements AddExpenseUseCaseBase {
  const AddMiscellaneousExpenseUseCase(this._repository);
  final MiscellaneousExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.create(expense);
}

class UpdateMiscellaneousExpenseUseCase implements UpdateExpenseUseCaseBase {
  const UpdateMiscellaneousExpenseUseCase(this._repository);
  final MiscellaneousExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.update(expense);
}

class DeleteMiscellaneousExpenseUseCase implements DeleteExpenseUseCaseBase {
  const DeleteMiscellaneousExpenseUseCase(this._repository);
  final MiscellaneousExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<void>> call(String id) => _repository.delete(id);
}

class SearchMiscellaneousExpensesUseCase implements SearchExpensesUseCaseBase {
  const SearchMiscellaneousExpensesUseCase(this._repository);
  final MiscellaneousExpenseRepository _repository;
  @override
  @override
  Future<ResponseHandler<List<ExpenseEntity>>> call(String query) =>
      _repository.search(query);
}
