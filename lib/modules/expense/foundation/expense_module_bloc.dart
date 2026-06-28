import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/bloc/crud/crud_state_status.dart';
import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/enums/sync_status.dart';
import '../../../service/network/response_handler.dart';
import 'expense_module_config.dart';
import 'expense_module_event.dart';
import 'expense_module_use_cases.dart';

/// BLoC for module-scoped expense list, search, and CRUD via use cases.
class ExpenseModuleBloc extends Bloc<ExpenseModuleEvent, CrudState<ExpenseEntity>> {
  /// Creates [ExpenseModuleBloc].
  ExpenseModuleBloc({
    required ExpenseModuleConfig config,
    required GetExpensesUseCaseBase getExpensesUseCase,
    required AddExpenseUseCaseBase addExpenseUseCase,
    required UpdateExpenseUseCaseBase updateExpenseUseCase,
    required DeleteExpenseUseCaseBase deleteExpenseUseCase,
    required SearchExpensesUseCaseBase searchExpensesUseCase,
  })  : _config = config,
        _getExpensesUseCase = getExpensesUseCase,
        _addExpenseUseCase = addExpenseUseCase,
        _updateExpenseUseCase = updateExpenseUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        _searchExpensesUseCase = searchExpensesUseCase,
        super(CrudState<ExpenseEntity>()) {
    on<ExpenseModuleLoadRequested>(_onLoad);
    on<ExpenseModuleRefreshRequested>(_onRefresh);
    on<ExpenseModuleSearchRequested>(_onSearch);
    on<ExpenseModuleCreateRequested>(_onCreate);
    on<ExpenseModuleUpdateRequested>(_onUpdate);
    on<ExpenseModuleDeleteRequested>(_onDelete);

    add(const ExpenseModuleLoadRequested());
  }

  final ExpenseModuleConfig _config;
  final GetExpensesUseCaseBase _getExpensesUseCase;
  final AddExpenseUseCaseBase _addExpenseUseCase;
  final UpdateExpenseUseCaseBase _updateExpenseUseCase;
  final DeleteExpenseUseCaseBase _deleteExpenseUseCase;
  final SearchExpensesUseCaseBase _searchExpensesUseCase;

  String _searchQuery = '';

  Future<void> _onLoad(
    ExpenseModuleLoadRequested event,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    _searchQuery = '';
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<List<ExpenseEntity>> result =
        await _getExpensesUseCase();
    _emitListResult(result, emit);
  }

  Future<void> _onRefresh(
    ExpenseModuleRefreshRequested event,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    if (state.items.isEmpty) {
      emit(
        state.copyWith(
          status: CrudStateStatus.loading,
          clearError: true,
        ),
      );
    }

    await _reloadCurrentView(emit);
  }

  Future<void> _onSearch(
    ExpenseModuleSearchRequested event,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    _searchQuery = event.query.trim();
    if (_searchQuery.isEmpty) {
      add(const ExpenseModuleLoadRequested());
      return;
    }

    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<List<ExpenseEntity>> result =
        await _searchExpensesUseCase(_searchQuery);
    _emitListResult(result, emit);
  }

  Future<void> _onCreate(
    ExpenseModuleCreateRequested event,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final DateTime now = DateTime.now();
    final ExpenseEntity expense = ExpenseEntity(
      id: '${_config.idPrefix}${now.microsecondsSinceEpoch}',
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      title: event.title,
      amount: event.amount,
      date: event.date,
      category: _config.category,
      notes: event.notes,
      attachmentPath: event.attachmentPath,
    );

    final ResponseHandler<ExpenseEntity> result =
        await _addExpenseUseCase(expense);
    await _emitMutationResult(result, emit);
  }

  Future<void> _onUpdate(
    ExpenseModuleUpdateRequested event,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ExpenseEntity updatedExpense = ExpenseEntity(
      id: event.expense.id,
      createdAt: event.expense.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
      title: event.title,
      amount: event.amount,
      date: event.date,
      category: _config.category,
      notes: event.notes,
      attachmentPath: event.attachmentPath,
    );

    final ResponseHandler<ExpenseEntity> result =
        await _updateExpenseUseCase(updatedExpense);
    await _emitMutationResult(result, emit);
  }

  Future<void> _onDelete(
    ExpenseModuleDeleteRequested event,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<void> result =
        await _deleteExpenseUseCase(event.id);
    if (result is OnSuccessResponse<void>) {
      await _reloadCurrentView(emit);
      return;
    }

    _emitError(result, emit);
  }

  Future<void> _reloadCurrentView(
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    final ResponseHandler<List<ExpenseEntity>> result = _searchQuery.isEmpty
        ? await _getExpensesUseCase()
        : await _searchExpensesUseCase(_searchQuery);
    _emitListResult(result, emit);
  }

  void _emitListResult(
    ResponseHandler<List<ExpenseEntity>> result,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) {
    if (result is OnSuccessResponse<List<ExpenseEntity>>) {
      emit(crudStateFromItems<ExpenseEntity>(result.response));
      return;
    }

    _emitError(result, emit);
  }

  Future<void> _emitMutationResult(
    ResponseHandler<ExpenseEntity> result,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) async {
    if (result is OnSuccessResponse<ExpenseEntity>) {
      await _reloadCurrentView(emit);
      return;
    }

    _emitError(result, emit);
  }

  void _emitError<T>(
    ResponseHandler<T> result,
    Emitter<CrudState<ExpenseEntity>> emit,
  ) {
    final String message = result.getFailureInstance()?.error?.errorMessage ??
        'Something went wrong. Please try again.';
    emit(
      state.copyWith(
        status: CrudStateStatus.error,
        errorMessage: message,
      ),
    );
  }
}
