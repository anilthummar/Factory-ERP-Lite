import 'dart:convert';

import '../domain/models/backup_manifest.dart';
import '../datasource/backup_local_data_source.dart';

/// Builds and validates JSON backup payloads.
class JsonBackupService {
  /// Creates [JsonBackupService].
  JsonBackupService({required BackupLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final BackupLocalDataSource _localDataSource;

  /// Exports all Hive modules into a versioned backup map.
  Future<Map<String, dynamic>> buildBackupPayload() async {
    final Map<String, dynamic> modules =
        await _localDataSource.exportAllModules();

    return <String, dynamic>{
      'formatVersion': BackupManifest.currentVersion,
      'app': BackupManifest.appId,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'modules': modules,
    };
  }

  /// Encodes [payload] as formatted JSON.
  String encode(Map<String, dynamic> payload) {
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Decodes and validates a JSON backup string.
  Map<String, dynamic> decode(String jsonContent) {
    final dynamic decoded = jsonDecode(jsonContent);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup root must be a JSON object.');
    }

    final int? version = decoded['formatVersion'] as int?;
    if (version != BackupManifest.currentVersion) {
      throw FormatException(
        'Unsupported backup version: $version. '
        'Expected ${BackupManifest.currentVersion}.',
      );
    }

    final String? app = decoded['app'] as String?;
    if (app != BackupManifest.appId) {
      throw const FormatException('Backup file is not from Factory ERP Lite.');
    }

    final dynamic modules = decoded['modules'];
    if (modules is! Map<String, dynamic>) {
      throw const FormatException('Backup modules section is invalid.');
    }

    return decoded;
  }

  /// Counts records across all module lists in [payload].
  int countRecords(Map<String, dynamic> payload) {
    final Map<String, dynamic> modules =
        Map<String, dynamic>.from(payload['modules'] as Map<dynamic, dynamic>);

    int total = 0;
    for (final dynamic moduleData in modules.values) {
      if (moduleData is List<dynamic>) {
        total += moduleData.length;
      }
    }
    return total;
  }
}
