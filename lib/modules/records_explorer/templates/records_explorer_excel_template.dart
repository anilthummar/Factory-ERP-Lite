import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../excel_export/templates/excel_report_helpers.dart';
import '../domain/entities/explorer_record_item.dart';

/// Builds an Excel export for filtered Records Explorer rows.
class RecordsExplorerExcelTemplate {
  /// Creates [RecordsExplorerExcelTemplate].
  const RecordsExplorerExcelTemplate();

  /// Renders workbook bytes for [records].
  Future<Uint8List> build({
    required List<ExplorerRecordItem> records,
    required DateTime generatedAt,
  }) async {
    final Excel workbook = Excel.createExcel();
    ExcelReportHelpers.removeDefaultSheets(
      workbook,
      <String>{'Records'},
    );
    final Sheet sheet = workbook['Records'];

    sheet.appendRow(
      ExcelReportHelpers.textRow(<String>[
        'Date',
        'Name',
        'Module',
        'Category',
        'Amount',
        'Notes',
        'Sync',
      ]),
    );

    for (final ExplorerRecordItem record in records) {
      sheet.appendRow(<CellValue>[
        ExcelReportHelpers.dateCell(record.recordDate),
        TextCellValue(record.name),
        TextCellValue(record.moduleType.name),
        TextCellValue(record.category),
        record.amount == null
            ? TextCellValue('—')
            : ExcelReportHelpers.currencyCell(record.amount!),
        TextCellValue(record.notes ?? ''),
        TextCellValue(record.syncStatus.name),
      ]);
    }

    sheet.setColumnAutoFit(0);
    sheet.setColumnAutoFit(1);
    sheet.setColumnAutoFit(2);

    return Uint8List.fromList(workbook.encode()!);
  }
}
