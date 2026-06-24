import '../../../../core/domain/entities/expense_entity.dart';
import '../../../../core/domain/entities/labor_entity.dart';
import '../../../../core/domain/entities/person_entity.dart';
import '../../../../core/domain/entities/recurring_expense_entity.dart';

/// Aggregated ERP data used to build PDF reports.
class ReportDataSnapshot {
  /// Creates [ReportDataSnapshot].
  const ReportDataSnapshot({
    required this.persons,
    required this.labor,
    required this.expenses,
    required this.recurringExpenses,
    required this.pendingSyncCount,
    required this.generatedAt,
  });

  /// All person records.
  final List<PersonEntity> persons;

  /// All labor records.
  final List<LaborEntity> labor;

  /// All one-time expense records across modules.
  final List<ExpenseEntity> expenses;

  /// All recurring expense schedules.
  final List<RecurringExpenseEntity> recurringExpenses;

  /// Pending sync queue count at export time.
  final int pendingSyncCount;

  /// When the snapshot was captured.
  final DateTime generatedAt;
}
