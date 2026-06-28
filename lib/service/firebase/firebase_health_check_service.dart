import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../sync/sync_service.dart';
import 'domain/firebase_health_check_result.dart';
import 'firebase_service.dart';
import 'firestore_collection_bootstrap_service.dart';
import 'firestore_collections.dart';

/// Verifies Firebase initialization, auth, Firestore, Storage, and connectivity.
class FirebaseHealthCheckService {
  /// Creates [FirebaseHealthCheckService].
  FirebaseHealthCheckService({
    required FirebaseService firebaseService,
    required SyncService syncService,
    required FirestoreCollectionBootstrapService bootstrapService,
  })  : _firebaseService = firebaseService,
        _syncService = syncService,
        _bootstrapService = bootstrapService;

  final FirebaseService _firebaseService;
  final SyncService _syncService;
  final FirestoreCollectionBootstrapService _bootstrapService;

  /// Runs all health probes. Optionally bootstraps module collections after a
  /// successful Firestore write probe.
  Future<FirebaseHealthCheckResult> run({
    bool bootstrapCollections = true,
  }) async {
    final DateTime checkedAt = DateTime.now();
    final ConnectivityResult connectivityStatus =
        await _syncService.getConnectivityStatus();
    final bool isOnline = _syncService.isOnline(connectivityStatus);
    final bool isFirebaseInitialized =
        _firebaseService.isInitialized || Firebase.apps.isNotEmpty;

    String? userId;
    String? userEmail;
    bool isAuthenticated = false;
    if (isFirebaseInitialized) {
      final User? user = _firebaseService.auth.currentUser;
      isAuthenticated = user != null;
      userId = user?.uid;
      userEmail = user?.email;
    }

    String? firestoreReadError;
    String? firestoreWriteError;
    String? storageError;
    bool canReadFirestore = false;
    bool canWriteFirestore = false;
    bool canAccessStorage = false;
    Map<String, bool> bootstrappedCollections = <String, bool>{};

    if (isFirebaseInitialized && isAuthenticated && isOnline) {
      canReadFirestore = await _probeFirestoreRead(
        onError: (String message) => firestoreReadError = message,
      );

      canWriteFirestore = await _probeFirestoreWrite(
        userId: userId!,
        onError: (String message) => firestoreWriteError = message,
      );

      if (bootstrapCollections && canWriteFirestore) {
        bootstrappedCollections =
            await _bootstrapService.ensureModuleCollections(userId: userId);
      }

      canAccessStorage = await _probeStorage(
        onError: (String message) => storageError = message,
      );
    }

    return FirebaseHealthCheckResult(
      isFirebaseInitialized: isFirebaseInitialized,
      isAuthenticated: isAuthenticated,
      userId: userId,
      userEmail: userEmail,
      canReadFirestore: canReadFirestore,
      canWriteFirestore: canWriteFirestore,
      canAccessStorage: canAccessStorage,
      isOnline: isOnline,
      firestoreReadError: firestoreReadError,
      firestoreWriteError: firestoreWriteError,
      storageError: storageError,
      bootstrappedCollections: bootstrappedCollections,
      checkedAt: checkedAt,
    );
  }

  Future<bool> _probeFirestoreRead({
    required void Function(String message) onError,
  }) async {
    try {
      await _firebaseService.firestore
          .collection(FirestoreCollections.personManagement)
          .limit(1)
          .get();
      return true;
    } on FirebaseException catch (error) {
      onError(error.message ?? error.code);
      return false;
    } on Object catch (error) {
      onError(error.toString());
      return false;
    }
  }

  Future<bool> _probeFirestoreWrite({
    required String userId,
    required void Function(String message) onError,
  }) async {
    try {
      await _firebaseService.firestore
          .collection(FirestoreCollections.systemMeta)
          .doc(FirestoreCollections.healthProbeDoc)
          .set(
        <String, dynamic>{
          'probe': true,
          'updatedAt': FieldValue.serverTimestamp(),
          'uid': userId,
        },
        SetOptions(merge: true),
      );
      return true;
    } on FirebaseException catch (error) {
      onError(error.message ?? error.code);
      return false;
    } on Object catch (error) {
      onError(error.toString());
      return false;
    }
  }

  Future<bool> _probeStorage({
    required void Function(String message) onError,
  }) async {
    try {
      final Reference probeRef =
          _firebaseService.storage.ref().child('_meta/health_probe.txt');
      await probeRef.putData(
        Uint8List.fromList(<int>[0x30]),
        SettableMetadata(contentType: 'text/plain'),
      );
      await probeRef.delete();
      return true;
    } on FirebaseException catch (error) {
      onError(error.message ?? error.code);
      return false;
    } on Object catch (error) {
      onError(error.toString());
      return false;
    }
  }
}
