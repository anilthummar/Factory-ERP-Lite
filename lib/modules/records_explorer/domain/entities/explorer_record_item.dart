import 'package:equatable/equatable.dart';

import '../../../../core/enums/sync_status.dart';
import '../enums/explorer_module_type.dart';

/// Unified business record shown in Records Explorer.
class ExplorerRecordItem extends Equatable {
  /// Creates [ExplorerRecordItem].
  const ExplorerRecordItem({
    required this.id,
    required this.sourceId,
    required this.moduleType,
    required this.name,
    required this.category,
    required this.recordDate,
    required this.syncStatus,
    this.amount,
    this.notes,
    this.searchText = '',
  });

  /// Stable list key (module + source id).
  final String id;

  /// Underlying entity identifier.
  final String sourceId;

  /// ERP module this record belongs to.
  final ExplorerModuleType moduleType;

  /// Primary display name or title.
  final String name;

  /// Category or sub-type label.
  final String category;

  /// Primary sort/filter date.
  final DateTime recordDate;

  /// Offline sync status.
  final SyncStatus syncStatus;

  /// Monetary value when applicable.
  final double? amount;

  /// Optional notes or description.
  final String? notes;

  /// Lowercase text used for global search.
  final String searchText;

  @override
  List<Object?> get props => <Object?>[
        id,
        sourceId,
        moduleType,
        name,
        category,
        recordDate,
        syncStatus,
        amount,
        notes,
        searchText,
      ];
}
