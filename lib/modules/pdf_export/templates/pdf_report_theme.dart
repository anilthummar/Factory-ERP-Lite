import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Shared styling and layout helpers for ERP PDF reports.
abstract final class PdfReportTheme {
  static const PdfColor primary = PdfColor.fromInt(0xFF1565C0);
  static const PdfColor primaryLight = PdfColor.fromInt(0xFFE3F2FD);
  static const PdfColor border = PdfColor.fromInt(0xFFBDBDBD);
  static const PdfColor headerText = PdfColor.fromInt(0xFF212121);
  static const PdfColor mutedText = PdfColor.fromInt(0xFF616161);

  static pw.TextStyle get titleStyle => pw.TextStyle(
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
        color: headerText,
      );

  static pw.TextStyle get subtitleStyle => pw.TextStyle(
        fontSize: 11,
        color: mutedText,
      );

  static pw.TextStyle get sectionTitleStyle => pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        color: headerText,
      );

  static pw.TextStyle get tableHeaderStyle => pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      );

  static pw.TextStyle get tableCellStyle => const pw.TextStyle(fontSize: 9);

  static pw.Widget buildHeader({
    required String title,
    required DateTime generatedAt,
    String? subtitle,
  }) {
    final String generatedLabel =
        DateFormat('dd MMM yyyy, HH:mm').format(generatedAt);

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: primaryLight,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: primary, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text('Factory ERP Lite', style: subtitleStyle),
          pw.SizedBox(height: 4),
          pw.Text(title, style: titleStyle),
          if (subtitle != null) ...<pw.Widget>[
            pw.SizedBox(height: 4),
            pw.Text(subtitle, style: subtitleStyle),
          ],
          pw.SizedBox(height: 8),
          pw.Text('Generated: $generatedLabel', style: subtitleStyle),
        ],
      ),
    );
  }

  static pw.Widget buildSummaryGrid(List<PdfSummaryMetric> metrics) {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: metrics
          .map(
            (PdfSummaryMetric metric) => pw.Container(
              width: 150,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: border),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(metric.label, style: subtitleStyle),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    metric.value,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: headerText,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  static pw.Widget buildDataTable({
    required List<String> headers,
    required List<List<String>> rows,
    String emptyMessage = 'No records found.',
  }) {
    if (rows.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 12),
        child: pw.Text(emptyMessage, style: subtitleStyle),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: border, width: 0.5),
      columnWidths: <int, pw.TableColumnWidth>{
        for (int i = 0; i < headers.length; i++)
          i: const pw.FlexColumnWidth(),
      },
      children: <pw.TableRow>[
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: primary),
          children: headers
              .map(
                (String header) => pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(header, style: tableHeaderStyle),
                ),
              )
              .toList(),
        ),
        ...rows.map(
          (List<String> row) => pw.TableRow(
            children: row
                .map(
                  (String cell) => pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(cell, style: tableCellStyle),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  static pw.Widget buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: subtitleStyle,
      ),
    );
  }
}

/// Summary metric shown in report header cards.
class PdfSummaryMetric {
  /// Creates [PdfSummaryMetric].
  const PdfSummaryMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

String formatCurrency(double amount) {
  return 'Rs ${NumberFormat('#,##0.00').format(amount)}';
}

String formatDate(DateTime date) {
  return DateFormat('dd-MMM-yyyy').format(date);
}

String categoryLabel(String categoryName) {
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
