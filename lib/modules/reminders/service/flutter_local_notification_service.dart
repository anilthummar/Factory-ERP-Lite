import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../app/core/config/app_constant.dart';
import '../domain/models/reminder_type.dart';

/// Local notification channel and display using flutter_local_notifications.
class FlutterLocalNotificationService {
  /// Creates [FlutterLocalNotificationService].
  FlutterLocalNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const String _channelId = 'factory_erp_reminders';
  static const String _channelName = 'Factory Reminders';

  bool _initialized = false;

  /// Initializes plugin, timezone data, and Android/iOS channels.
  Future<void> init() async {
    if (_initialized || kIsWeb) {
      return;
    }

    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
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
    }

    final bool? granted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    if (granted == false) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    _initialized = true;
  }

  /// Shows an immediate local notification.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    ReminderType? type,
  }) async {
    if (!_initialized) {
      await init();
    }

    await _plugin.show(
      id,
      title,
      body,
      _notificationDetails(),
      payload: type?.name,
    );
  }

  /// Schedules a local notification at [scheduledDate].
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    ReminderType? type,
  }) async {
    if (!_initialized) {
      await init();
    }

    final tz.TZDateTime when = tz.TZDateTime.from(scheduledDate, tz.local);
    if (when.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      when,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: type?.name,
    );
  }

  /// Cancels all pending scheduled notifications.
  Future<void> cancelAll() => _plugin.cancelAll();

  NotificationDetails _notificationDetails() {
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
