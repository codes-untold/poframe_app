import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'local_push_notification_service.dart';

class FirebasePushNotificationService {
  static Future init() async {
    if (!kIsWeb) {
      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      _handleMessage(message);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    _handleMessage(message);
    //print('Handling a background message ${message.messageId}');
  }

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<String?> getAPNToken() async {
    return await FirebaseMessaging.instance.getAPNSToken();
  }

  static subscribeAndUnsubscribeToTopic(
      {required String topic, required bool subscribe}) async {
    subscribe
        ? await FirebaseMessaging.instance.subscribeToTopic(topic)
        : await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  static _handleMessage(RemoteMessage message) {
    LocalPushNotificationService.showNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: message.notification!.body!);
  }
}
