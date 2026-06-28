import 'package:equatable/equatable.dart';

import '../domain/entities/entities.dart';

/// Records Explorer BLoC events.
sealed class RecordsExplorerEvent extends Equatable {
  const RecordsExplorerEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads or reloads all records.
final class RecordsExplorerLoadRequested extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerLoadRequested].
  const RecordsExplorerLoadRequested();
}

/// Pulls remote data then reloads.
final class RecordsExplorerRefreshRequested extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerRefreshRequested].
  const RecordsExplorerRefreshRequested();
}

/// Updates the search query (debounced in BLoC).
final class RecordsExplorerSearchChanged extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerSearchChanged].
  const RecordsExplorerSearchChanged(this.query);

  /// Search text.
  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

/// Applies advanced filters.
final class RecordsExplorerFiltersChanged extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerFiltersChanged].
  const RecordsExplorerFiltersChanged(this.filters);

  /// New filter set.
  final ExplorerFilters filters;

  @override
  List<Object?> get props => <Object?>[filters];
}

/// Clears all filters.
final class RecordsExplorerFiltersCleared extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerFiltersCleared].
  const RecordsExplorerFiltersCleared();
}

/// Loads the next page of results.
final class RecordsExplorerLoadMoreRequested extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerLoadMoreRequested].
  const RecordsExplorerLoadMoreRequested();
}

/// Exports filtered data to PDF.
final class RecordsExplorerExportPdfRequested extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerExportPdfRequested].
  const RecordsExplorerExportPdfRequested();
}

/// Exports filtered data to Excel.
final class RecordsExplorerExportExcelRequested extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerExportExcelRequested].
  const RecordsExplorerExportExcelRequested();
}

/// Deletes a record via the source module.
final class RecordsExplorerDeleteRequested extends RecordsExplorerEvent {
  /// Creates [RecordsExplorerDeleteRequested].
  const RecordsExplorerDeleteRequested(this.record);

  /// Record to delete.
  final ExplorerRecordItem record;

  @override
  List<Object?> get props => <Object?>[record];
}
