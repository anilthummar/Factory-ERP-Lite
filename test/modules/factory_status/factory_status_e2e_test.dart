import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:factory_erp_lite/core/domain/entities/factory_status_entity.dart';
import 'package:factory_erp_lite/core/domain/enums/factory_status_type.dart';
import 'package:factory_erp_lite/core/enums/sync_status.dart';
import 'package:factory_erp_lite/core/sync/sync_module_type.dart';
import 'package:factory_erp_lite/core/sync/sync_operation.dart';
import 'package:factory_erp_lite/modules/factory_status/datasource/factory_status_local_data_source_impl.dart';
import 'package:factory_erp_lite/modules/factory_status/domain/usecases/change_factory_status_use_case.dart';
import 'package:factory_erp_lite/modules/factory_status/domain/usecases/get_current_factory_status_use_case.dart';
import 'package:factory_erp_lite/modules/factory_status/domain/usecases/get_factory_status_history_use_case.dart';
import 'package:factory_erp_lite/modules/factory_status/repository/factory_status_repository_impl.dart';
import 'package:factory_erp_lite/service/firebase/firestore_collections.dart';
import 'package:factory_erp_lite/service/hive/hive_manager.dart';
import 'package:factory_erp_lite/service/sync/handlers/factory_status_sync_module_handler.dart';
import 'package:factory_erp_lite/service/sync/handlers/sync_handler_registry.dart';
import 'package:factory_erp_lite/service/sync/queue/sync_queue_repository.dart';
import 'package:factory_erp_lite/service/sync/remote/firestore_sync_remote_data_source.dart';
import 'package:factory_erp_lite/service/sync/sync_coordinator.dart';
import 'package:factory_erp_lite/service/sync/sync_engine.dart';
import 'package:factory_erp_lite/utils/debug_log.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_sync_queue_data_source.dart';
import '../../support/test_firebase_service.dart';

void main() {
  late Directory hiveDir;
  late FactoryStatusRepositoryImpl repository;
  late ChangeFactoryStatusUseCase changeStatusUseCase;
  late GetCurrentFactoryStatusUseCase getCurrentUseCase;
  late GetFactoryStatusHistoryUseCase getHistoryUseCase;

  setUpAll(() async {
    hiveDir = Directory.systemTemp.createTempSync('factory_status_test');
    await HiveManager.instance.initForTests(hiveDir.path);
  });

  tearDownAll(() async {
    if (hiveDir.existsSync()) {
      hiveDir.deleteSync(recursive: true);
    }
  });

  setUp(() async {
    await HiveManager.instance.factoryStatusBox.clear();

    repository = FactoryStatusRepositoryImpl(
      localDataSource: FactoryStatusLocalDataSourceImpl(),
    );
    changeStatusUseCase = ChangeFactoryStatusUseCase(repository);
    getCurrentUseCase = GetCurrentFactoryStatusUseCase(repository);
    getHistoryUseCase = GetFactoryStatusHistoryUseCase(repository);
  });

  test('change status persists to Hive and returns current status', () async {
    expect(await getCurrentUseCase(), isNull);

    await changeStatusUseCase(
      status: FactoryStatusType.maintenance,
      notes: 'Scheduled downtime',
    );

    final FactoryStatusEntity? current = await getCurrentUseCase();
    expect(current, isNotNull);
    expect(current!.status, FactoryStatusType.maintenance);
    expect(current.notes, 'Scheduled downtime');
    expect(current.syncStatus, SyncStatus.pending);

    final List<FactoryStatusEntity> history = await getHistoryUseCase();
    expect(history, hasLength(1));
    expect(history.first.id, current.id);
  });

  test('status history keeps newest entry first', () async {
    await changeStatusUseCase(status: FactoryStatusType.operational);
    await Future<void>.delayed(const Duration(milliseconds: 2));
    await changeStatusUseCase(status: FactoryStatusType.shutdown);

    final List<FactoryStatusEntity> history = await getHistoryUseCase();
    expect(history, hasLength(2));
    expect(history.first.status, FactoryStatusType.shutdown);
    expect(history.last.status, FactoryStatusType.operational);
    expect((await getCurrentUseCase())!.status, FactoryStatusType.shutdown);
  });

  test('end-to-end: change status → sync queue → Firestore → synced', () async {
    final FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
    final FactoryStatusSyncModuleHandler handler =
        FactoryStatusSyncModuleHandler();

    final InMemorySyncQueueLocalDataSource queueLocal =
        InMemorySyncQueueLocalDataSource();
    final SyncQueueRepository queueRepository = SyncQueueRepositoryImpl(
      localDataSource: queueLocal,
    );

    final SyncHandlerRegistry registry = SyncHandlerRegistry()
      ..register(handler);

    final SyncEngine syncEngine = SyncEngine(
      queueRepository: queueRepository,
      remoteDataSource: FirestoreSyncRemoteDataSource(
        firebaseService: TestFirebaseService(),
        firestore: firestore,
      ),
      handlerRegistry: registry,
      hiveManager: HiveManager.instance,
      debugLog: DebugLog(),
    );

    final SyncCoordinator coordinator = SyncCoordinator(
      queueRepository: queueRepository,
      syncEngine: syncEngine,
    );

    final FactoryStatusEntity saved = await changeStatusUseCase(
      status: FactoryStatusType.partial,
      notes: 'Line 2 offline',
    );

    await coordinator.onLocalMutation(
      module: SyncModuleType.factoryStatus,
      recordId: saved.id,
      operation: SyncOperation.create,
      triggerSync: false,
    );

    expect(await queueRepository.getPendingCount(), 1);

    final SyncEngineReport report = await syncEngine.processPending();
    expect(report.succeededCount, 1);

    final DocumentSnapshot<Map<String, dynamic>> doc = await firestore
        .collection(FirestoreCollections.factoryStatus)
        .doc(saved.id)
        .get();
    expect(doc.exists, isTrue);
    expect(doc.data()?['status'], FactoryStatusType.partial.name);
    expect(doc.data()?['notes'], 'Line 2 offline');

    final FactoryStatusEntity? synced = await repository.getById(saved.id);
    expect(synced?.syncStatus, SyncStatus.synced);
  });
}
