import '../../../../utils/exports.dart';
import '../../templates/records_explorer_excel_template.dart';
import '../../templates/records_explorer_pdf_template.dart';
import '../entities/explorer_record_item.dart';

/// Exports filtered Records Explorer rows to PDF or Excel.
class ExportFilteredRecordsUseCase {
  /// Creates [ExportFilteredRecordsUseCase].
  ExportFilteredRecordsUseCase({
    required PdfExportService pdfExportService,
    required ExcelExportService excelExportService,
    required RecordsExplorerPdfTemplate pdfTemplate,
    required RecordsExplorerExcelTemplate excelTemplate,
  })  : _pdfExportService = pdfExportService,
        _excelExportService = excelExportService,
        _pdfTemplate = pdfTemplate,
        _excelTemplate = excelTemplate;

  final PdfExportService _pdfExportService;
  final ExcelExportService _excelExportService;
  final RecordsExplorerPdfTemplate _pdfTemplate;
  final RecordsExplorerExcelTemplate _excelTemplate;

  /// Exports [records] to a shareable PDF.
  Future<void> exportPdf({
    required List<ExplorerRecordItem> records,
    required DateTime generatedAt,
  }) async {
    final Uint8List bytes = await _pdfTemplate.build(
      records: records,
      generatedAt: generatedAt,
    );
    await _pdfExportService.exportAndShare(
      bytes: bytes,
      baseFileName: 'records_explorer',
    );
  }

  /// Exports [records] to a shareable Excel workbook.
  Future<void> exportExcel({
    required List<ExplorerRecordItem> records,
    required DateTime generatedAt,
  }) async {
    final Uint8List bytes = await _excelTemplate.build(
      records: records,
      generatedAt: generatedAt,
    );
    await _excelExportService.exportAndShare(
      bytes: bytes,
      baseFileName: 'records_explorer',
    );
  }
}
