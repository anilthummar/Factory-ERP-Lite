import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/entities/expense_entity.dart';
import '../domain/models/report_data_snapshot.dart';
import 'pdf_report_theme.dart';

/// Builds the monthly summary PDF document.
class MonthlySummaryPdfTemplate {
  /// Creates [MonthlySummaryPdfTemplate].
  const MonthlySummaryPdfTemplate();

  /// Renders monthly summary bytes from [snapshot] for [month].
  Future<Uint8List> build(
    ReportDataSnapshot snapshot, {
    DateTime? month,
  }) async {
    final DateTime targetMonth = month ?? snapshot.generatedAt;
    final DateTime monthStart =
        DateTime(targetMonth.year, targetMonth.month);
    final DateTime monthEnd =
        DateTime(targetMonth.year, targetMonth.month + 1);

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

    final Map<String, double> byCategory = <String, double>{};
    for (final ExpenseEntity expense in monthExpenses) {
      final String key = expense.category.name;
      byCategory[key] = (byCategory[key] ?? 0) + expense.amount;
    }

    final double laborWageTotal = snapshot.labor.fold<double>(
      0,
      (double sum, LaborEntity labor) => sum + labor.dailyWage,
    );

    final String monthLabel = DateFormat('MMMM yyyy').format(monthStart);

    final pw.Document document = pw.Document(
      title: 'Monthly Summary',
      creator: 'Factory ERP Lite',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          PdfReportTheme.buildHeader(
            title: 'Monthly Summary',
            generatedAt: snapshot.generatedAt,
            subtitle: monthLabel,
          ),
          pw.SizedBox(height: 16),
          PdfReportTheme.buildSummaryGrid(
            <PdfSummaryMetric>[
              PdfSummaryMetric(
                label: 'Month Expenses',
                value: formatCurrency(monthExpenseTotal),
              ),
              PdfSummaryMetric(
                label: 'Expense Records',
                value: '${monthExpenses.length}',
              ),
              PdfSummaryMetric(
                label: 'Total Labor',
                value: '${snapshot.labor.length}',
              ),
              PdfSummaryMetric(
                label: 'Total Persons',
                value: '${snapshot.persons.length}',
              ),
              PdfSummaryMetric(
                label: 'Labor Daily Wage Sum',
                value: formatCurrency(laborWageTotal),
              ),
              PdfSummaryMetric(
                label: 'Pending Sync',
                value: '${snapshot.pendingSyncCount}',
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Expense Breakdown ($monthLabel)',
            style: PdfReportTheme.sectionTitleStyle,
          ),
          pw.SizedBox(height: 8),
          PdfReportTheme.buildDataTable(
            headers: <String>['Category', 'Amount', 'Records'],
            rows: byCategory.entries
                .map((MapEntry<String, double> entry) {
              final int count = monthExpenses
                  .where((ExpenseEntity expense) => expense.category.name == entry.key)
                  .length;
              return <String>[
                categoryLabel(entry.key),
                formatCurrency(entry.value),
                '$count',
              ];
            }).toList(),
            emptyMessage: 'No expenses recorded for this month.',
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Recent Month Expenses',
            style: PdfReportTheme.sectionTitleStyle,
          ),
          pw.SizedBox(height: 8),
          PdfReportTheme.buildDataTable(
            headers: <String>['Date', 'Title', 'Category', 'Amount'],
            rows: monthExpenses
                .take(50)
                .map(
                  (ExpenseEntity expense) => <String>[
                    formatDate(expense.date),
                    expense.title,
                    categoryLabel(expense.category.name),
                    formatCurrency(expense.amount),
                  ],
                )
                .toList(),
            emptyMessage: 'No expenses recorded for this month.',
          ),
        ],
        footer: PdfReportTheme.buildFooter,
      ),
    );

    return document.save();
  }
}
