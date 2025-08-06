import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tac/dataproviders/notification_services/notification_services.dart';

class NotificationHandlerController {
  static void initializeFCMHandlers() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message received: $message");

      String payloadData = jsonEncode(message.data);
      if (message.notification != null) {
        NotificationServices.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData,
        );
      }
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 App opened via notification: $message");
      // Handle navigation or other actions
    });
  }

  static Future<void> handleTerminatedState() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("🚀 App launched from terminated by notification: $initialMessage");
      // Handle deep linking/navigation
    }
  }
}
