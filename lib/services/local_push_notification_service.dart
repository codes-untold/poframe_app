import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init({bool schedule = false}) async {
    var initAndroidSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOSSettings = const IOSInitializationSettings();
    final settings = InitializationSettings(
        android: initAndroidSettings, iOS: initIOSSettings);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      try {
        Map<String, dynamic> parsedPayload = json.decode(payload!);
        // print("payload clicked: " + parsedPayload.toString());
        _handleOnclickNotification(parsedPayload);
      } catch (e) {}
    });
  }

  static Future showNotification(
          {var id = 0,
          required String title,
          required String body,
          dynamic payload}) async =>
      _notifications.show(id, title, body, await notificationDetails(),
          payload: payload);

  static notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel_id', 'channel_name',
            importance: Importance.max, priority: Priority.high),
        iOS: IOSNotificationDetails());
  }

  static _handleOnclickNotification(Map<String, dynamic> payload) {
    try {} catch (e) {}
  }
}
