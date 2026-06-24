import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../pdf_export/domain/models/report_data_snapshot.dart';
import '../mapper/monthly_summary_report_mapper.dart';
import '../mapper/report_mapper_models.dart';
import 'excel_report_helpers.dart';

/// Builds the monthly summary Excel workbook.
class MonthlySummaryExcelTemplate {
  /// Creates [MonthlySummaryExcelTemplate].
  const MonthlySummaryExcelTemplate({
    MonthlySummaryReportMapper mapper = const MonthlySummaryReportMapper(),
  }) : _mapper = mapper;

  final MonthlySummaryReportMapper _mapper;

  static const Set<String> _sheetNames = <String>{
    'Summary',
    'Categories',
    'Expenses',
  };

  /// Renders monthly summary XLSX bytes from [snapshot] for [month].
  Future<Uint8List> build(
    ReportDataSnapshot snapshot, {
    DateTime? month,
  }) async {
    final MonthlySummaryMappedData data = _mapper.map(snapshot, month: month);
    final Excel workbook = Excel.createExcel();

    _buildSummarySheet(workbook, data);
    _buildCategoriesSheet(workbook, data);
    _buildExpensesSheet(workbook, data);

    ExcelReportHelpers.removeDefaultSheets(workbook, _sheetNames);
    return ExcelReportHelpers.encodeWorkbook(workbook);
  }

  void _buildSummarySheet(Excel workbook, MonthlySummaryMappedData data) {
    final Sheet sheet = workbook['Summary'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Monthly Summary',
      generatedAt: data.generatedAt,
      subtitle: data.monthLabel,
    );
    ExcelReportHelpers.appendSummaryMetrics(sheet, data.summary);
  }

  void _buildCategoriesSheet(Excel workbook, MonthlySummaryMappedData data) {
    final Sheet sheet = workbook['Categories'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Expense Breakdown (${data.monthLabel})',
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

  void _buildExpensesSheet(Excel workbook, MonthlySummaryMappedData data) {
    final Sheet sheet = workbook['Expenses'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Month Expenses (${data.monthLabel})',
      generatedAt: data.generatedAt,
    );
    ExcelReportHelpers.appendStyledTableHeader(
      sheet,
      <String>['Date', 'Title', 'Category', 'Amount', 'Notes'],
    );
    final int firstDataRow = sheet.maxRows;
    for (final ExpenseDetailRow row in data.monthExpenses) {
      sheet.appendRow(<CellValue>[
        ExcelReportHelpers.dateCell(row.date),
        TextCellValue(row.title),
        TextCellValue(row.category),
        ExcelReportHelpers.currencyCell(row.amount),
        TextCellValue(row.notes),
      ]);
    }
    if (data.monthExpenses.isNotEmpty) {
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
