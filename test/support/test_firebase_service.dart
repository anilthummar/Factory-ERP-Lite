import 'package:firebase_core/firebase_core.dart';
import 'package:factory_erp_lite/service/firebase/firebase_options.dart';
import 'package:factory_erp_lite/service/firebase/firebase_service.dart';

/// [FirebaseService] stand-in that reports initialized without calling [init].
class TestFirebaseService extends FirebaseService {
  /// Creates [TestFirebaseService].
  TestFirebaseService() : super(_TestFirebaseOptions());

  @override
  bool get isInitialized => true;
}

/// Uninitialized [FirebaseService] stub for failure-path tests.
class FirebaseServiceStub extends TestFirebaseService {
  @override
  bool get isInitialized => false;
}

class _TestFirebaseOptions extends DefaultFirebaseOptions {
  @override
  FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: 'fake-api-key',
        appId: '1:1234567890:android:fake',
        messagingSenderId: '1234567890',
        projectId: 'factory-erp-lite-test',
      );
}
