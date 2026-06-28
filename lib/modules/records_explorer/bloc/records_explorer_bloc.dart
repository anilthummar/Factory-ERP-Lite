import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/sync/sync_refresh_helper.dart';
import '../domain/entities/entities.dart';
import '../domain/usecases/delete_explorer_record_use_case.dart';
import '../domain/usecases/export_filtered_records_use_case.dart';
import '../domain/usecases/filter_records_use_case.dart';
import '../domain/usecases/search_records_use_case.dart';
import 'records_explorer_event.dart';
import 'records_explorer_state.dart';

/// BLoC for unified Records Explorer search, filters, and export.
class RecordsExplorerBloc
    extends Bloc<RecordsExplorerEvent, RecordsExplorerState> {
  /// Creates [RecordsExplorerBloc].
  RecordsExplorerBloc({
    required SearchRecordsUseCase searchRecordsUseCase,
    required FilterRecordsUseCase filterRecordsUseCase,
    required ExportFilteredRecordsUseCase exportFilteredRecordsUseCase,
    required DeleteExplorerRecordUseCase deleteExplorerRecordUseCase,
    String initialQuery = '',
  })  : _searchRecordsUseCase = searchRecordsUseCase,
        _filterRecordsUseCase = filterRecordsUseCase,
        _exportFilteredRecordsUseCase = exportFilteredRecordsUseCase,
        _deleteExplorerRecordUseCase = deleteExplorerRecordUseCase,
        super(
          RecordsExplorerState(
            filters: ExplorerFilters(searchQuery: initialQuery),
          ),
        ) {
    on<RecordsExplorerLoadRequested>(_onLoad);
    on<RecordsExplorerRefreshRequested>(_onRefresh);
    on<RecordsExplorerSearchChanged>(_onSearchChanged);
    on<RecordsExplorerFiltersChanged>(_onFiltersChanged);
    on<RecordsExplorerFiltersCleared>(_onFiltersCleared);
    on<RecordsExplorerLoadMoreRequested>(_onLoadMore);
    on<RecordsExplorerExportPdfRequested>(_onExportPdf);
    on<RecordsExplorerExportExcelRequested>(_onExportExcel);
    on<RecordsExplorerDeleteRequested>(_onDelete);

    add(const RecordsExplorerLoadRequested());
  }

  static const int _pageSize = 25;
  static const Duration _searchDebounce = Duration(milliseconds: 350);

  final SearchRecordsUseCase _searchRecordsUseCase;
  final FilterRecordsUseCase _filterRecordsUseCase;
  final ExportFilteredRecordsUseCase _exportFilteredRecordsUseCase;
  final DeleteExplorerRecordUseCase _deleteExplorerRecordUseCase;

  Timer? _debounceTimer;

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoad(
    RecordsExplorerLoadRequested event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RecordsExplorerStatus.loading,
        clearError: true,
      ),
    );
    await _reload(emit);
  }

  Future<void> _onRefresh(
    RecordsExplorerRefreshRequested event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RecordsExplorerStatus.loading,
        clearError: true,
      ),
    );
    await pullRemoteBeforeLocalRefresh(() => _reload(emit));
  }

  Future<void> _onSearchChanged(
    RecordsExplorerSearchChanged event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    final ExplorerFilters updated =
        state.filters.copyWith(searchQuery: event.query);
    emit(state.copyWith(filters: updated));
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_searchDebounce, () {
      if (!isClosed) {
        add(RecordsExplorerFiltersChanged(updated));
      }
    });
  }

  Future<void> _onFiltersChanged(
    RecordsExplorerFiltersChanged event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    emit(state.copyWith(filters: event.filters));
    await _reload(emit, showLoading: false);
  }

  Future<void> _onFiltersCleared(
    RecordsExplorerFiltersCleared event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    emit(state.copyWith(filters: const ExplorerFilters()));
    await _reload(emit, showLoading: false);
  }

  Future<void> _onLoadMore(
    RecordsExplorerLoadMoreRequested event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    final int nextCount = state.visibleCount + _pageSize;
    final List<ExplorerRecordItem> visible =
        state.filteredRecords.take(nextCount).toList(growable: false);
    emit(
      state.copyWith(
        visibleRecords: visible,
        visibleCount: visible.length,
        hasMore: visible.length < state.filteredRecords.length,
      ),
    );
  }

  Future<void> _onExportPdf(
    RecordsExplorerExportPdfRequested event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    emit(state.copyWith(isExporting: true, clearError: true));
    try {
      await _exportFilteredRecordsUseCase.exportPdf(
        records: state.filteredRecords,
        generatedAt: DateTime.now(),
      );
      emit(state.copyWith(isExporting: false));
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: RecordsExplorerStatus.failure,
          isExporting: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onExportExcel(
    RecordsExplorerExportExcelRequested event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    emit(state.copyWith(isExporting: true, clearError: true));
    try {
      await _exportFilteredRecordsUseCase.exportExcel(
        records: state.filteredRecords,
        generatedAt: DateTime.now(),
      );
      emit(state.copyWith(isExporting: false));
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: RecordsExplorerStatus.failure,
          isExporting: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onDelete(
    RecordsExplorerDeleteRequested event,
    Emitter<RecordsExplorerState> emit,
  ) async {
    try {
      await _deleteExplorerRecordUseCase(event.record);
      await _reload(emit, showLoading: false);
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: RecordsExplorerStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _reload(
    Emitter<RecordsExplorerState> emit, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emit(
        state.copyWith(
          status: RecordsExplorerStatus.loading,
          clearError: true,
        ),
      );
    }

    try {
      final List<ExplorerRecordItem> searched = await _searchRecordsUseCase(
        query: state.filters.searchQuery,
      );
      final List<ExplorerRecordItem> filtered = _filterRecordsUseCase(
        records: searched,
        filters: state.filters,
      );
      final ExplorerSummaryStats summary =
          _filterRecordsUseCase.summarize(filtered);
      final List<ExplorerRecordItem> visible =
          filtered.take(_pageSize).toList(growable: false);

      emit(
        state.copyWith(
          status: RecordsExplorerStatus.success,
          filteredRecords: filtered,
          visibleRecords: visible,
          summary: summary,
          visibleCount: visible.length,
          hasMore: visible.length < filtered.length,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: RecordsExplorerStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
