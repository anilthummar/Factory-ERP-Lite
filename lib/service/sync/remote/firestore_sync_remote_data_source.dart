import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/domain/sync_metadata_keys.dart';
import '../../../core/sync/sync_operation.dart';
import '../../../core/sync/sync_queue_item.dart';
import '../../../core/sync/sync_result.dart';
import '../../firebase/firebase_service.dart';
import '../sync_module_registry.dart';
import 'sync_remote_batch_data_source.dart';
import 'sync_remote_push_request.dart';

/// Firestore-backed remote sync datasource.
class FirestoreSyncRemoteDataSource
    implements SyncRemoteBatchDataSource {
  /// Creates [FirestoreSyncRemoteDataSource].
  FirestoreSyncRemoteDataSource({
    required FirebaseService firebaseService,
    FirebaseFirestore? firestore,
  })  : _firebaseService = firebaseService,
        _firestore = firestore;

  final FirebaseService _firebaseService;
  final FirebaseFirestore? _firestore;

  static const int _maxBatchSize = 400;

  FirebaseFirestore get _db => _firestore ?? _firebaseService.firestore;

  @override
  Future<SyncResult> push(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    if (!_firebaseService.isInitialized) {
      return SyncFailure(
        queueItem: item,
        message: 'Firebase is not initialized.',
        isRetryable: true,
      );
    }

    try {
      final SyncModuleDescriptor descriptor =
          syncModuleDescriptor(item.module);
      final DocumentReference<Map<String, dynamic>> docRef = _db
          .collection(descriptor.firestoreCollection)
          .doc(item.recordId);

      return switch (item.operation) {
        SyncOperation.create => _create(docRef, item, payload),
        SyncOperation.update => _update(docRef, item, payload),
        SyncOperation.delete => _delete(docRef, item, payload),
      };
    } on FirebaseException catch (error) {
      return SyncFailure(
        queueItem: item,
        message: error.message ?? error.code,
        isRetryable: _isRetryable(error),
      );
    } on Object catch (error) {
      return SyncFailure(
        queueItem: item,
        message: error.toString(),
        isRetryable: true,
      );
    }
  }

  @override
  Future<List<SyncResult>> pushBatch(
    List<SyncRemotePushRequest> requests,
  ) async {
    if (requests.isEmpty) {
      return <SyncResult>[];
    }

    if (!_firebaseService.isInitialized) {
      return requests
          .map(
            (SyncRemotePushRequest request) => SyncFailure(
              queueItem: request.item,
              message: 'Firebase is not initialized.',
              isRetryable: true,
            ),
          )
          .toList(growable: false);
    }

    final List<SyncResult> results = <SyncResult>[];
    for (int index = 0; index < requests.length; index += _maxBatchSize) {
      final int end = (index + _maxBatchSize < requests.length)
          ? index + _maxBatchSize
          : requests.length;
      final List<SyncRemotePushRequest> chunk =
          requests.sublist(index, end);
      results.addAll(await _pushBatchChunk(chunk));
    }
    return results;
  }

  Future<List<SyncResult>> _pushBatchChunk(
    List<SyncRemotePushRequest> requests,
  ) async {
    final WriteBatch batch = _db.batch();
    final List<SyncResult> prepared = <SyncResult>[];

    for (final SyncRemotePushRequest request in requests) {
      final SyncResult result = await _prepareBatchOperation(
        batch: batch,
        item: request.item,
        payload: request.payload,
      );
      prepared.add(result);
      if (result is SyncFailure || result is SyncConflict) {
        return prepared;
      }
    }

    try {
      await batch.commit();
      return prepared
          .map(
            (SyncResult result) => SyncSuccess(queueItem: result.queueItem),
          )
          .toList(growable: false);
    } on FirebaseException catch (error) {
      final bool retryable = _isRetryable(error);
      return requests
          .map(
            (SyncRemotePushRequest request) => SyncFailure(
              queueItem: request.item,
              message: error.message ?? error.code,
              isRetryable: retryable,
            ),
          )
          .toList(growable: false);
    }
  }

  Future<SyncResult> _prepareBatchOperation({
    required WriteBatch batch,
    required SyncQueueItem item,
    required Map<String, dynamic> payload,
  }) async {
    final SyncModuleDescriptor descriptor = syncModuleDescriptor(item.module);
    final DocumentReference<Map<String, dynamic>> docRef = _db
        .collection(descriptor.firestoreCollection)
        .doc(item.recordId);
    final Map<String, dynamic> document = _enrichPayload(item, payload);

    if (item.operation == SyncOperation.delete) {
      batch.delete(docRef);
      return SyncSuccess(queueItem: item);
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await docRef.get();
    if (snapshot.exists) {
      final Map<String, dynamic>? remoteData = snapshot.data();
      if (remoteData != null &&
          item.operation == SyncOperation.update &&
          _hasConflict(payload, remoteData)) {
        return SyncConflict(
          queueItem: item,
          localPayload: payload,
          remotePayload: remoteData,
        );
      }
      batch.set(docRef, document, SetOptions(merge: true));
      return SyncSuccess(queueItem: item);
    }

    batch.set(docRef, document);
    return SyncSuccess(queueItem: item);
  }

  Future<SyncResult> _create(
    DocumentReference<Map<String, dynamic>> docRef,
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await docRef.get();
    if (snapshot.exists) {
      return _update(docRef, item, payload);
    }

    await docRef.set(_enrichPayload(item, payload));
    return SyncSuccess(queueItem: item);
  }

  Future<SyncResult> _update(
    DocumentReference<Map<String, dynamic>> docRef,
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await docRef.get();
    if (!snapshot.exists) {
      await docRef.set(_enrichPayload(item, payload));
      return SyncSuccess(queueItem: item);
    }

    final Map<String, dynamic> remoteData =
        snapshot.data() ?? <String, dynamic>{};
    if (_hasConflict(payload, remoteData)) {
      return SyncConflict(
        queueItem: item,
        localPayload: payload,
        remotePayload: remoteData,
      );
    }

    await docRef.set(
      _enrichPayload(item, payload),
      SetOptions(merge: true),
    );
    return SyncSuccess(queueItem: item);
  }

  Future<SyncResult> _delete(
    DocumentReference<Map<String, dynamic>> docRef,
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await docRef.get();
    if (!snapshot.exists) {
      return SyncSuccess(queueItem: item);
    }

    await docRef.delete();
    return SyncSuccess(queueItem: item);
  }

  Map<String, dynamic> _enrichPayload(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) {
    final Map<String, dynamic> document =
        Map<String, dynamic>.from(payload);
    document[SyncMetadataKeys.syncStatus] = 'synced';
    if (item.factoryId != null) {
      document[SyncMetadataKeys.factoryId] = item.factoryId;
    }
    return document;
  }

  bool _hasConflict(
    Map<String, dynamic> localPayload,
    Map<String, dynamic> remotePayload,
  ) {
    final DateTime localUpdatedAt = _parseUpdatedAt(localPayload);
    final DateTime remoteUpdatedAt = _parseUpdatedAt(remotePayload);
    return remoteUpdatedAt.isAfter(localUpdatedAt);
  }

  DateTime _parseUpdatedAt(Map<String, dynamic> payload) {
    final Object? raw = payload[SyncMetadataKeys.updatedAt];
    if (raw is String) {
      return DateTime.parse(raw);
    }
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    if (raw is Timestamp) {
      return raw.toDate();
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  bool _isRetryable(FirebaseException error) {
    return switch (error.code) {
      'unavailable' ||
      'deadline-exceeded' ||
      'resource-exhausted' ||
      'aborted' ||
      'internal' ||
      'cancelled' =>
        true,
      _ => false,
    };
  }
}
