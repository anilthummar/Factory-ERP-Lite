import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

import '../mapper/report_mapper_models.dart';

/// Shared helpers for ERP Excel report workbooks.
abstract final class ExcelReportHelpers {
  static final CellStyle _headerStyle = CellStyle(
    bold: true,
    fontColorHex: ExcelColor.white,
    backgroundColorHex: ExcelColor.blue800,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  static final CellStyle _sectionTitleStyle = CellStyle(
    bold: true,
    fontColorHex: ExcelColor.blue800,
    fontSize: 12,
  );

  static final NumFormat currencyFormat = NumFormat.custom(
    formatCode: r'"Rs "#,##0.00',
  );

  static final NumFormat dateFormat = NumFormat.custom(
    formatCode: 'dd-mmm-yyyy',
  );

  static List<CellValue> textRow(List<String> values) {
    return values.map((String value) => TextCellValue(value)).toList();
  }

  static DateCellValue dateCell(DateTime date) {
    return DateCellValue(
      year: date.year,
      month: date.month,
      day: date.day,
    );
  }

  static DoubleCellValue currencyCell(double amount) {
    return DoubleCellValue(amount);
  }

  static void removeDefaultSheets(Excel workbook, Set<String> keepSheetNames) {
    for (final String sheetName in workbook.sheets.keys.toList()) {
      if (!keepSheetNames.contains(sheetName)) {
        workbook.delete(sheetName);
      }
    }
  }

  static void appendTitleBlock(
    Sheet sheet, {
    required String title,
    required DateTime generatedAt,
    String? subtitle,
  }) {
    _appendStyledRow(
      sheet,
      <String>['Factory ERP Lite'],
      style: _sectionTitleStyle,
    );
    _appendStyledRow(
      sheet,
      <String>[title],
      style: CellStyle(
        bold: true,
        fontSize: 14,
        fontColorHex: ExcelColor.black,
      ),
    );
    if (subtitle != null) {
      sheet.appendRow(textRow(<String>[subtitle]));
    }
    sheet.appendRow(
      textRow(<String>[
        'Generated: ${DateFormat('dd MMM yyyy, HH:mm').format(generatedAt)}',
      ]),
    );
    sheet.appendRow(textRow(<String>[]));
  }

  static void appendSummaryMetrics(
    Sheet sheet,
    List<SummaryMetricRow> metrics, {
    String sectionTitle = 'Summary',
  }) {
    _appendStyledRow(
      sheet,
      <String>[sectionTitle],
      style: _sectionTitleStyle,
    );
    sheet.appendRow(
      headerRow(<String>['Metric', 'Value']),
    );
    styleHeaderRow(sheet, 2);
    for (final SummaryMetricRow metric in metrics) {
      sheet.appendRow(
        textRow(<String>[metric.label, metric.value]),
      );
    }
    sheet.appendRow(textRow(<String>[]));
  }

  static void appendStyledTableHeader(Sheet sheet, List<String> headers) {
    sheet.appendRow(headerRow(headers));
    styleHeaderRow(sheet, headers.length);
  }

  static void styleHeaderRow(Sheet sheet, int columnCount) {
    final int rowIndex = sheet.maxRows - 1;
    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: columnIndex,
              rowIndex: rowIndex,
            ),
          )
          .cellStyle = _headerStyle;
    }
  }

  static void applyColumnNumberFormat(
    Sheet sheet, {
    required int columnIndex,
    required int firstDataRow,
    required int lastDataRow,
    required NumFormat format,
  }) {
    for (int rowIndex = firstDataRow; rowIndex <= lastDataRow; rowIndex++) {
      final Data cell = sheet.cell(
        CellIndex.indexByColumnRow(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        ),
      );
      if (cell.value == null) {
        continue;
      }
      cell.cellStyle = (cell.cellStyle ?? CellStyle()).copyWith(
        numberFormat: format,
      );
    }
  }

  static List<CellValue> headerRow(List<String> headers) {
    return headers.map((String value) => TextCellValue(value)).toList();
  }

  static String formatCurrency(double amount) {
    return 'Rs ${NumberFormat('#,##0.00').format(amount)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String categoryLabel(String categoryName) {
    return categoryName
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (Match match) => '${match.group(1)} ${match.group(2)}',
        )
        .replaceFirstMapped(
          RegExp(r'^[a-z]'),
          (Match match) => match.group(0)!.toUpperCase(),
        );
  }

  static Uint8List encodeWorkbook(Excel workbook) {
    final List<int>? encoded = workbook.encode();
    if (encoded == null || encoded.isEmpty) {
      throw StateError('Failed to encode Excel workbook.');
    }
    return Uint8List.fromList(encoded);
  }

  static void _appendStyledRow(
    Sheet sheet,
    List<String> values, {
    required CellStyle style,
  }) {
    sheet.appendRow(textRow(values));
    final int rowIndex = sheet.maxRows - 1;
    for (int columnIndex = 0; columnIndex < values.length; columnIndex++) {
      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: columnIndex,
              rowIndex: rowIndex,
            ),
          )
          .cellStyle = style;
    }
  }
}
