/// Result of a generated and saved PDF export.
class PdfExportResult {
  /// Creates [PdfExportResult].
  const PdfExportResult({
    required this.fileName,
    required this.filePath,
    required this.bytes,
  });

  /// File name including `.pdf` extension.
  final String fileName;

  /// Absolute path where the PDF was saved locally.
  final String filePath;

  /// Raw PDF bytes.
  final List<int> bytes;
}
