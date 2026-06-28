import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/models/excel_export_result.dart';

/// Saves Excel workbooks locally and shares them via the system sheet.
class ExcelExportService {
  /// Creates [ExcelExportService].
  ExcelExportService({Directory? exportsDirectory})
      : _exportsDirectory = exportsDirectory;

  final Directory? _exportsDirectory;

  /// Writes [bytes] to app documents and returns file metadata.
  Future<ExcelExportResult> saveExcel({
    required Uint8List bytes,
    required String baseFileName,
  }) async {
    final Directory exportsDir = _exportsDirectory ?? await _resolveExportsDir();
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    final String timestamp =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final String fileName = '${_sanitize(baseFileName)}_$timestamp.xlsx';
    final File file = File('${exportsDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    return ExcelExportResult(
      fileName: fileName,
      filePath: file.path,
      bytes: bytes,
    );
  }

  /// Opens the platform share sheet for a saved workbook.
  Future<void> shareExcel({
    required String filePath,
    required String fileName,
  }) {
    return Share.shareXFiles(
      <XFile>[XFile(filePath, name: fileName)],
      subject: fileName,
    );
  }

  /// Generates, saves locally, and shares an Excel file in one call.
  Future<ExcelExportResult> exportAndShare({
    required Uint8List bytes,
    required String baseFileName,
  }) async {
    final ExcelExportResult result = await saveExcel(
      bytes: bytes,
      baseFileName: baseFileName,
    );
    await shareExcel(filePath: result.filePath, fileName: result.fileName);
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
