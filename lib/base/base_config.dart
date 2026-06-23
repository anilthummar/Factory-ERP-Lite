// -----------------------------
// Private Environment Variable Keys
// -----------------------------

/// Key for the base URL of the API.
const String _baseUrlKey = 'base_url';

/// Key for the Android app ID.
const String _androidAppId = 'androidAppId';

/// Key for the iOS app ID.
const String _iosAppId = 'iosAppId';

/// Key for the web app ID.
const String _webAppId = 'webAppId';

/// Key for the Firebase messaging sender ID.
const String _messagingSenderId = 'messagingSenderId';

/// Key for the Firebase project ID.
const String _projectId = 'projectId';

/// Key for the Firebase iOS API key.
const String _iosApiKey = 'iosApiKey';

/// Key for the Firebase Android API key.
const String _androidApiKey = 'androidApiKey';

/// Key for the Sentry DSN (used for error reporting).
const String _sentryDSNKey = 'sentryDSN';

/// Key to identify the environment (e.g., stage or production).
const String _envKey = 'envKey';

/// Key for the Firebase web API key.
const String _webApiKey = 'webApiKey';

/// Key for the Firebase auth domain (web).
const String _authDomain = 'authDomain';

/// Key for the Firebase storage bucket.
const String _storageBucket = 'storageBucket';

/// Key for the Firebase measurement ID (used for analytics).
const String _measurementId = 'measurementId';

/// Key for the VAPID key used in web push notifications.
const String _vapidKey = 'vapidKey';

/// Key for the Google OAuth Web client ID (required for Android Google Sign-In).
const String _googleWebClientId = 'googleWebClientId';

// -----------------------------
// Public Config Accessors
// -----------------------------

/// Returns the base URL used for network requests.
String get configBaseUrl {
  return const String.fromEnvironment(_baseUrlKey);
}

/// Returns the current app environment (e.g., "stage", "production").
String get configEnv {
  return const String.fromEnvironment(_envKey);
}

/// Returns the Android application ID.
String get configAndroidAppId {
  return const String.fromEnvironment(_androidAppId);
}

/// Returns the iOS application ID.
String get configIosAppId {
  return const String.fromEnvironment(_iosAppId);
}

/// Returns the Web application ID.
String get configWebAppId {
  return const String.fromEnvironment(_webAppId);
}

/// Returns the Sentry DSN for crash/error reporting.
String get configSentryDSN {
  return const String.fromEnvironment(_sentryDSNKey);
}

/// Returns the Firebase Messaging sender ID.
String get configMessagingSenderId {
  return const String.fromEnvironment(_messagingSenderId);
}

/// Returns the Firebase Project ID.
String get configProjectId {
  return const String.fromEnvironment(_projectId);
}

/// Returns the Firebase API key for iOS.
String get configIOSApiKey {
  return const String.fromEnvironment(_iosApiKey);
}

/// Returns the Firebase API key for Android.
String get configAndroidApiKey {
  return const String.fromEnvironment(_androidApiKey);
}

/// Returns the Firebase Web API key.
String get configWebApiKey {
  return const String.fromEnvironment(_webApiKey);
}

/// Returns the Firebase authentication domain for Web.
String get configAuthDomain {
  return const String.fromEnvironment(_authDomain);
}

/// Returns the Firebase storage bucket name.
String get configStorageBucket {
  return const String.fromEnvironment(_storageBucket);
}

/// Returns the Firebase measurement ID used for analytics.
String get configMeasurementId {
  return const String.fromEnvironment(_measurementId);
}

/// Returns the VAPID key used for Web push notifications.
String get configVapidKey {
  return const String.fromEnvironment(_vapidKey);
}

/// Returns the Google OAuth Web client ID for Firebase Google Sign-In on Android.
String get configGoogleWebClientId {
  return const String.fromEnvironment(_googleWebClientId);
}
