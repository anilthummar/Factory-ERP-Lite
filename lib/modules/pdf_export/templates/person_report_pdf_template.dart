import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/domain/entities/person_entity.dart';
import '../domain/models/report_data_snapshot.dart';
import 'pdf_report_theme.dart';

/// Builds the person report PDF document.
class PersonReportPdfTemplate {
  /// Creates [PersonReportPdfTemplate].
  const PersonReportPdfTemplate();

  /// Renders person report bytes from [snapshot].
  Future<Uint8List> build(ReportDataSnapshot snapshot) async {
    final int withAddress = snapshot.persons
        .where((PersonEntity person) => (person.address ?? '').isNotEmpty)
        .length;

    final pw.Document document = pw.Document(
      title: 'Person Report',
      creator: 'Factory ERP Lite',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          PdfReportTheme.buildHeader(
            title: 'Person Report',
            generatedAt: snapshot.generatedAt,
            subtitle: 'Contacts and persons directory',
          ),
          pw.SizedBox(height: 16),
          PdfReportTheme.buildSummaryGrid(
            <PdfSummaryMetric>[
              PdfSummaryMetric(
                label: 'Total Persons',
                value: '${snapshot.persons.length}',
              ),
              PdfSummaryMetric(
                label: 'With Address',
                value: '$withAddress',
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Person Details', style: PdfReportTheme.sectionTitleStyle),
          pw.SizedBox(height: 8),
          PdfReportTheme.buildDataTable(
            headers: <String>['Name', 'Mobile', 'Address', 'Notes'],
            rows: snapshot.persons
                .map(
                  (PersonEntity person) => <String>[
                    person.name,
                    person.mobile,
                    person.address ?? '—',
                    person.notes ?? '—',
                  ],
                )
                .toList(),
            emptyMessage: 'No person records found.',
          ),
        ],
        footer: PdfReportTheme.buildFooter,
      ),
    );

    return document.save();
  }
}
