import 'dart:typed_data';

import '../../../pdf_export/domain/models/report_data_snapshot.dart';
import '../../../pdf_export/repository/report_data_repository.dart';
import '../../service/excel_export_service.dart';
import '../../templates/monthly_summary_excel_template.dart';
import '../models/excel_export_result.dart';

/// Generates and exports the monthly summary Excel workbook.
class ExportMonthlySummaryExcelUseCase {
  /// Creates [ExportMonthlySummaryExcelUseCase].
  const ExportMonthlySummaryExcelUseCase(
    this._reportDataRepository,
    this._excelExportService,
    this._template,
  );

  final ReportDataRepository _reportDataRepository;
  final ExcelExportService _excelExportService;
  final MonthlySummaryExcelTemplate _template;

  /// Builds XLSX from live data, saves locally, and opens share sheet.
  Future<ExcelExportResult> call({
    bool share = true,
    DateTime? month,
  }) async {
    final ReportDataSnapshot snapshot =
        await _reportDataRepository.loadSnapshot();
    final Uint8List bytes = await _template.build(
      snapshot,
      month: month,
    );

    if (share) {
      return _excelExportService.exportAndShare(
        bytes: bytes,
        baseFileName: 'monthly_summary',
      );
    }

    return _excelExportService.saveExcel(
      bytes: bytes,
      baseFileName: 'monthly_summary',
    );
  }
}
