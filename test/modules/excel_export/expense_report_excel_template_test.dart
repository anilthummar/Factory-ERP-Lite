import 'package:excel/excel.dart';
import 'package:factory_erp_lite/core/domain/entities/expense_entity.dart';
import 'package:factory_erp_lite/core/domain/entities/labor_entity.dart';
import 'package:factory_erp_lite/core/domain/entities/person_entity.dart';
import 'package:factory_erp_lite/core/domain/entities/recurring_expense_entity.dart';
import 'package:factory_erp_lite/core/domain/enums/expense_category.dart';
import 'package:factory_erp_lite/core/enums/sync_status.dart';
import 'package:factory_erp_lite/modules/excel_export/mapper/expense_report_mapper.dart';
import 'package:factory_erp_lite/modules/excel_export/mapper/report_mapper_models.dart';
import 'package:factory_erp_lite/modules/excel_export/templates/expense_report_excel_template.dart';
import 'package:factory_erp_lite/modules/pdf_export/domain/models/report_data_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('expense report excel template generates valid multi-sheet xlsx', () async {
    final ReportDataSnapshot snapshot = ReportDataSnapshot(
      persons: const <PersonEntity>[],
      labor: const <LaborEntity>[],
      expenses: const <ExpenseEntity>[],
      recurringExpenses: const <RecurringExpenseEntity>[],
      pendingSyncCount: 0,
      generatedAt: DateTime(2026, 6, 23, 12),
    );

    final List<int> bytes =
        await const ExpenseReportExcelTemplate().build(snapshot);

    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(2)), 'PK');

    final Excel workbook = Excel.decodeBytes(bytes);
    expect(
      workbook.sheets.keys.toSet(),
      containsAll(<String>['Summary', 'Categories', 'Expenses']),
    );
  });

  test('expense report mapper aggregates category breakdown', () {
    final ReportDataSnapshot snapshot = ReportDataSnapshot(
      persons: const <PersonEntity>[],
      labor: const <LaborEntity>[],
      expenses: <ExpenseEntity>[
        ExpenseEntity(
          id: '1',
          createdAt: DateTime(2026, 6, 1),
          updatedAt: DateTime(2026, 6, 1),
          syncStatus: SyncStatus.synced,
          title: 'Power',
          category: ExpenseCategory.electricity,
          amount: 100,
          date: DateTime(2026, 6, 1),
        ),
        ExpenseEntity(
          id: '2',
          createdAt: DateTime(2026, 6, 2),
          updatedAt: DateTime(2026, 6, 2),
          syncStatus: SyncStatus.synced,
          title: 'Water',
          category: ExpenseCategory.electricity,
          amount: 50,
          date: DateTime(2026, 6, 2),
        ),
      ],
      recurringExpenses: const <RecurringExpenseEntity>[],
      pendingSyncCount: 0,
      generatedAt: DateTime(2026, 6, 23),
    );

    final ExpenseReportMappedData mapped = const ExpenseReportMapper().map(snapshot);

    expect(mapped.summary.first.label, 'Total Records');
    expect(mapped.summary.first.value, '2');
    expect(mapped.categoryBreakdown, hasLength(1));
    expect(mapped.categoryBreakdown.first.recordCount, 2);
    expect(mapped.categoryBreakdown.first.amount, 150);
    expect(mapped.details, hasLength(2));
  });
}
