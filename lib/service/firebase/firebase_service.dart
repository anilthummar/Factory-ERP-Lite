import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';

/// Central Firebase bootstrap and service accessors.
///
/// Mobile app and Flutter Web admin share the same Firebase project.
class FirebaseService {
  FirebaseService(this._options);

  final DefaultFirebaseOptions _options;

  bool _initialized = false;

  /// Whether [init] has completed successfully.
  bool get isInitialized => _initialized;

  /// Initializes Firebase Core once for all Firebase SDKs.
  Future<void> init() async {
    if (_initialized || Firebase.apps.isNotEmpty) {
      _initialized = true;
      return;
    }

    await Firebase.initializeApp(options: _options.currentPlatform);
    _initialized = true;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  FirebaseAuth get auth => FirebaseAuth.instance;

  FirebaseStorage get storage => FirebaseStorage.instance;

  /// Enables Firestore offline persistence on mobile (web uses built-in cache).
  Future<void> configureFirestore() async {
    if (kIsWeb) {
      return;
    }
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}
