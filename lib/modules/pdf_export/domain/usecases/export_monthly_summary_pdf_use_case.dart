import 'dart:typed_data';

import '../../repository/report_data_repository.dart';
import '../../service/pdf_export_service.dart';
import '../../templates/monthly_summary_pdf_template.dart';
import '../models/pdf_export_result.dart';
import '../models/report_data_snapshot.dart';

/// Generates and exports the monthly summary PDF.
class ExportMonthlySummaryPdfUseCase {
  /// Creates [ExportMonthlySummaryPdfUseCase].
  const ExportMonthlySummaryPdfUseCase(
    this._reportDataRepository,
    this._pdfExportService,
    this._template,
  );

  final ReportDataRepository _reportDataRepository;
  final PdfExportService _pdfExportService;
  final MonthlySummaryPdfTemplate _template;

  /// Builds PDF from live data, saves locally, and opens share sheet.
  Future<PdfExportResult> call({
    bool share = true,
    DateTime? month,
  }) async {
    final ReportDataSnapshot snapshot = await _reportDataRepository.loadSnapshot();
    final Uint8List bytes = await _template.build(
      snapshot,
      month: month,
    );

    if (share) {
      return _pdfExportService.exportAndShare(
        bytes: bytes,
        baseFileName: 'monthly_summary',
      );
    }

    return _pdfExportService.savePdf(
      bytes: bytes,
      baseFileName: 'monthly_summary',
    );
  }
}
