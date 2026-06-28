import 'dart:typed_data';

import '../../../pdf_export/domain/models/report_data_snapshot.dart';
import '../../../pdf_export/repository/report_data_repository.dart';
import '../../service/excel_export_service.dart';
import '../../templates/labor_report_excel_template.dart';
import '../models/excel_export_result.dart';

/// Generates and exports the labor report Excel workbook.
class ExportLaborReportExcelUseCase {
  /// Creates [ExportLaborReportExcelUseCase].
  const ExportLaborReportExcelUseCase(
    this._reportDataRepository,
    this._excelExportService,
    this._template,
  );

  final ReportDataRepository _reportDataRepository;
  final ExcelExportService _excelExportService;
  final LaborReportExcelTemplate _template;

  /// Builds XLSX from live data, saves locally, and opens share sheet.
  Future<ExcelExportResult> call({bool share = true}) async {
    final ReportDataSnapshot snapshot =
        await _reportDataRepository.loadSnapshot();
    final Uint8List bytes = await _template.build(snapshot);

    if (share) {
      return _excelExportService.exportAndShare(
        bytes: bytes,
        baseFileName: 'labor_report',
      );
    }

    return _excelExportService.saveExcel(
      bytes: bytes,
      baseFileName: 'labor_report',
    );
  }
}
