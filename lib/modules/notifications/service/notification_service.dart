import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../app/core/config/app_constant.dart';
import '../../../base/base_config.dart';
import '../domain/models/notification_type.dart';
import '../domain/models/scheduled_notification_item.dart';

/// Local notifications (flutter_local_notifications) and FCM delivery.
class NotificationService {
  /// Creates [NotificationService].
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    FirebaseMessaging? messaging,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _messaging = messaging ?? FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _plugin;
  final FirebaseMessaging _messaging;

  static const String _channelId = 'factory_erp_reminders';
  static const String _channelName = 'Factory Reminders';

  bool _localInitialized = false;
  bool _fcmInitialized = false;

  /// Initializes timezone data, local channels, and permissions.
  Future<void> initLocalNotifications() async {
    if (_localInitialized || kIsWeb) {
      return;
    }

    tz_data.initializeTimeZones();

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: NotificationConst.channelDescription,
              importance: Importance.high,
            ),
          );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    _localInitialized = true;
  }

  /// Registers FCM foreground handlers that surface via local notifications.
  Future<void> initFcm({
    void Function(RemoteMessage message)? onMessageOpenedApp,
  }) async {
    if (_fcmInitialized) {
      return;
    }

    if (!kIsWeb || configVapidKey.isNotEmpty) {
      await _messaging.getToken(vapidKey: kIsWeb ? configVapidKey : null);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final String title =
          message.notification?.title ?? message.data['title'] as String? ?? '';
      final String body =
          message.notification?.body ?? message.data['body'] as String? ?? '';
      if (title.isEmpty && body.isEmpty) {
        return;
      }
      await showNow(
        id: message.hashCode,
        title: title,
        body: body,
        type: NotificationType.calendarEvent,
      );
    });

    if (onMessageOpenedApp != null) {
      FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    }

    _fcmInitialized = true;
  }

  /// Shows an immediate local notification.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    NotificationType? type,
  }) async {
    await _ensureLocalReady();
    await _plugin.show(
      id,
      title,
      body,
      _details(),
      payload: type?.name,
    );
  }

  /// Schedules a local notification from [item].
  Future<void> schedule(ScheduledNotificationItem item) async {
    if (kIsWeb) {
      return;
    }

    await _ensureLocalReady();

    final tz.TZDateTime when =
        tz.TZDateTime.from(item.scheduledAt, tz.local);
    if (when.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      item.id,
      item.title,
      item.body,
      when,
      _details(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: item.type.name,
    );
  }

  /// Cancels a scheduled notification by [id].
  Future<void> cancel(int id) => _plugin.cancel(id);

  /// Cancels all scheduled and displayed notifications.
  Future<void> cancelAll() async {
    if (kIsWeb) {
      return;
    }
    await _plugin.cancelAll();
  }

  /// Replaces an existing scheduled notification.
  Future<void> update(ScheduledNotificationItem item) async {
    await cancel(item.id);
    await schedule(item);
  }

  Future<void> _ensureLocalReady() async {
    if (!_localInitialized) {
      await initLocalNotifications();
    }
  }

  NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: NotificationConst.channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}
