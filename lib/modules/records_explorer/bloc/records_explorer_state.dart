import 'package:equatable/equatable.dart';

import '../domain/entities/entities.dart';

/// Records Explorer loading status.
enum RecordsExplorerStatus {
  /// Initial state.
  initial,

  /// Loading data.
  loading,

  /// Data ready.
  success,

  /// Load or export failed.
  failure,

  /// Export in progress.
  exporting,
}

/// Records Explorer BLoC state.
class RecordsExplorerState extends Equatable {
  /// Creates [RecordsExplorerState].
  const RecordsExplorerState({
    this.status = RecordsExplorerStatus.initial,
    this.filters = const ExplorerFilters(),
    this.filteredRecords = const <ExplorerRecordItem>[],
    this.visibleRecords = const <ExplorerRecordItem>[],
    this.summary = const ExplorerSummaryStats(),
    this.visibleCount = 0,
    this.hasMore = false,
    this.errorMessage,
    this.isExporting = false,
  });

  /// Current status.
  final RecordsExplorerStatus status;

  /// Active filters.
  final ExplorerFilters filters;

  /// Full filtered result set.
  final List<ExplorerRecordItem> filteredRecords;

  /// Paginated slice shown in the list.
  final List<ExplorerRecordItem> visibleRecords;

  /// Summary metrics for filtered data.
  final ExplorerSummaryStats summary;

  /// Number of visible rows.
  final int visibleCount;

  /// Whether more pages are available.
  final bool hasMore;

  /// Error message when [status] is [RecordsExplorerStatus.failure].
  final String? errorMessage;

  /// Export operation in progress.
  final bool isExporting;

  /// Returns a copy with selective overrides.
  RecordsExplorerState copyWith({
    RecordsExplorerStatus? status,
    ExplorerFilters? filters,
    List<ExplorerRecordItem>? filteredRecords,
    List<ExplorerRecordItem>? visibleRecords,
    ExplorerSummaryStats? summary,
    int? visibleCount,
    bool? hasMore,
    String? errorMessage,
    bool? isExporting,
    bool clearError = false,
  }) {
    return RecordsExplorerState(
      status: status ?? this.status,
      filters: filters ?? this.filters,
      filteredRecords: filteredRecords ?? this.filteredRecords,
      visibleRecords: visibleRecords ?? this.visibleRecords,
      summary: summary ?? this.summary,
      visibleCount: visibleCount ?? this.visibleCount,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isExporting: isExporting ?? this.isExporting,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        filters,
        filteredRecords,
        visibleRecords,
        summary,
        visibleCount,
        hasMore,
        errorMessage,
        isExporting,
      ];
}
