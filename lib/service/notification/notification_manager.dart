import '../../modules/notifications/service/notification_background_handler.dart';
import '../../utils/exports.dart';

/// Manages FCM background handler registration and token retrieval.
class NotificationManager {
  NotificationManager._internal();

  /// The instance of the [NotificationManager].
  static final NotificationManager instance = NotificationManager._internal();

  /// Registers background FCM handler and retrieves device token.
  ///
  /// Foreground FCM and local scheduling are handled by [NotificationService].
  Future<void> init() async {
    if (!kIsWeb) {
      _registerBackgroundHandler();
    }
    await _getToken();
    await _logInitialMessage();
  }

  void _registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundNotificationHandler);
  }

  Future<void> _getToken({int maxRetries = 3}) async {
    if (kIsWeb && configVapidKey.isEmpty) {
      return;
    }

    try {
      final String? token = await FirebaseMessaging.instance.getToken(
        vapidKey: kIsWeb ? configVapidKey : null,
      );
      await SentryService.instance.captureEvent(token.toString(), type: 'token');
      DebugLog.instance.d('FCM Token : $token');
    } on Exception {
      if (maxRetries > 0) {
        await Future<void>.delayed(const Duration(seconds: Dimens.duration5));
        await _getToken(maxRetries: maxRetries - 1);
      }
    }
  }

  Future<void> _logInitialMessage() async {
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      DebugLog.instance.i(
        'FCM Initial Message : ${message.data} ${message.notification}',
      );
    }
  }
}
