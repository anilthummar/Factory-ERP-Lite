import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../app/core/config/app_constant.dart';
import '../../../service/firebase/firebase_options.dart';

/// Background FCM entry point (separate isolate).
@pragma('vm:entry-point')
Future<void> firebaseBackgroundNotificationHandler(RemoteMessage message) async {
  if (kIsWeb) {
    return;
  }

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.platformOptions(),
    );
  }

  final String title =
      message.notification?.title ?? message.data['title'] as String? ?? '';
  final String body =
      message.notification?.body ?? message.data['body'] as String? ?? '';
  if (title.isEmpty && body.isEmpty) {
    return;
  }

  const String channelId = 'factory_erp_reminders';
  const String channelName = 'Factory Reminders';

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  if (defaultTargetPlatform == TargetPlatform.android) {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            description: NotificationConst.channelDescription,
            importance: Importance.high,
          ),
        );
  }

  await plugin.show(
    message.hashCode,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: NotificationConst.channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}
