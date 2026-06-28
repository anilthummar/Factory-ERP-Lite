import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/domain/entities/labor_entity.dart';
import '../domain/models/report_data_snapshot.dart';
import 'pdf_report_theme.dart';

/// Builds the labor report PDF document.
class LaborReportPdfTemplate {
  /// Creates [LaborReportPdfTemplate].
  const LaborReportPdfTemplate();

  /// Renders labor report bytes from [snapshot].
  Future<Uint8List> build(ReportDataSnapshot snapshot) async {
    final double totalDailyWage = snapshot.labor.fold<double>(
      0,
      (double sum, LaborEntity labor) => sum + labor.dailyWage,
    );
    final double averageWage = snapshot.labor.isEmpty
        ? 0
        : totalDailyWage / snapshot.labor.length;

    final pw.Document document = pw.Document(
      title: 'Labor Report',
      creator: 'Factory ERP Lite',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          PdfReportTheme.buildHeader(
            title: 'Labor Report',
            generatedAt: snapshot.generatedAt,
            subtitle: 'Workforce overview',
          ),
          pw.SizedBox(height: 16),
          PdfReportTheme.buildSummaryGrid(
            <PdfSummaryMetric>[
              PdfSummaryMetric(
                label: 'Total Workers',
                value: '${snapshot.labor.length}',
              ),
              PdfSummaryMetric(
                label: 'Total Daily Wage',
                value: formatCurrency(totalDailyWage),
              ),
              PdfSummaryMetric(
                label: 'Average Daily Wage',
                value: formatCurrency(averageWage),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Labor Details', style: PdfReportTheme.sectionTitleStyle),
          pw.SizedBox(height: 8),
          PdfReportTheme.buildDataTable(
            headers: <String>[
              'Name',
              'Skill',
              'Mobile',
              'Daily Wage',
              'Notes',
            ],
            rows: snapshot.labor
                .map(
                  (LaborEntity labor) => <String>[
                    labor.name,
                    labor.skill,
                    labor.mobile,
                    formatCurrency(labor.dailyWage),
                    labor.notes ?? '—',
                  ],
                )
                .toList(),
            emptyMessage: 'No labor records found.',
          ),
        ],
        footer: PdfReportTheme.buildFooter,
      ),
    );

    return document.save();
  }
}
