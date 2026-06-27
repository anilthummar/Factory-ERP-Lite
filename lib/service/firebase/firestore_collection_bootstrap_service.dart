import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';
import 'firestore_collections.dart';

/// Ensures Firestore module collections exist via bootstrap sentinel documents.
///
/// Firestore creates a collection on first write; this service writes a
/// `_bootstrap` document when the collection has not been initialized yet.
class FirestoreCollectionBootstrapService {
  /// Creates [FirestoreCollectionBootstrapService].
  FirestoreCollectionBootstrapService({
    required FirebaseService firebaseService,
    FirebaseFirestore? firestore,
  })  : _firebaseService = firebaseService,
        _firestore = firestore;

  final FirebaseService _firebaseService;
  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? _firebaseService.firestore;

  /// Writes bootstrap documents for all ERP module collections.
  ///
  /// Returns a map of collection name → success.
  Future<Map<String, bool>> ensureModuleCollections({
    required String userId,
  }) async {
    if (!_firebaseService.isInitialized) {
      return <String, bool>{};
    }

    final Map<String, bool> results = <String, bool>{};
    for (final String collection in FirestoreCollections.bootstrapCollections) {
      results[collection] = await _ensureCollection(
        collection: collection,
        userId: userId,
      );
    }
    return results;
  }

  Future<bool> _ensureCollection({
    required String collection,
    required String userId,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef = _db
          .collection(collection)
          .doc(FirestoreCollections.bootstrapDocId);
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await docRef.get();
      if (snapshot.exists) {
        return true;
      }

      await docRef.set(<String, dynamic>{
        'initialized': true,
        'initializedAt': FieldValue.serverTimestamp(),
        'initializedBy': userId,
      });
      return true;
    } on Object {
      return false;
    }
  }
}
