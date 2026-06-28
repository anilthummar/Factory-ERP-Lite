import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/sync_diagnostics_data.dart';
import '../domain/usecases/get_sync_diagnostics_use_case.dart';
import '../domain/usecases/retry_sync_use_case.dart';
import 'sync_diagnostics_event.dart';
import 'sync_diagnostics_state.dart';

/// BLoC for the hidden sync diagnostics developer screen.
class SyncDiagnosticsBloc
    extends Bloc<SyncDiagnosticsEvent, SyncDiagnosticsState> {
  /// Creates [SyncDiagnosticsBloc].
  SyncDiagnosticsBloc({
    required GetSyncDiagnosticsUseCase getSyncDiagnosticsUseCase,
    required RetrySyncUseCase retrySyncUseCase,
  })  : _getSyncDiagnosticsUseCase = getSyncDiagnosticsUseCase,
        _retrySyncUseCase = retrySyncUseCase,
        super(const SyncDiagnosticsState()) {
    on<SyncDiagnosticsLoadRequested>(_onLoad);
    on<SyncDiagnosticsRetryRequested>(_onRetry);

    add(const SyncDiagnosticsLoadRequested());
  }

  final GetSyncDiagnosticsUseCase _getSyncDiagnosticsUseCase;
  final RetrySyncUseCase _retrySyncUseCase;

  Future<void> _onLoad(
    SyncDiagnosticsLoadRequested event,
    Emitter<SyncDiagnosticsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SyncDiagnosticsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final SyncDiagnosticsData data = await _getSyncDiagnosticsUseCase();
      emit(
        state.copyWith(
          status: SyncDiagnosticsStatus.success,
          data: data,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: SyncDiagnosticsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRetry(
    SyncDiagnosticsRetryRequested event,
    Emitter<SyncDiagnosticsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SyncDiagnosticsStatus.retrying,
        clearError: true,
      ),
    );

    try {
      await _retrySyncUseCase();
      final SyncDiagnosticsData data = await _getSyncDiagnosticsUseCase();
      emit(
        state.copyWith(
          status: SyncDiagnosticsStatus.success,
          data: data,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: SyncDiagnosticsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
