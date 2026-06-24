import 'package:factory_erp_lite/modules/backup_restore/datasource/backup_local_data_source.dart';
import 'package:factory_erp_lite/modules/backup_restore/domain/models/backup_manifest.dart';
import 'package:factory_erp_lite/modules/backup_restore/service/json_backup_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBackupLocalDataSource implements BackupLocalDataSource {
  @override
  Future<Map<String, dynamic>> exportAllModules() async {
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
  Future<void> restoreAllModules(Map<String, dynamic> modules) async {}

  @override
  Future<Map<String, int>> recordCounts() async {
    return <String, int>{'person_management': 1};
  }
}

void main() {
  test('json backup service encodes and validates backup payload', () {
    final JsonBackupService service = JsonBackupService(
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

    final String json = service.encode(payload);
    final Map<String, dynamic> decoded = service.decode(json);

    expect(decoded['formatVersion'], BackupManifest.currentVersion);
    expect(service.countRecords(decoded), 1);
  });
}
