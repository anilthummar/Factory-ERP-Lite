import '../../../core/domain/entities/expense_entity.dart';
import '../../pdf_export/domain/models/report_data_snapshot.dart';
import '../templates/excel_report_helpers.dart';
import 'report_mapper_models.dart';

/// Maps domain entities to expense report Excel rows.
class ExpenseReportMapper {
  /// Creates [ExpenseReportMapper].
  const ExpenseReportMapper();

  /// Builds mapped expense report data from [snapshot].
  ExpenseReportMappedData map(ReportDataSnapshot snapshot) {
    final double totalAmount = snapshot.expenses.fold<double>(
      0,
      (double sum, ExpenseEntity expense) => sum + expense.amount,
    );
    final Map<String, double> amountsByCategory = <String, double>{};
    final Map<String, int> countsByCategory = <String, int>{};

    for (final ExpenseEntity expense in snapshot.expenses) {
      final String key = expense.category.name;
      amountsByCategory[key] = (amountsByCategory[key] ?? 0) + expense.amount;
      countsByCategory[key] = (countsByCategory[key] ?? 0) + 1;
    }

    final List<CategoryAmountRow> categoryBreakdown =
        amountsByCategory.entries
            .map(
              (MapEntry<String, double> entry) => CategoryAmountRow(
                category: ExcelReportHelpers.categoryLabel(entry.key),
                amount: entry.value,
                recordCount: countsByCategory[entry.key] ?? 0,
              ),
            )
            .toList(growable: false);

    return ExpenseReportMappedData(
      generatedAt: snapshot.generatedAt,
      summary: <SummaryMetricRow>[
        SummaryMetricRow(
          label: 'Total Records',
          value: '${snapshot.expenses.length}',
        ),
        SummaryMetricRow(
          label: 'Total Amount',
          value: ExcelReportHelpers.formatCurrency(totalAmount),
        ),
        SummaryMetricRow(
          label: 'Recurring Schedules',
          value: '${snapshot.recurringExpenses.length}',
        ),
        SummaryMetricRow(
          label: 'Categories',
          value: '${categoryBreakdown.length}',
        ),
      ],
      categoryBreakdown: categoryBreakdown,
      details: snapshot.expenses
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
