import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:factory_erp_lite/core/domain/sync_metadata_keys.dart';
import 'package:factory_erp_lite/core/enums/sync_status.dart';
import 'package:factory_erp_lite/core/sync/sync_module_type.dart';
import 'package:factory_erp_lite/core/sync/sync_operation.dart';
import 'package:factory_erp_lite/service/firebase/firestore_collections.dart';
import 'package:factory_erp_lite/service/hive/hive_manager.dart';
import 'package:factory_erp_lite/service/sync/handlers/sync_handler_registry.dart';
import 'package:factory_erp_lite/service/sync/queue/sync_queue_repository.dart';
import 'package:factory_erp_lite/service/sync/remote/firestore_sync_remote_data_source.dart';
import 'package:factory_erp_lite/service/sync/sync_coordinator.dart';
import 'package:factory_erp_lite/service/sync/sync_engine.dart';
import 'package:factory_erp_lite/utils/debug_log.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_sync_queue_data_source.dart';
import '../../support/stub_sync_module_handler.dart';
import '../../support/test_firebase_service.dart';

void main() {
  late Directory hiveDir;
  late FakeFirebaseFirestore firestore;
  late StubSyncModuleHandler personHandler;
  late SyncQueueRepository queueRepository;
  late SyncEngine syncEngine;
  late SyncCoordinator coordinator;

  setUpAll(() async {
    hiveDir = Directory.systemTemp.createTempSync('factory_erp_sync_e2e');
    await HiveManager.instance.initForTests(hiveDir.path);
  });

  tearDownAll(() async {
    if (hiveDir.existsSync()) {
      hiveDir.deleteSync(recursive: true);
    }
  });

  setUp(() {
    firestore = FakeFirebaseFirestore();
    personHandler = StubSyncModuleHandler(
      moduleType: SyncModuleType.personManagement,
    );

    final InMemorySyncQueueLocalDataSource queueLocal =
        InMemorySyncQueueLocalDataSource();
    queueRepository = SyncQueueRepositoryImpl(
      localDataSource: queueLocal,
    );

    final SyncHandlerRegistry registry = SyncHandlerRegistry()
      ..register(personHandler);

    syncEngine = SyncEngine(
      queueRepository: queueRepository,
      remoteDataSource: FirestoreSyncRemoteDataSource(
        firebaseService: TestFirebaseService(),
        firestore: firestore,
      ),
      handlerRegistry: registry,
      hiveManager: HiveManager.instance,
      debugLog: DebugLog(),
    );

    coordinator = SyncCoordinator(
      queueRepository: queueRepository,
      syncEngine: syncEngine,
    );
  });

  test('end-to-end: hive enqueue → Firestore push → synced status', () async {
    const String recordId = 'person_e2e_1';
    final DateTime now = DateTime.utc(2026, 6, 24, 18, 2, 17);
    personHandler.seedRecord(
      id: recordId,
      payload: <String, dynamic>{
        SyncMetadataKeys.id: recordId,
        SyncMetadataKeys.createdAt: now.toIso8601String(),
        SyncMetadataKeys.updatedAt: now.toIso8601String(),
        SyncMetadataKeys.syncStatus: 'pending',
        'name': 'fwdv',
        'mobile': 'bdvd',
      },
    );

    await coordinator.onLocalMutation(
      module: SyncModuleType.personManagement,
      recordId: recordId,
      operation: SyncOperation.create,
      triggerSync: false,
    );

    final SyncEngineReport report = await syncEngine.processPending();

    expect(report.succeededCount, 1);
    expect(await queueRepository.getPendingCount(), 0);
    expect(personHandler.statusFor(recordId), SyncStatus.synced);

    final DocumentSnapshot<Map<String, dynamic>> remoteDoc = await firestore
        .collection(FirestoreCollections.personManagement)
        .doc(recordId)
        .get();
    expect(remoteDoc.exists, isTrue);
    expect(remoteDoc.data()?['name'], 'fwdv');
    expect(remoteDoc.data()?['mobile'], 'bdvd');
    expect(remoteDoc.data()?[SyncMetadataKeys.syncStatus], 'synced');
  });

  test('end-to-end: failed remote marks record failed and keeps queue item',
      () async {
    final FirebaseServiceStub firebaseStub = FirebaseServiceStub();
    final InMemorySyncQueueLocalDataSource queueLocal =
        InMemorySyncQueueLocalDataSource();
    final SyncQueueRepository failingQueue = SyncQueueRepositoryImpl(
      localDataSource: queueLocal,
    );
    final SyncEngine failingEngine = SyncEngine(
      queueRepository: failingQueue,
      remoteDataSource: FirestoreSyncRemoteDataSource(
        firebaseService: firebaseStub,
        firestore: firestore,
      ),
      handlerRegistry: SyncHandlerRegistry()..register(personHandler),
      hiveManager: HiveManager.instance,
      debugLog: DebugLog(),
    );

    const String recordId = 'person_e2e_fail';
    personHandler.seedRecord(
      id: recordId,
      payload: <String, dynamic>{
        SyncMetadataKeys.id: recordId,
        SyncMetadataKeys.createdAt: DateTime.now().toIso8601String(),
        SyncMetadataKeys.updatedAt: DateTime.now().toIso8601String(),
        SyncMetadataKeys.syncStatus: 'pending',
        'name': 'Fail Test',
        'mobile': '0000000000',
      },
    );

    await failingQueue.enqueueMutation(
      module: SyncModuleType.personManagement,
      recordId: recordId,
      operation: SyncOperation.create,
    );

    final SyncEngineReport report = await failingEngine.processPending();

    expect(report.failedCount, 1);
    expect(personHandler.statusFor(recordId), SyncStatus.failed);
    expect(await failingQueue.getPendingCount(), 1);
  });
}
