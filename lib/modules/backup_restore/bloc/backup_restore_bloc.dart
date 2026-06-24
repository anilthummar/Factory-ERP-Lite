import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/backup_file_result.dart';
import '../domain/models/google_sheets_backup_result.dart';
import '../domain/usecases/backup_to_google_sheets_use_case.dart';
import '../domain/usecases/create_json_backup_use_case.dart';
import '../domain/usecases/get_backup_overview_use_case.dart';
import '../domain/usecases/restore_json_backup_use_case.dart';
import 'backup_restore_event.dart';
import 'backup_restore_state.dart';

export 'backup_restore_event.dart';
export 'backup_restore_state.dart';

/// BLoC for backup and restore actions.
class BackupRestoreBloc extends Bloc<BackupRestoreEvent, BackupRestoreState> {
  /// Creates [BackupRestoreBloc].
  BackupRestoreBloc({
    required GetBackupOverviewUseCase getBackupOverviewUseCase,
    required CreateJsonBackupUseCase createJsonBackupUseCase,
    required RestoreJsonBackupUseCase restoreJsonBackupUseCase,
    required BackupToGoogleSheetsUseCase backupToGoogleSheetsUseCase,
  })  : _getBackupOverviewUseCase = getBackupOverviewUseCase,
        _createJsonBackupUseCase = createJsonBackupUseCase,
        _restoreJsonBackupUseCase = restoreJsonBackupUseCase,
        _backupToGoogleSheetsUseCase = backupToGoogleSheetsUseCase,
        super(const BackupRestoreState()) {
    on<BackupRestoreLoadRequested>(_onLoad);
    on<BackupRestoreJsonExportRequested>(_onJsonExport);
    on<BackupRestoreJsonImportRequested>(_onJsonImport);
    on<BackupRestoreGoogleSheetsRequested>(_onGoogleSheets);

    add(const BackupRestoreLoadRequested());
  }

  final GetBackupOverviewUseCase _getBackupOverviewUseCase;
  final CreateJsonBackupUseCase _createJsonBackupUseCase;
  final RestoreJsonBackupUseCase _restoreJsonBackupUseCase;
  final BackupToGoogleSheetsUseCase _backupToGoogleSheetsUseCase;

  Future<void> _onLoad(
    BackupRestoreLoadRequested event,
    Emitter<BackupRestoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupRestoreStatus.loading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final Map<String, int> counts = await _getBackupOverviewUseCase();
      emit(
        state.copyWith(
          status: BackupRestoreStatus.idle,
          recordCounts: counts,
          totalRecords: counts.values.fold<int>(0, (int sum, int value) => sum + value),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupRestoreStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onJsonExport(
    BackupRestoreJsonExportRequested event,
    Emitter<BackupRestoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupRestoreStatus.exportingJson,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final BackupFileResult result = await _createJsonBackupUseCase();
      final Map<String, int> counts = await _getBackupOverviewUseCase();
      emit(
        state.copyWith(
          status: BackupRestoreStatus.success,
          recordCounts: counts,
          totalRecords: counts.values.fold<int>(0, (int sum, int value) => sum + value),
          successMessage:
              'Backup saved (${result.recordCount} records): ${result.fileName}',
          lastBackupPath: result.filePath,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupRestoreStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onJsonImport(
    BackupRestoreJsonImportRequested event,
    Emitter<BackupRestoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupRestoreStatus.restoringJson,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final int restoredCount =
          await _restoreJsonBackupUseCase(event.filePath);
      final Map<String, int> counts = await _getBackupOverviewUseCase();
      emit(
        state.copyWith(
          status: BackupRestoreStatus.success,
          recordCounts: counts,
          totalRecords: counts.values.fold<int>(0, (int sum, int value) => sum + value),
          successMessage: 'Restored $restoredCount records from backup.',
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupRestoreStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onGoogleSheets(
    BackupRestoreGoogleSheetsRequested event,
    Emitter<BackupRestoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BackupRestoreStatus.exportingSheets,
        clearError: true,
        clearSuccess: true,
        clearSheetsUrl: true,
      ),
    );

    try {
      final GoogleSheetsBackupResult result =
          await _backupToGoogleSheetsUseCase();
      emit(
        state.copyWith(
          status: BackupRestoreStatus.success,
          successMessage:
              'Google Sheets backup created (${result.recordCount} records).',
          lastSheetsUrl: result.spreadsheetUrl,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: BackupRestoreStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
