import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../pdf_export/templates/pdf_report_theme.dart';
import '../domain/entities/explorer_record_item.dart';

/// Builds a PDF export for filtered Records Explorer rows.
class RecordsExplorerPdfTemplate {
  /// Creates [RecordsExplorerPdfTemplate].
  const RecordsExplorerPdfTemplate();

  /// Renders PDF bytes for [records].
  Future<Uint8List> build({
    required List<ExplorerRecordItem> records,
    required DateTime generatedAt,
  }) async {
    final double totalAmount = records.fold<double>(
      0,
      (double sum, ExplorerRecordItem record) => sum + (record.amount ?? 0),
    );

    final pw.Document document = pw.Document(
      title: 'Records Explorer',
      creator: 'Factory ERP Lite',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          PdfReportTheme.buildHeader(
            title: 'Records Explorer',
            generatedAt: generatedAt,
            subtitle: 'Filtered export',
          ),
          pw.SizedBox(height: 16),
          PdfReportTheme.buildSummaryGrid(
            <PdfSummaryMetric>[
              PdfSummaryMetric(
                label: 'Total Records',
                value: '${records.length}',
              ),
              PdfSummaryMetric(
                label: 'Total Amount',
                value: formatCurrency(totalAmount),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          PdfReportTheme.buildDataTable(
            headers: <String>[
              'Date',
              'Name',
              'Module',
              'Category',
              'Amount',
              'Sync',
            ],
            rows: records
                .map(
                  (ExplorerRecordItem record) => <String>[
                    formatDate(record.recordDate),
                    record.name,
                    record.moduleType.name,
                    record.category,
                    record.amount == null
                        ? '—'
                        : formatCurrency(record.amount!),
                    record.syncStatus.name,
                  ],
                )
                .toList(),
            emptyMessage: 'No records to export.',
          ),
        ],
      ),
    );

    return document.save();
  }
}
