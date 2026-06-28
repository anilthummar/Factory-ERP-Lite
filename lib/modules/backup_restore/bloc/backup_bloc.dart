import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/backup_file_result.dart';
import '../domain/models/backup_progress.dart';
import '../domain/models/backup_validation_result.dart';
import '../domain/usecases/backup_use_cases.dart';
import '../domain/usecases/restore_use_cases.dart';
import 'backup_event.dart';
import 'backup_state.dart';

export 'backup_event.dart';
export 'backup_state.dart';

/// BLoC for local JSON backup and restore.
class BackupBloc extends Bloc<BackupEvent, BackupState> {
  /// Creates [BackupBloc].
  BackupBloc({
    required GetBackupOverviewUseCase getBackupOverviewUseCase,
    required ExportLocalJsonBackupUseCase exportLocalJsonBackupUseCase,
    required ValidateBackupFileUseCase validateBackupFileUseCase,
    required RestoreLocalJsonBackupUseCase restoreLocalJsonBackupUseCase,
  })  : _getBackupOverviewUseCase = getBackupOverviewUseCase,
        _exportLocalJsonBackupUseCase = exportLocalJsonBackupUseCase,
        _validateBackupFileUseCase = validateBackupFileUseCase,
        _restoreLocalJsonBackupUseCase = restoreLocalJsonBackupUseCase,
        super(const BackupState()) {
    on<BackupLoadRequested>(_onLoad);
    on<BackupExportRequested>(_onExport);
    on<BackupValidateRequested>(_onValidate);
    on<BackupRestoreRequested>(_onRestore);

    add(const BackupLoadRequested());
  }

  final GetBackupOverviewUseCase _getBackupOverviewUseCase;
  final ExportLocalJsonBackupUseCase _exportLocalJsonBackupUseCase;
  final ValidateBackupFileUseCase _validateBackupFileUseCase;
  final RestoreLocalJsonBackupUseCase _restoreLocalJsonBackupUseCase;

  Future<void> _onLoad(
    BackupLoadRequested event,
    Emitter<BackupState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupStatus.loading,
        clearError: true,
        clearSuccess: true,
        clearProgress: true,
      ),
    );

    try {
      final Map<String, int> counts = await _getBackupOverviewUseCase();
      emit(
        _withCounts(
          counts,
          state.copyWith(status: BackupStatus.idle),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onExport(
    BackupExportRequested event,
    Emitter<BackupState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupStatus.exporting,
        clearError: true,
        clearSuccess: true,
        clearValidation: true,
        clearPendingPath: true,
      ),
    );

    try {
      final BackupFileResult result = await _exportLocalJsonBackupUseCase(
        onProgress: (BackupProgress progress) {
          emit(state.copyWith(progress: progress));
        },
      );
      final Map<String, int> counts = await _getBackupOverviewUseCase();
      emit(
        _withCounts(
          counts,
          state.copyWith(
            status: BackupStatus.success,
            successMessage:
                'Backup saved (${result.recordCount} records): ${result.fileName}',
            lastBackupPath: result.filePath,
            clearProgress: true,
          ),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupStatus.failure,
          errorMessage: error.toString(),
          clearProgress: true,
        ),
      );
    }
  }

  Future<void> _onValidate(
    BackupValidateRequested event,
    Emitter<BackupState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupStatus.validating,
        clearError: true,
        clearSuccess: true,
        clearValidation: true,
        clearPendingPath: true,
      ),
    );

    try {
      final BackupValidationResult validation =
          await _validateBackupFileUseCase(event.filePath);

      if (!validation.isValid) {
        emit(
          state.copyWith(
            status: BackupStatus.failure,
            errorMessage: validation.errors.join('\n'),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: BackupStatus.awaitingConfirmation,
          validation: validation,
          pendingRestorePath: event.filePath,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRestore(
    BackupRestoreRequested event,
    Emitter<BackupState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupStatus.restoring,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final int restoredCount = await _restoreLocalJsonBackupUseCase(
        event.filePath,
        onProgress: (BackupProgress progress) {
          emit(state.copyWith(progress: progress));
        },
      );
      final Map<String, int> counts = await _getBackupOverviewUseCase();
      emit(
        _withCounts(
          counts,
          state.copyWith(
            status: BackupStatus.success,
            successMessage: 'Restored $restoredCount records from backup.',
            clearProgress: true,
            clearValidation: true,
            clearPendingPath: true,
          ),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupStatus.failure,
          errorMessage: error.toString(),
          clearProgress: true,
        ),
      );
    }
  }

  BackupState _withCounts(Map<String, int> counts, BackupState base) {
    return base.copyWith(
      recordCounts: counts,
      totalRecords: counts.values.fold<int>(0, (int sum, int value) => sum + value),
    );
  }
}
