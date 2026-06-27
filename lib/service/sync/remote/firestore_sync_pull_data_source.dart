import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase/firebase_service.dart';
import '../../firebase/firestore_collections.dart';
import '../sync_module_registry.dart';

/// Reads module documents from Firestore for inbound sync.
class FirestoreSyncPullDataSource {
  /// Creates [FirestoreSyncPullDataSource].
  FirestoreSyncPullDataSource({
    required FirebaseService firebaseService,
    FirebaseFirestore? firestore,
  })  : _firebaseService = firebaseService,
        _firestore = firestore;

  final FirebaseService _firebaseService;
  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? _firebaseService.firestore;

  /// Fetches all user records for [collection], excluding bootstrap docs.
  Future<List<Map<String, dynamic>>> pullCollection(
    String collection,
  ) async {
    if (!_firebaseService.isInitialized) {
      return <Map<String, dynamic>>[];
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection(collection).get();

    final List<Map<String, dynamic>> records = <Map<String, dynamic>>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      if (_shouldSkipDocument(doc.id)) {
        continue;
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
      data.putIfAbsent('id', () => doc.id);
      records.add(data);
    }
    return records;
  }

  bool _shouldSkipDocument(String documentId) {
    return documentId == FirestoreCollections.bootstrapDocId ||
        documentId.startsWith('_');
  }
}
