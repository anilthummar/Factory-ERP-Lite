import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/bloc/crud/crud_state_status.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/enums/sync_status.dart';
import '../../../service/network/response_handler.dart';
import '../domain/usecases/add_labor_use_case.dart';
import '../domain/usecases/delete_labor_use_case.dart';
import '../domain/usecases/get_labor_use_case.dart';
import '../domain/usecases/search_labor_use_case.dart';
import '../domain/usecases/update_labor_use_case.dart';
import 'labor_event.dart';

/// BLoC for labor list, search, and CRUD via use cases.
class LaborBloc extends Bloc<LaborEvent, CrudState<LaborEntity>> {
  /// Creates [LaborBloc].
  LaborBloc({
    required GetLaborUseCase getLaborUseCase,
    required AddLaborUseCase addLaborUseCase,
    required UpdateLaborUseCase updateLaborUseCase,
    required DeleteLaborUseCase deleteLaborUseCase,
    required SearchLaborUseCase searchLaborUseCase,
  })  : _getLaborUseCase = getLaborUseCase,
        _addLaborUseCase = addLaborUseCase,
        _updateLaborUseCase = updateLaborUseCase,
        _deleteLaborUseCase = deleteLaborUseCase,
        _searchLaborUseCase = searchLaborUseCase,
        super(CrudState<LaborEntity>()) {
    on<LaborLoadRequested>(_onLoad);
    on<LaborRefreshRequested>(_onRefresh);
    on<LaborSearchRequested>(_onSearch);
    on<LaborCreateRequested>(_onCreate);
    on<LaborUpdateRequested>(_onUpdate);
    on<LaborDeleteRequested>(_onDelete);

    add(const LaborLoadRequested());
  }

  final GetLaborUseCase _getLaborUseCase;
  final AddLaborUseCase _addLaborUseCase;
  final UpdateLaborUseCase _updateLaborUseCase;
  final DeleteLaborUseCase _deleteLaborUseCase;
  final SearchLaborUseCase _searchLaborUseCase;

  String _searchQuery = '';

  Future<void> _onLoad(
    LaborLoadRequested event,
    Emitter<CrudState<LaborEntity>> emit,
  ) async {
    _searchQuery = '';
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<List<LaborEntity>> result = await _getLaborUseCase();
    _emitListResult(result, emit);
  }

  Future<void> _onRefresh(
    LaborRefreshRequested event,
    Emitter<CrudState<LaborEntity>> emit,
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
    LaborSearchRequested event,
    Emitter<CrudState<LaborEntity>> emit,
  ) async {
    _searchQuery = event.query.trim();
    if (_searchQuery.isEmpty) {
      add(const LaborLoadRequested());
      return;
    }

    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<List<LaborEntity>> result =
        await _searchLaborUseCase(_searchQuery);
    _emitListResult(result, emit);
  }

  Future<void> _onCreate(
    LaborCreateRequested event,
    Emitter<CrudState<LaborEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final DateTime now = DateTime.now();
    final LaborEntity labor = LaborEntity(
      id: 'labor_${now.microsecondsSinceEpoch}',
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      name: event.name,
      mobile: event.mobile,
      skill: event.skill,
      dailyWage: event.dailyWage,
      notes: event.notes,
    );

    final ResponseHandler<LaborEntity> result = await _addLaborUseCase(labor);
    await _emitMutationResult(result, emit);
  }

  Future<void> _onUpdate(
    LaborUpdateRequested event,
    Emitter<CrudState<LaborEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final LaborEntity updatedLabor = LaborEntity(
      id: event.labor.id,
      createdAt: event.labor.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
      name: event.name,
      mobile: event.mobile,
      skill: event.skill,
      dailyWage: event.dailyWage,
      notes: event.notes,
    );

    final ResponseHandler<LaborEntity> result =
        await _updateLaborUseCase(updatedLabor);
    await _emitMutationResult(result, emit);
  }

  Future<void> _onDelete(
    LaborDeleteRequested event,
    Emitter<CrudState<LaborEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<void> result = await _deleteLaborUseCase(event.id);
    if (result is OnSuccessResponse<void>) {
      await _reloadCurrentView(emit);
      return;
    }

    _emitError(result, emit);
  }

  Future<void> _reloadCurrentView(
    Emitter<CrudState<LaborEntity>> emit,
  ) async {
    final ResponseHandler<List<LaborEntity>> result = _searchQuery.isEmpty
        ? await _getLaborUseCase()
        : await _searchLaborUseCase(_searchQuery);
    _emitListResult(result, emit);
  }

  void _emitListResult(
    ResponseHandler<List<LaborEntity>> result,
    Emitter<CrudState<LaborEntity>> emit,
  ) {
    if (result is OnSuccessResponse<List<LaborEntity>>) {
      emit(crudStateFromItems<LaborEntity>(result.response));
      return;
    }

    _emitError(result, emit);
  }

  Future<void> _emitMutationResult(
    ResponseHandler<LaborEntity> result,
    Emitter<CrudState<LaborEntity>> emit,
  ) async {
    if (result is OnSuccessResponse<LaborEntity>) {
      await _reloadCurrentView(emit);
      return;
    }

    _emitError(result, emit);
  }

  void _emitError<T>(
    ResponseHandler<T> result,
    Emitter<CrudState<LaborEntity>> emit,
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
