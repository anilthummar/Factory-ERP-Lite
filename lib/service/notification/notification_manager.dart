import '../../main.dart';
import '../../utils/exports.dart';

/// Manages the notification setup and handling.
class NotificationManager {
  NotificationManager._internal();

  /// The instance of the [NotificationManager].
  static final NotificationManager instance = NotificationManager._internal();

  /// Initializes the notification manager.
  Future<void> init() async {
    await AwesomeNotificationManager.instance.init();
    await firebaseInitialize();
    _getBackgroundMessage();
    await _getToken();
    await _getInitialMessage();
    _onMessage();
    _onMessageOpenedApp();
  }

  /// Initializes Firebase.
  Future<void> firebaseInitialize() async {
    await getIt<FirebaseService>().init();
  }

  /// Sets up the background message handler.
  void _getBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(firebaseBackground);
  }

  /// Retrieves the Firebase token.
  ///
  /// [maxRetries] is the maximum number of retries for token retrieval.
  Future<void> _getToken({int maxRetries = 3}) async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken(
        vapidKey: kIsWeb ? configVapidKey : null,
      );
      await SentryService.instance
          .captureEvent(token.toString(), type: "token");
      DebugLog.instance.d("FCM Token : \\$token");
    } on Exception {
      if (maxRetries > 0) {
        await Future<dynamic>.delayed(
            const Duration(seconds: Dimens.duration5));
        await _getToken(maxRetries: maxRetries - 1);
      }
    }
  }

  /// Handles the initial message when the app is opened from a terminated state.
  Future<void> _getInitialMessage() async {
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      DebugLog.instance.i(
          "FCM Initial Message : \\\${message?.data} \\\${message?.notification}");
    });
  }

  /// Sets up the foreground message handler.
  void _onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      DebugLog.instance.i(
          "FCM Foreground Message : \\\${message.data} \\\${message.notification}");
      await AwesomeNotificationManager.instance
          .showNotification(payload: message.data);
    });
  }

  /// Handles the message when the app is opened from the background.
  void _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      DebugLog.instance.i(
          "FCM MessageOpenedApp Message : \\\${message.data} \\\${message.notification}");
    });
  }
}
