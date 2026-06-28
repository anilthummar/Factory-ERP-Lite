import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/factory_status_entity.dart';
import '../domain/usecases/change_factory_status_use_case.dart';
import '../domain/usecases/get_current_factory_status_use_case.dart';
import '../domain/usecases/get_factory_status_history_use_case.dart';
import 'factory_status_event.dart';
import 'factory_status_state.dart';

/// BLoC for factory status history and changes.
class FactoryStatusBloc
    extends Bloc<FactoryStatusEvent, FactoryStatusState> {
  /// Creates [FactoryStatusBloc].
  FactoryStatusBloc({
    required GetCurrentFactoryStatusUseCase getCurrentStatusUseCase,
    required GetFactoryStatusHistoryUseCase getHistoryUseCase,
    required ChangeFactoryStatusUseCase changeStatusUseCase,
  })  : _getCurrentStatusUseCase = getCurrentStatusUseCase,
        _getHistoryUseCase = getHistoryUseCase,
        _changeStatusUseCase = changeStatusUseCase,
        super(const FactoryStatusState()) {
    on<FactoryStatusLoadRequested>(_onLoad);
    on<FactoryStatusRefreshRequested>(_onRefresh);
    on<FactoryStatusChangeRequested>(_onChange);

    add(const FactoryStatusLoadRequested());
  }

  final GetCurrentFactoryStatusUseCase _getCurrentStatusUseCase;
  final GetFactoryStatusHistoryUseCase _getHistoryUseCase;
  final ChangeFactoryStatusUseCase _changeStatusUseCase;

  Future<void> _onLoad(
    FactoryStatusLoadRequested event,
    Emitter<FactoryStatusState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FactoryStatusBlocStatus.loading,
        clearError: true,
      ),
    );
    await _loadData(emit);
  }

  Future<void> _onRefresh(
    FactoryStatusRefreshRequested event,
    Emitter<FactoryStatusState> emit,
  ) async {
    if (state.history.isEmpty && state.currentStatus == null) {
      emit(
        state.copyWith(
          status: FactoryStatusBlocStatus.loading,
          clearError: true,
        ),
      );
    }
    await _loadData(emit);
  }

  Future<void> _onChange(
    FactoryStatusChangeRequested event,
    Emitter<FactoryStatusState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FactoryStatusBlocStatus.loading,
        clearError: true,
      ),
    );

    try {
      await _changeStatusUseCase(
        status: event.status,
        notes: event.notes,
      );
      await _loadData(
        emit,
        blocStatus: FactoryStatusBlocStatus.saved,
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: FactoryStatusBlocStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _loadData(
    Emitter<FactoryStatusState> emit, {
    FactoryStatusBlocStatus blocStatus = FactoryStatusBlocStatus.success,
  }) async {
    try {
      final FactoryStatusEntity? currentStatus =
          await _getCurrentStatusUseCase();
      final List<FactoryStatusEntity> history = await _getHistoryUseCase();
      emit(
        state.copyWith(
          status: blocStatus,
          currentStatus: currentStatus,
          history: history,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: FactoryStatusBlocStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
