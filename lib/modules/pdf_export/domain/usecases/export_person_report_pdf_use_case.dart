import 'dart:typed_data';

import '../../repository/report_data_repository.dart';
import '../../service/pdf_export_service.dart';
import '../../templates/person_report_pdf_template.dart';
import '../models/pdf_export_result.dart';
import '../models/report_data_snapshot.dart';

/// Generates and exports the person report PDF.
class ExportPersonReportPdfUseCase {
  /// Creates [ExportPersonReportPdfUseCase].
  const ExportPersonReportPdfUseCase(
    this._reportDataRepository,
    this._pdfExportService,
    this._template,
  );

  final ReportDataRepository _reportDataRepository;
  final PdfExportService _pdfExportService;
  final PersonReportPdfTemplate _template;

  /// Builds PDF from live data, saves locally, and opens share sheet.
  Future<PdfExportResult> call({bool share = true}) async {
    final ReportDataSnapshot snapshot = await _reportDataRepository.loadSnapshot();
    final Uint8List bytes = await _template.build(snapshot);

    if (share) {
      return _pdfExportService.exportAndShare(
        bytes: bytes,
        baseFileName: 'person_report',
      );
    }

    return _pdfExportService.savePdf(
      bytes: bytes,
      baseFileName: 'person_report',
    );
  }
}
