import 'package:intl/intl.dart';

import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../../pdf_export/domain/models/report_data_snapshot.dart';
import '../templates/excel_report_helpers.dart';
import 'report_mapper_models.dart';

/// Maps domain entities to monthly summary Excel rows.
class MonthlySummaryReportMapper {
  /// Creates [MonthlySummaryReportMapper].
  const MonthlySummaryReportMapper();

  /// Builds mapped monthly summary data from [snapshot] for [month].
  MonthlySummaryMappedData map(
    ReportDataSnapshot snapshot, {
    DateTime? month,
  }) {
    final DateTime targetMonth = month ?? snapshot.generatedAt;
    final DateTime monthStart =
        DateTime(targetMonth.year, targetMonth.month);
    final DateTime monthEnd =
        DateTime(targetMonth.year, targetMonth.month + 1);
    final String monthLabel = DateFormat('MMMM yyyy').format(monthStart);

    final List<ExpenseEntity> monthExpenses = snapshot.expenses
        .where(
          (ExpenseEntity expense) =>
              !expense.date.isBefore(monthStart) &&
              expense.date.isBefore(monthEnd),
        )
        .toList();

    final double monthExpenseTotal = monthExpenses.fold<double>(
      0,
      (double sum, ExpenseEntity expense) => sum + expense.amount,
    );

    final Map<String, double> amountsByCategory = <String, double>{};
    final Map<String, int> countsByCategory = <String, int>{};
    for (final ExpenseEntity expense in monthExpenses) {
      final String key = expense.category.name;
      amountsByCategory[key] = (amountsByCategory[key] ?? 0) + expense.amount;
      countsByCategory[key] = (countsByCategory[key] ?? 0) + 1;
    }

    final double laborWageTotal = snapshot.labor.fold<double>(
      0,
      (double sum, LaborEntity labor) => sum + labor.dailyWage,
    );

    return MonthlySummaryMappedData(
      generatedAt: snapshot.generatedAt,
      monthLabel: monthLabel,
      summary: <SummaryMetricRow>[
        SummaryMetricRow(
          label: 'Month Expenses',
          value: ExcelReportHelpers.formatCurrency(monthExpenseTotal),
        ),
        SummaryMetricRow(
          label: 'Expense Records',
          value: '${monthExpenses.length}',
        ),
        SummaryMetricRow(
          label: 'Total Labor',
          value: '${snapshot.labor.length}',
        ),
        SummaryMetricRow(
          label: 'Total Persons',
          value: '${snapshot.persons.length}',
        ),
        SummaryMetricRow(
          label: 'Labor Daily Wage Sum',
          value: ExcelReportHelpers.formatCurrency(laborWageTotal),
        ),
        SummaryMetricRow(
          label: 'Pending Sync',
          value: '${snapshot.pendingSyncCount}',
        ),
      ],
      categoryBreakdown: amountsByCategory.entries
          .map(
            (MapEntry<String, double> entry) => CategoryAmountRow(
              category: ExcelReportHelpers.categoryLabel(entry.key),
              amount: entry.value,
              recordCount: countsByCategory[entry.key] ?? 0,
            ),
          )
          .toList(growable: false),
      monthExpenses: monthExpenses
          .map(
            (ExpenseEntity expense) => ExpenseDetailRow(
              date: expense.date,
              title: expense.title,
              category: ExcelReportHelpers.categoryLabel(expense.category.name),
              amount: expense.amount,
              notes: expense.notes ?? '',
            ),
          )
          .toList(growable: false),
    );
  }
}
