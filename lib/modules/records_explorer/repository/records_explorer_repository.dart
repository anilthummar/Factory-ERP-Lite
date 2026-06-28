import '../domain/entities/explorer_record_item.dart';

/// Loads aggregated ERP records for Records Explorer.
abstract class RecordsExplorerRepository {
  /// Returns all business records from local repositories (offline-first).
  Future<List<ExplorerRecordItem>> loadAllRecords();
}
