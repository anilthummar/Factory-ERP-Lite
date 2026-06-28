import '../../utils/exports.dart';

/// A class for managing default Firebase options.
///
/// This class provides platform-specific Firebase options based on the current platform.
class DefaultFirebaseOptions {
  /// A singleton instance of [DefaultFirebaseOptions].
  static DefaultFirebaseOptions instance = getIt<DefaultFirebaseOptions>();

  /// Platform [FirebaseOptions] without GetIt (background FCM isolate).
  static FirebaseOptions platformOptions() {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: configWebApiKey,
        appId: configWebAppId,
        messagingSenderId: configMessagingSenderId,
        projectId: configProjectId,
        measurementId: configMeasurementId,
        authDomain: configAuthDomain,
        storageBucket: configStorageBucket,
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: configAndroidApiKey,
          appId: configAndroidAppId,
          messagingSenderId: configMessagingSenderId,
          projectId: configProjectId,
          storageBucket: configStorageBucket,
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: configIOSApiKey,
          appId: configIosAppId,
          messagingSenderId: configMessagingSenderId,
          projectId: configProjectId,
          storageBucket: configStorageBucket,
        );
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  /// Returns the Firebase options for the current platform.
  FirebaseOptions get currentPlatform => platformOptions();
}
