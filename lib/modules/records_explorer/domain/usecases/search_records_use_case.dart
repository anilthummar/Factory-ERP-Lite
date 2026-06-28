import '../entities/explorer_record_item.dart';
import '../../repository/records_explorer_repository.dart';

/// Loads all ERP records and applies a global text search.
class SearchRecordsUseCase {
  /// Creates [SearchRecordsUseCase].
  const SearchRecordsUseCase(this._repository);

  final RecordsExplorerRepository _repository;

  /// Loads records and filters by [query] when non-empty.
  Future<List<ExplorerRecordItem>> call({String query = ''}) async {
    final List<ExplorerRecordItem> records = await _repository.loadAllRecords();
    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return records;
    }

    return records
        .where(
          (ExplorerRecordItem record) =>
              record.name.toLowerCase().contains(normalized) ||
              record.searchText.contains(normalized) ||
              (record.notes?.toLowerCase().contains(normalized) ?? false) ||
              record.category.toLowerCase().contains(normalized),
        )
        .toList(growable: false);
  }
}
