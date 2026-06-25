import 'package:factory_erp_lite/modules/backup_restore/datasource/backup_local_data_source.dart';
import 'package:factory_erp_lite/modules/backup_restore/domain/models/backup_manifest.dart';
import 'package:factory_erp_lite/modules/backup_restore/domain/models/backup_validation_result.dart';
import 'package:factory_erp_lite/modules/backup_restore/service/restore_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBackupLocalDataSource implements BackupLocalDataSource {
  @override
  Future<Map<String, dynamic>> exportModules() async {
    return <String, dynamic>{
      'person_management': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'p1',
          'createdAtMs': 1,
          'updatedAtMs': 1,
          'syncStatusValue': 'synced',
          'name': 'Test',
          'mobile': '999',
        },
      ],
    };
  }

  @override
  Future<void> restoreModules(
    Map<String, dynamic> modules, {
    BackupProgressCallback? onProgress,
  }) async {}

  @override
  Future<Map<String, int>> recordCounts() async {
    return <String, int>{'person_management': 1};
  }
}

void main() {
  test('restore service validates supported backup payload', () {
    final RestoreService service = RestoreService(
      localDataSource: _FakeBackupLocalDataSource(),
    );

    final Map<String, dynamic> payload = <String, dynamic>{
      'formatVersion': BackupManifest.currentVersion,
      'app': BackupManifest.appId,
      'exportedAt': '2026-06-23T12:00:00.000Z',
      'modules': <String, dynamic>{
        'person_management': <Map<String, dynamic>>[
          <String, dynamic>{'id': 'p1'},
        ],
      },
    };

    final BackupValidationResult result = service.validatePayload(payload);

    expect(result.isValid, isTrue);
    expect(result.totalRecords, 1);
  });

  test('restore service rejects unsupported app id', () {
    final RestoreService service = RestoreService(
      localDataSource: _FakeBackupLocalDataSource(),
    );

    final BackupValidationResult result = service.validatePayload(<String, dynamic>{
      'formatVersion': BackupManifest.currentVersion,
      'app': 'other_app',
      'modules': <String, dynamic>{},
    });

    expect(result.isValid, isFalse);
    expect(result.errors, isNotEmpty);
  });
}
