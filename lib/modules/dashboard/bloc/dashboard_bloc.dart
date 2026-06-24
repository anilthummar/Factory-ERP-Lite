import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/dashboard_data.dart';
import '../domain/usecases/get_dashboard_data_use_case.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC for dashboard overview metrics.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  /// Creates [DashboardBloc].
  DashboardBloc({
    required GetDashboardDataUseCase getDashboardDataUseCase,
  })  : _getDashboardDataUseCase = getDashboardDataUseCase,
        super(const DashboardState()) {
    on<DashboardLoadRequested>(_onLoad);
    on<DashboardRefreshRequested>(_onRefresh);

    add(const DashboardLoadRequested());
  }

  final GetDashboardDataUseCase _getDashboardDataUseCase;

  Future<void> _onLoad(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: DashboardStatus.loading,
        clearError: true,
      ),
    );
    await _load(emit);
  }

  Future<void> _onRefresh(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.data == null) {
      emit(
        state.copyWith(
          status: DashboardStatus.loading,
          clearError: true,
        ),
      );
    }
    await _load(emit);
  }

  Future<void> _load(Emitter<DashboardState> emit) async {
    try {
      final DashboardData data = await _getDashboardDataUseCase();
      emit(
        state.copyWith(
          status: DashboardStatus.success,
          data: data,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
