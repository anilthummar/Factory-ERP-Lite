import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/domain/entities/expense_entity.dart';
import '../domain/models/report_data_snapshot.dart';
import 'pdf_report_theme.dart';

/// Builds the expense report PDF document.
class ExpenseReportPdfTemplate {
  /// Creates [ExpenseReportPdfTemplate].
  const ExpenseReportPdfTemplate();

  /// Renders expense report bytes from [snapshot].
  Future<Uint8List> build(ReportDataSnapshot snapshot) async {
    final double totalAmount = snapshot.expenses.fold<double>(
      0,
      (double sum, ExpenseEntity expense) => sum + expense.amount,
    );
    final Map<String, double> byCategory = <String, double>{};
    for (final ExpenseEntity expense in snapshot.expenses) {
      final String key = expense.category.name;
      byCategory[key] = (byCategory[key] ?? 0) + expense.amount;
    }

    final pw.Document document = pw.Document(
      title: 'Expense Report',
      creator: 'Factory ERP Lite',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          PdfReportTheme.buildHeader(
            title: 'Expense Report',
            generatedAt: snapshot.generatedAt,
            subtitle: 'All expense modules',
          ),
          pw.SizedBox(height: 16),
          PdfReportTheme.buildSummaryGrid(
            <PdfSummaryMetric>[
              PdfSummaryMetric(
                label: 'Total Records',
                value: '${snapshot.expenses.length}',
              ),
              PdfSummaryMetric(
                label: 'Total Amount',
                value: formatCurrency(totalAmount),
              ),
              PdfSummaryMetric(
                label: 'Recurring Schedules',
                value: '${snapshot.recurringExpenses.length}',
              ),
              PdfSummaryMetric(
                label: 'Categories',
                value: '${byCategory.length}',
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Category Breakdown', style: PdfReportTheme.sectionTitleStyle),
          pw.SizedBox(height: 8),
          PdfReportTheme.buildDataTable(
            headers: <String>['Category', 'Amount'],
            rows: byCategory.entries
                .map(
                  (MapEntry<String, double> entry) => <String>[
                    categoryLabel(entry.key),
                    formatCurrency(entry.value),
                  ],
                )
                .toList(),
            emptyMessage: 'No expenses recorded.',
          ),
          pw.SizedBox(height: 20),
          pw.Text('Expense Details', style: PdfReportTheme.sectionTitleStyle),
          pw.SizedBox(height: 8),
          PdfReportTheme.buildDataTable(
            headers: <String>['Date', 'Title', 'Category', 'Amount', 'Notes'],
            rows: snapshot.expenses
                .map(
                  (ExpenseEntity expense) => <String>[
                    formatDate(expense.date),
                    expense.title,
                    categoryLabel(expense.category.name),
                    formatCurrency(expense.amount),
                    expense.notes ?? '—',
                  ],
                )
                .toList(),
          ),
        ],
        footer: PdfReportTheme.buildFooter,
      ),
    );

    return document.save();
  }
}
