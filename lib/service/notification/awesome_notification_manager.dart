import 'dart:ui';

import '../../utils/exports.dart';

/// This method is used to detect when a new notification or a schedule is created.
@pragma("vm:entry-point")
Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification) async {
  DebugLog.instance.d("on Create Method");
}

/// This method is used to detect if the user dismissed a notification.
@pragma("vm:entry-point")
Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction) async {
  DebugLog.instance.i("on Dismiss Method");
}

/// This method is used to detect every time that a new notification is displayed.
@pragma("vm:entry-point")
Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification) async {
  DebugLog.instance.d("on Display Method");
}

/// This method is used to detect when the user taps on a notification or action button.
@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  DebugLog.instance.t("on Action Received Method ");
}

/// Manages the Awesome Notifications setup and handling.
class AwesomeNotificationManager {
  AwesomeNotificationManager._internal();

  /// The instance of the [AwesomeNotificationManager].
  static final AwesomeNotificationManager instance =
      AwesomeNotificationManager._internal();
  static final AwesomeNotifications _awesomeNotification =
      AwesomeNotifications();

  /// The receive port for notification actions.
  static ReceivePort? receivePort;

  /// Initializes the Awesome Notifications.
  Future<void> init() async {
    await _initializeAwesomeNotification();
    !kIsWeb ? _initializeIsolatePort() : null;
  }

  /// Initializes the Awesome Notifications with channels and listeners.
  Future<void> _initializeAwesomeNotification() async {
    await _awesomeNotification.initialize(
        // set the icon to null if you want to use the default app icon
        null,
        <NotificationChannel>[
          NotificationChannel(
              channelGroupKey: NotificationConst.channelGroupKey,
              channelKey: NotificationConst.channelKey,
              channelName: NotificationConst.channelName,
              channelDescription: NotificationConst.channelDescription,
              defaultColor: Colors.blue,
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: <NotificationChannelGroup>[
          NotificationChannelGroup(
              channelGroupKey: NotificationConst.channelGroupKey,
              channelGroupName: NotificationConst.channelGroupName)
        ],
        debug: true);

    // Checks if the notification permissions are allowed.
    await _awesomeNotification.isNotificationAllowed().then((bool isAllowed) {
      if (!isAllowed) {
        // Requests permission to send notifications.
        unawaited(_awesomeNotification.requestPermissionToSendNotifications());
      }
    });
    // Sets listeners for notification events.
    await _awesomeNotification.setListeners(
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
    !kIsWeb ? _initializeIsolatePort() : null;
  }

  /// Initializes the isolate port for notification actions.
  void _initializeIsolatePort() {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen((dynamic silentData) async =>
          onActionReceivedImplementationMethod(silentData));

    // Registers the port with the name for notification actions.
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  /// Handles the action received from notifications.
  static Future<void> onActionReceivedImplementationMethod(
    ReceivedAction receivedAction,
  ) async {
    DebugLog.instance.t("on Action Received Method");
  }

  /// Creates a notification in the system tray.
  ///
  /// [payload] is the data payload for the notification.
  Future<void> showNotification({Map<String, dynamic>? payload}) async {
    if (payload?.isNotEmpty ?? false) {
      await _awesomeNotification.createNotification(
        content: NotificationContent(
            id: Random().nextInt(1000),
            channelKey: NotificationConst.channelKey,
            title: payload!["title"] ?? "",
            body: payload["body"] ?? "",
            bigPicture: payload["image"] ?? "",
            payload: Map<String, String>.from(payload)),
      );
    }
  }
}
