import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/bloc/crud/crud_state_status.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/enums/sync_status.dart';
import '../../../service/network/response_handler.dart';
import '../domain/usecases/recurring_expense_use_cases.dart';
import 'recurring_expense_event.dart';

/// BLoC for recurring expense list, search, and CRUD via use cases.
class RecurringExpenseBloc
    extends Bloc<RecurringExpenseEvent, CrudState<RecurringExpenseEntity>> {
  /// Creates [RecurringExpenseBloc].
  RecurringExpenseBloc({
    required GetRecurringExpensesUseCase getRecurringExpensesUseCase,
    required AddRecurringExpenseUseCase addRecurringExpenseUseCase,
    required UpdateRecurringExpenseUseCase updateRecurringExpenseUseCase,
    required DeleteRecurringExpenseUseCase deleteRecurringExpenseUseCase,
    required SearchRecurringExpensesUseCase searchRecurringExpensesUseCase,
  })  : _getRecurringExpensesUseCase = getRecurringExpensesUseCase,
        _addRecurringExpenseUseCase = addRecurringExpenseUseCase,
        _updateRecurringExpenseUseCase = updateRecurringExpenseUseCase,
        _deleteRecurringExpenseUseCase = deleteRecurringExpenseUseCase,
        _searchRecurringExpensesUseCase = searchRecurringExpensesUseCase,
        super(CrudState<RecurringExpenseEntity>()) {
    on<RecurringExpenseLoadRequested>(_onLoad);
    on<RecurringExpenseRefreshRequested>(_onRefresh);
    on<RecurringExpenseSearchRequested>(_onSearch);
    on<RecurringExpenseCreateRequested>(_onCreate);
    on<RecurringExpenseUpdateRequested>(_onUpdate);
    on<RecurringExpenseDeleteRequested>(_onDelete);
    add(const RecurringExpenseLoadRequested());
  }

  final GetRecurringExpensesUseCase _getRecurringExpensesUseCase;
  final AddRecurringExpenseUseCase _addRecurringExpenseUseCase;
  final UpdateRecurringExpenseUseCase _updateRecurringExpenseUseCase;
  final DeleteRecurringExpenseUseCase _deleteRecurringExpenseUseCase;
  final SearchRecurringExpensesUseCase _searchRecurringExpensesUseCase;

  String _searchQuery = '';

  Future<void> _onLoad(
    RecurringExpenseLoadRequested event,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    _searchQuery = '';
    emit(state.copyWith(status: CrudStateStatus.loading, clearError: true));
    _emitListResult(await _getRecurringExpensesUseCase(), emit);
  }

  Future<void> _onRefresh(
    RecurringExpenseRefreshRequested event,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(status: CrudStateStatus.loading, clearError: true));
    }
    await _reloadCurrentView(emit);
  }

  Future<void> _onSearch(
    RecurringExpenseSearchRequested event,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    _searchQuery = event.query.trim();
    if (_searchQuery.isEmpty) {
      add(const RecurringExpenseLoadRequested());
      return;
    }
    emit(state.copyWith(status: CrudStateStatus.loading, clearError: true));
    _emitListResult(await _searchRecurringExpensesUseCase(_searchQuery), emit);
  }

  Future<void> _onCreate(
    RecurringExpenseCreateRequested event,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    emit(state.copyWith(status: CrudStateStatus.loading, clearError: true));
    final DateTime now = DateTime.now();
    final RecurringExpenseEntity expense = RecurringExpenseEntity(
      id: 'recurring_${now.microsecondsSinceEpoch}',
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      title: event.title,
      amount: event.amount,
      frequency: event.frequency,
      startDate: event.startDate,
      endDate: event.endDate,
      notes: event.notes,
    );
    await _emitMutationResult(await _addRecurringExpenseUseCase(expense), emit);
  }

  Future<void> _onUpdate(
    RecurringExpenseUpdateRequested event,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    emit(state.copyWith(status: CrudStateStatus.loading, clearError: true));
    final RecurringExpenseEntity expense = RecurringExpenseEntity(
      id: event.expense.id,
      createdAt: event.expense.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
      title: event.title,
      amount: event.amount,
      frequency: event.frequency,
      startDate: event.startDate,
      endDate: event.endDate,
      notes: event.notes,
    );
    await _emitMutationResult(
      await _updateRecurringExpenseUseCase(expense),
      emit,
    );
  }

  Future<void> _onDelete(
    RecurringExpenseDeleteRequested event,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    emit(state.copyWith(status: CrudStateStatus.loading, clearError: true));
    final ResponseHandler<void> result =
        await _deleteRecurringExpenseUseCase(event.id);
    if (result is OnSuccessResponse<void>) {
      await _reloadCurrentView(emit);
      return;
    }
    _emitError(result, emit);
  }

  Future<void> _reloadCurrentView(
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    final ResponseHandler<List<RecurringExpenseEntity>> result =
        _searchQuery.isEmpty
            ? await _getRecurringExpensesUseCase()
            : await _searchRecurringExpensesUseCase(_searchQuery);
    _emitListResult(result, emit);
  }

  void _emitListResult(
    ResponseHandler<List<RecurringExpenseEntity>> result,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) {
    if (result is OnSuccessResponse<List<RecurringExpenseEntity>>) {
      emit(crudStateFromItems<RecurringExpenseEntity>(result.response));
      return;
    }
    _emitError(result, emit);
  }

  Future<void> _emitMutationResult(
    ResponseHandler<RecurringExpenseEntity> result,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) async {
    if (result is OnSuccessResponse<RecurringExpenseEntity>) {
      await _reloadCurrentView(emit);
      return;
    }
    _emitError(result, emit);
  }

  void _emitError<T>(
    ResponseHandler<T> result,
    Emitter<CrudState<RecurringExpenseEntity>> emit,
  ) {
    emit(
      state.copyWith(
        status: CrudStateStatus.error,
        errorMessage: result.getFailureInstance()?.error?.errorMessage ??
            'Something went wrong. Please try again.',
      ),
    );
  }
}
