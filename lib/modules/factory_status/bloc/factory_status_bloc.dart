import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/factory_status_entity.dart';
import '../domain/usecases/change_factory_status_use_case.dart';
import '../domain/usecases/get_factory_status_history_use_case.dart';
import 'factory_status_event.dart';
import 'factory_status_state.dart';

/// BLoC for factory status history and changes.
class FactoryStatusBloc
    extends Bloc<FactoryStatusEvent, FactoryStatusState> {
  /// Creates [FactoryStatusBloc].
  FactoryStatusBloc({
    required GetFactoryStatusHistoryUseCase getHistoryUseCase,
    required ChangeFactoryStatusUseCase changeStatusUseCase,
  })  : _getHistoryUseCase = getHistoryUseCase,
        _changeStatusUseCase = changeStatusUseCase,
        super(const FactoryStatusState()) {
    on<FactoryStatusLoadRequested>(_onLoad);
    on<FactoryStatusChangeRequested>(_onChange);

    add(const FactoryStatusLoadRequested());
  }

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

    try {
      final List<FactoryStatusEntity> history = await _getHistoryUseCase();
      emit(
        state.copyWith(
          status: FactoryStatusBlocStatus.success,
          currentStatus: history.isEmpty ? null : history.first,
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
      final List<FactoryStatusEntity> history = await _getHistoryUseCase();
      emit(
        state.copyWith(
          status: FactoryStatusBlocStatus.saved,
          currentStatus: history.isEmpty ? null : history.first,
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
