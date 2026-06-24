import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../domain/models/pdf_export_result.dart';

/// Saves PDF files locally and shares them via the system sheet.
class PdfExportService {
  /// Creates [PdfExportService].
  PdfExportService({Directory? exportsDirectory})
      : _exportsDirectory = exportsDirectory;

  final Directory? _exportsDirectory;

  /// Writes [bytes] to app documents and returns file metadata.
  Future<PdfExportResult> savePdf({
    required Uint8List bytes,
    required String baseFileName,
  }) async {
    final Directory exportsDir = _exportsDirectory ?? await _resolveExportsDir();
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    final String timestamp =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final String fileName = '${_sanitize(baseFileName)}_$timestamp.pdf';
    final File file = File('${exportsDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    return PdfExportResult(
      fileName: fileName,
      filePath: file.path,
      bytes: bytes,
    );
  }

  /// Opens the platform share sheet for [bytes].
  Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
  }) {
    return Printing.sharePdf(
      bytes: bytes,
      filename: fileName.endsWith('.pdf') ? fileName : '$fileName.pdf',
    );
  }

  /// Generates, saves locally, and shares a PDF in one call.
  Future<PdfExportResult> exportAndShare({
    required Uint8List bytes,
    required String baseFileName,
  }) async {
    final PdfExportResult result = await savePdf(
      bytes: bytes,
      baseFileName: baseFileName,
    );
    await sharePdf(bytes: bytes, fileName: result.fileName);
    return result;
  }

  Future<Directory> _resolveExportsDir() async {
    final Directory documentsDir = await getApplicationDocumentsDirectory();
    return Directory('${documentsDir.path}/exports');
  }

  String _sanitize(String value) {
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_').toLowerCase();
  }
}
