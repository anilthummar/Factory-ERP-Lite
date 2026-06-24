import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../pdf_export/domain/models/report_data_snapshot.dart';
import '../mapper/expense_report_mapper.dart';
import '../mapper/report_mapper_models.dart';
import 'excel_report_helpers.dart';

/// Builds the expense report Excel workbook.
class ExpenseReportExcelTemplate {
  /// Creates [ExpenseReportExcelTemplate].
  const ExpenseReportExcelTemplate({
    ExpenseReportMapper mapper = const ExpenseReportMapper(),
  }) : _mapper = mapper;

  final ExpenseReportMapper _mapper;

  static const Set<String> _sheetNames = <String>{
    'Summary',
    'Categories',
    'Expenses',
  };

  /// Renders expense report XLSX bytes from [snapshot].
  Future<Uint8List> build(ReportDataSnapshot snapshot) async {
    final ExpenseReportMappedData data = _mapper.map(snapshot);
    final Excel workbook = Excel.createExcel();

    _buildSummarySheet(workbook, data);
    _buildCategoriesSheet(workbook, data);
    _buildExpensesSheet(workbook, data);

    ExcelReportHelpers.removeDefaultSheets(workbook, _sheetNames);
    return ExcelReportHelpers.encodeWorkbook(workbook);
  }

  void _buildSummarySheet(Excel workbook, ExpenseReportMappedData data) {
    final Sheet sheet = workbook['Summary'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Expense Report',
      generatedAt: data.generatedAt,
      subtitle: 'All expense modules',
    );
    ExcelReportHelpers.appendSummaryMetrics(sheet, data.summary);
  }

  void _buildCategoriesSheet(Excel workbook, ExpenseReportMappedData data) {
    final Sheet sheet = workbook['Categories'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Category Breakdown',
      generatedAt: data.generatedAt,
    );
    ExcelReportHelpers.appendStyledTableHeader(
      sheet,
      <String>['Category', 'Amount', 'Records'],
    );
    final int firstDataRow = sheet.maxRows;
    for (final CategoryAmountRow row in data.categoryBreakdown) {
      sheet.appendRow(<CellValue>[
        TextCellValue(row.category),
        ExcelReportHelpers.currencyCell(row.amount),
        IntCellValue(row.recordCount),
      ]);
    }
    if (data.categoryBreakdown.isNotEmpty) {
      ExcelReportHelpers.applyColumnNumberFormat(
        sheet,
        columnIndex: 1,
        firstDataRow: firstDataRow,
        lastDataRow: sheet.maxRows - 1,
        format: ExcelReportHelpers.currencyFormat,
      );
    }
  }

  void _buildExpensesSheet(Excel workbook, ExpenseReportMappedData data) {
    final Sheet sheet = workbook['Expenses'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Expense Details',
      generatedAt: data.generatedAt,
    );
    ExcelReportHelpers.appendStyledTableHeader(
      sheet,
      <String>['Date', 'Title', 'Category', 'Amount', 'Notes'],
    );
    final int firstDataRow = sheet.maxRows;
    for (final ExpenseDetailRow row in data.details) {
      sheet.appendRow(<CellValue>[
        ExcelReportHelpers.dateCell(row.date),
        TextCellValue(row.title),
        TextCellValue(row.category),
        ExcelReportHelpers.currencyCell(row.amount),
        TextCellValue(row.notes),
      ]);
    }
    if (data.details.isNotEmpty) {
      ExcelReportHelpers.applyColumnNumberFormat(
        sheet,
        columnIndex: 0,
        firstDataRow: firstDataRow,
        lastDataRow: sheet.maxRows - 1,
        format: ExcelReportHelpers.dateFormat,
      );
      ExcelReportHelpers.applyColumnNumberFormat(
        sheet,
        columnIndex: 3,
        firstDataRow: firstDataRow,
        lastDataRow: sheet.maxRows - 1,
        format: ExcelReportHelpers.currencyFormat,
      );
    }
  }
}
