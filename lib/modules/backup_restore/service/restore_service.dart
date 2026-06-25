import 'dart:convert';
import 'dart:io';

import '../../../service/hive/hive_box_names.dart';
import 'package:flutter/foundation.dart';

import '../datasource/backup_local_data_source.dart';
import '../domain/models/backup_manifest.dart';
import '../domain/models/backup_progress.dart';
import '../domain/models/backup_validation_result.dart';

/// Validates and restores JSON backup files into Hive.
class RestoreService {
  /// Creates [RestoreService].
  RestoreService({required BackupLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final BackupLocalDataSource _localDataSource;

  /// Reads and validates a backup file without importing data.
  Future<BackupValidationResult> validateFile(String filePath) async {
    try {
      final String jsonContent = await File(filePath).readAsString();
      final Map<String, dynamic> payload = _decodePayload(jsonContent);
      return _validatePayload(payload);
    } on FormatException catch (error) {
      return BackupValidationResult(
        isValid: false,
        errors: <String>[error.message],
        recordCountsByModule: const <String, int>{},
        totalRecords: 0,
      );
    } on Object catch (error) {
      return BackupValidationResult(
        isValid: false,
        errors: <String>[error.toString()],
        recordCountsByModule: const <String, int>{},
        totalRecords: 0,
      );
    }
  }

  /// Validates and restores Hive data from [filePath].
  Future<int> restoreFromFile(
    String filePath, {
    BackupProgressCallback? onProgress,
  }) async {
    final String jsonContent = await File(filePath).readAsString();
    final Map<String, dynamic> payload = _decodePayload(jsonContent);
    final BackupValidationResult validation = _validatePayload(payload);

    if (!validation.isValid) {
      throw FormatException(validation.errors.join('\n'));
    }

    onProgress?.call(
      const BackupProgress(
        stage: 'Validation complete',
        completedSteps: 0,
        totalSteps: 1,
      ),
    );

    final Map<String, dynamic> modules = Map<String, dynamic>.from(
      payload['modules'] as Map<dynamic, dynamic>,
    );

    await _localDataSource.restoreModules(
      modules,
      onProgress: onProgress,
    );

    return validation.totalRecords;
  }

  /// Exposes payload validation for unit tests.
  @visibleForTesting
  BackupValidationResult validatePayload(Map<String, dynamic> payload) {
    return _validatePayload(payload);
  }

  Map<String, dynamic> _decodePayload(String jsonContent) {
    final dynamic decoded = jsonDecode(jsonContent);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup root must be a JSON object.');
    }
    return decoded;
  }

  BackupValidationResult _validatePayload(Map<String, dynamic> payload) {
    final List<String> errors = <String>[];

    final int? version = payload['formatVersion'] as int?;
    if (version == null) {
      errors.add('Missing formatVersion field.');
    } else if (version > BackupManifest.currentVersion) {
      errors.add(
        'Backup version $version is newer than supported version '
        '${BackupManifest.currentVersion}.',
      );
    } else if (version < 1) {
      errors.add('Unsupported backup version: $version.');
    }

    final String? app = payload['app'] as String?;
    if (app != BackupManifest.appId) {
      errors.add('Backup file is not from Factory ERP Lite.');
    }

    final dynamic modulesRaw = payload['modules'];
    if (modulesRaw is! Map<String, dynamic>) {
      errors.add('Backup modules section is invalid.');
      return BackupValidationResult(
        isValid: false,
        errors: errors,
        recordCountsByModule: const <String, int>{},
        totalRecords: 0,
        formatVersion: version,
        exportedAt: payload['exportedAt'] as String?,
      );
    }

    final Map<String, int> counts = <String, int>{};
    int total = 0;

    for (final String key in modulesRaw.keys) {
      if (!BackupManifest.supportedModuleKeys.contains(key)) {
        errors.add('Unknown module in backup: $key');
        continue;
      }

      final dynamic moduleData = modulesRaw[key];
      if (moduleData == null) {
        counts[key] = 0;
        continue;
      }

      if (moduleData is! List<dynamic>) {
        errors.add('Module $key must be a JSON array.');
        continue;
      }

      counts[key] = moduleData.length;
      total += moduleData.length;

      for (final dynamic entry in moduleData) {
        if (entry is! Map) {
          errors.add('Module $key contains invalid record format.');
          break;
        }

        if (key == HiveBoxNames.calendarManagement) {
          if (!entry.containsKey('key')) {
            errors.add('Calendar event entry is missing key.');
            break;
          }
        } else if (!entry.containsKey('id')) {
          errors.add(
            'Module ${BackupManifest.moduleLabels[key] ?? key} '
            'contains a record without id.',
          );
          break;
        }
      }
    }

    return BackupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      recordCountsByModule: counts,
      totalRecords: total,
      formatVersion: version,
      exportedAt: payload['exportedAt'] as String?,
    );
  }
}
