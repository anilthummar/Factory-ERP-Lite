/// Result of a generated and saved Excel export.
class ExcelExportResult {
  /// Creates [ExcelExportResult].
  const ExcelExportResult({
    required this.fileName,
    required this.filePath,
    required this.bytes,
  });

  /// File name including `.xlsx` extension.
  final String fileName;

  /// Absolute path where the workbook was saved locally.
  final String filePath;

  /// Raw XLSX bytes.
  final List<int> bytes;
}
