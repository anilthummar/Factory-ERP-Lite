import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:factory_erp_lite/core/domain/sync_metadata_keys.dart';
import 'package:factory_erp_lite/core/sync/sync_module_type.dart';
import 'package:factory_erp_lite/core/sync/sync_operation.dart';
import 'package:factory_erp_lite/core/sync/sync_queue_item.dart';
import 'package:factory_erp_lite/core/sync/sync_result.dart';
import 'package:factory_erp_lite/service/firebase/firestore_collections.dart';
import 'package:factory_erp_lite/service/sync/remote/firestore_sync_remote_data_source.dart';
import 'package:factory_erp_lite/service/sync/remote/sync_remote_push_request.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_firebase_service.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late FirestoreSyncRemoteDataSource remote;
  late TestFirebaseService firebaseService;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    firebaseService = TestFirebaseService();
    remote = FirestoreSyncRemoteDataSource(
      firebaseService: firebaseService,
      firestore: firestore,
    );
  });

  Map<String, dynamic> personPayload({
    required String id,
    required DateTime updatedAt,
  }) {
    return <String, dynamic>{
      SyncMetadataKeys.id: id,
      SyncMetadataKeys.createdAt: updatedAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: 'pending',
      'name': 'Test Person',
      'mobile': '9999999999',
    };
  }

  SyncQueueItem queueItem({
    required String recordId,
    SyncOperation operation = SyncOperation.create,
  }) {
    return SyncQueueItem.forMutation(
      queueId: 'person_management::$recordId',
      module: SyncModuleType.personManagement,
      recordId: recordId,
      operation: operation,
    );
  }

  test('push create writes document to Firestore collection', () async {
    final String recordId = 'person_test_1';
    final DateTime now = DateTime.utc(2026, 6, 24, 12);
    final SyncQueueItem item = queueItem(recordId: recordId);
    final Map<String, dynamic> payload = personPayload(
      id: recordId,
      updatedAt: now,
    );

    final SyncResult result = await remote.push(item, payload);

    expect(result, isA<SyncSuccess>());
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(FirestoreCollections.personManagement)
        .doc(recordId)
        .get();
    expect(snapshot.exists, isTrue);
    expect(snapshot.data()?['name'], 'Test Person');
    expect(snapshot.data()?[SyncMetadataKeys.syncStatus], 'synced');
  });

  test('push update returns conflict when remote is newer', () async {
    final String recordId = 'person_conflict';
    final DateTime localTime = DateTime.utc(2026, 6, 24, 10);
    final DateTime remoteTime = DateTime.utc(2026, 6, 24, 12);

    await firestore
        .collection(FirestoreCollections.personManagement)
        .doc(recordId)
        .set(
          personPayload(id: recordId, updatedAt: remoteTime),
        );

    final SyncQueueItem item = queueItem(
      recordId: recordId,
      operation: SyncOperation.update,
    );
    final SyncResult result = await remote.push(
      item,
      personPayload(id: recordId, updatedAt: localTime),
    );

    expect(result, isA<SyncConflict>());
    final SyncConflict conflict = result as SyncConflict;
    expect(conflict.remotePayload[SyncMetadataKeys.id], recordId);
  });

  test('push delete removes remote document', () async {
    final String recordId = 'person_delete';
    await firestore
        .collection(FirestoreCollections.personManagement)
        .doc(recordId)
        .set(personPayload(id: recordId, updatedAt: DateTime.utc(2026, 1, 1)));

    final SyncResult result = await remote.push(
      queueItem(recordId: recordId, operation: SyncOperation.delete),
      personPayload(id: recordId, updatedAt: DateTime.utc(2026, 1, 1)),
    );

    expect(result, isA<SyncSuccess>());
    final bool exists = (await firestore
            .collection(FirestoreCollections.personManagement)
            .doc(recordId)
            .get())
        .exists;
    expect(exists, isFalse);
  });

  test('push fails retryable when Firebase is not initialized', () async {
    final FirebaseServiceStub stub = FirebaseServiceStub();
    final FirestoreSyncRemoteDataSource notReady = FirestoreSyncRemoteDataSource(
      firebaseService: stub,
      firestore: firestore,
    );

    final SyncResult result = await notReady.push(
      queueItem(recordId: 'person_offline'),
      personPayload(id: 'person_offline', updatedAt: DateTime.now()),
    );

    expect(result, isA<SyncFailure>());
    expect((result as SyncFailure).isRetryable, isTrue);
  });

  test('pushBatch commits multiple documents atomically', () async {
    final DateTime now = DateTime.utc(2026, 6, 24, 15);
    final List<SyncRemotePushRequest> requests = <SyncRemotePushRequest>[
      SyncRemotePushRequest(
        item: queueItem(recordId: 'batch_1'),
        payload: personPayload(id: 'batch_1', updatedAt: now),
      ),
      SyncRemotePushRequest(
        item: queueItem(recordId: 'batch_2'),
        payload: personPayload(id: 'batch_2', updatedAt: now),
      ),
    ];

    final List<SyncResult> results = await remote.pushBatch(requests);

    expect(results, hasLength(2));
    expect(results.every((SyncResult r) => r is SyncSuccess), isTrue);
    expect(
      (await firestore
              .collection(FirestoreCollections.personManagement)
              .doc('batch_1')
              .get())
          .exists,
      isTrue,
    );
    expect(
      (await firestore
              .collection(FirestoreCollections.personManagement)
              .doc('batch_2')
              .get())
          .exists,
      isTrue,
    );
  });
}
