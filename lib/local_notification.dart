// lib/local_notification.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static late final FlutterLocalNotificationsPlugin _notificationsPlugin;

static Future<void> initialize() async {
  // Initialize notifications plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize the plugin with the updated callback
  await _notificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        print('Notification payload: ${response.payload}');
        // Perform actions based on the notification payload
      }
    },
  );
}


  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
  'your_channel_id',        // Channel ID
  'Your Channel Name',      // Channel name
  channelDescription: 'Your Channel Description',
  importance: Importance.max,
  priority: Priority.high,
);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
