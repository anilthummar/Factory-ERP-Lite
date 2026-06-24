import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../pdf_export/domain/models/report_data_snapshot.dart';
import '../mapper/person_report_mapper.dart';
import '../mapper/report_mapper_models.dart';
import 'excel_report_helpers.dart';

/// Builds the person report Excel workbook.
class PersonReportExcelTemplate {
  /// Creates [PersonReportExcelTemplate].
  const PersonReportExcelTemplate({
    PersonReportMapper mapper = const PersonReportMapper(),
  }) : _mapper = mapper;

  final PersonReportMapper _mapper;

  static const Set<String> _sheetNames = <String>{
    'Summary',
    'Persons',
  };

  /// Renders person report XLSX bytes from [snapshot].
  Future<Uint8List> build(ReportDataSnapshot snapshot) async {
    final PersonReportMappedData data = _mapper.map(snapshot);
    final Excel workbook = Excel.createExcel();

    _buildSummarySheet(workbook, data);
    _buildPersonsSheet(workbook, data);

    ExcelReportHelpers.removeDefaultSheets(workbook, _sheetNames);
    return ExcelReportHelpers.encodeWorkbook(workbook);
  }

  void _buildSummarySheet(Excel workbook, PersonReportMappedData data) {
    final Sheet sheet = workbook['Summary'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Person Report',
      generatedAt: data.generatedAt,
      subtitle: 'Contacts and persons directory',
    );
    ExcelReportHelpers.appendSummaryMetrics(sheet, data.summary);
  }

  void _buildPersonsSheet(Excel workbook, PersonReportMappedData data) {
    final Sheet sheet = workbook['Persons'];
    ExcelReportHelpers.appendTitleBlock(
      sheet,
      title: 'Person Details',
      generatedAt: data.generatedAt,
    );
    ExcelReportHelpers.appendStyledTableHeader(
      sheet,
      <String>['Name', 'Mobile', 'Address', 'Notes'],
    );
    for (final PersonDetailRow row in data.details) {
      sheet.appendRow(<CellValue>[
        TextCellValue(row.name),
        TextCellValue(row.mobile),
        TextCellValue(row.address),
        TextCellValue(row.notes),
      ]);
    }
  }
}
