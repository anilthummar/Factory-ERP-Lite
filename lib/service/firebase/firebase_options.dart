import '../../utils/exports.dart';

/// A class for managing default Firebase options.
///
/// This class provides platform-specific Firebase options based on the current platform.
class DefaultFirebaseOptions {
  /// A singleton instance of [DefaultFirebaseOptions].
  static DefaultFirebaseOptions instance = getIt<DefaultFirebaseOptions>();

  /// Returns the Firebase options for the current platform.
  FirebaseOptions get currentPlatform {
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
            projectId: configProjectId);
      case TargetPlatform.iOS:
        return FirebaseOptions(
            apiKey: configIOSApiKey,
            appId: configIosAppId,
            messagingSenderId: configMessagingSenderId,
            projectId: configProjectId);
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }
}
