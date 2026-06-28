import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../pdf_export/domain/models/report_data_snapshot.dart';
import '../mapper/labor_report_mapper.dart';
import '../mapper/report_mapper_models.dart';
import 'excel_report_helpers.dart';

/// Builds the labor report Excel workbook.
class LaborReportExcelTemplate {
  /// Creates [LaborReportExcelTemplate].
  const LaborReportExcelTemplate({
    LaborReportMapper mapper = const LaborReportMapper(),
  }) : _mapper = mapper;

  final LaborReportMapper _mapper;

  static const Set<String> _sheetNames = <String>{
    'Summary',
    'Labor',
  };

  /// Renders labor report XLSX bytes from [snapshot].
  Future<Uint8List> build(ReportDataSnapshot snapshot) async {
    final LaborReportMappedData data = _mapper.map(snapshot);
    final Excel workbook = Excel.createExcel();

    _buildSummarySheet(workbook, data);
    _buildLaborSheet(workbook, data);

    ExcelReportHelpers.removeDefaultSheets(workbook, _sheetNames);
    return ExcelReportHelpers.encodeWorkbook(workbook);
  }

  void _buildSummarySheet(Excel workbook, LaborReportMappedData data) {
    final Sheet sheet = workbook['Summary'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Labor Report',
      generatedAt: data.generatedAt,
      subtitle: 'Workforce overview',
    );
    ExcelReportHelpers.appendSummaryMetrics(sheet, data.summary);
  }

  void _buildLaborSheet(Excel workbook, LaborReportMappedData data) {
    final Sheet sheet = workbook['Labor'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Labor Details',
      generatedAt: data.generatedAt,
    );
    ExcelReportHelpers.appendStyledTableHeader(
      sheet,
      <String>['Name', 'Skill', 'Mobile', 'Daily Wage', 'Notes'],
    );
    final int firstDataRow = sheet.maxRows;
    for (final LaborDetailRow row in data.details) {
      sheet.appendRow(<CellValue>[
        TextCellValue(row.name),
        TextCellValue(row.skill),
        TextCellValue(row.mobile),
        ExcelReportHelpers.currencyCell(row.dailyWage),
        TextCellValue(row.notes),
      ]);
    }
    if (data.details.isNotEmpty) {
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
