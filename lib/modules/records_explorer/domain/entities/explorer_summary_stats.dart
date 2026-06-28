import 'package:equatable/equatable.dart';

/// Dashboard and footer summary metrics for Records Explorer.
class ExplorerSummaryStats extends Equatable {
  /// Creates [ExplorerSummaryStats].
  const ExplorerSummaryStats({
    this.totalRecords = 0,
    this.totalAmount = 0,
    this.totalPersons = 0,
    this.totalLabor = 0,
    this.totalExpenses = 0,
    this.pendingSyncCount = 0,
    this.averageAmount = 0,
    this.highestAmount = 0,
    this.lowestAmount = 0,
  });

  /// Count of filtered records.
  final int totalRecords;

  /// Sum of monetary amounts in filtered records.
  final double totalAmount;

  /// Person records in filtered set.
  final int totalPersons;

  /// Labor records in filtered set.
  final int totalLabor;

  /// Expense-like records in filtered set.
  final int totalExpenses;

  /// Pending sync items in filtered set.
  final int pendingSyncCount;

  /// Average amount across records with amounts.
  final double averageAmount;

  /// Highest amount in filtered set.
  final double highestAmount;

  /// Lowest amount in filtered set.
  final double lowestAmount;

  @override
  List<Object?> get props => <Object?>[
        totalRecords,
        totalAmount,
        totalPersons,
        totalLabor,
        totalExpenses,
        pendingSyncCount,
        averageAmount,
        highestAmount,
        lowestAmount,
      ];
}
