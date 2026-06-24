import 'package:factory_erp_lite/core/domain/entities/expense_entity.dart';
import 'package:factory_erp_lite/core/domain/entities/labor_entity.dart';
import 'package:factory_erp_lite/core/domain/entities/person_entity.dart';
import 'package:factory_erp_lite/core/domain/entities/recurring_expense_entity.dart';
import 'package:factory_erp_lite/modules/pdf_export/domain/models/report_data_snapshot.dart';
import 'package:factory_erp_lite/modules/pdf_export/templates/expense_report_pdf_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('expense report template generates non-empty PDF bytes', () async {
    final ReportDataSnapshot snapshot = ReportDataSnapshot(
      persons: const <PersonEntity>[],
      labor: const <LaborEntity>[],
      expenses: const <ExpenseEntity>[],
      recurringExpenses: const <RecurringExpenseEntity>[],
      pendingSyncCount: 0,
      generatedAt: DateTime(2026, 6, 23, 12),
    );

    final List<int> bytes =
        await const ExpenseReportPdfTemplate().build(snapshot);

    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
