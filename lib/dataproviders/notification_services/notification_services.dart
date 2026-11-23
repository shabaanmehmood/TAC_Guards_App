import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tac/modules/community/community_notification_router.dart';
import 'package:tac/modules/account/support_notification_router.dart';

class NotificationServices {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      print("user denied permission");
    }
  }

  static Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _requestPlatformSpecificPermissions();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static Future<void> _requestPlatformSpecificPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
      }
    }
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        final data = Map<String, dynamic>.from(decoded);
        CommunityNotificationRouter.open(data);
        SupportNotificationRouter.open(data);
      }
    } on FormatException catch (error) {
      debugPrint('Ignoring malformed notification payload: $error');
    }
  }

  // show a simple notification - Platform specific
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your channel name',
      channelDescription: 'your channel description',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      print("Notification shown successfully");
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  // Additional method to get FCM token safely
  static Future<String?> getFCMToken() async {
    try {
      if (Platform.isIOS && await messaging.getAPNSToken() == null) {
        debugPrint('APNs token is not available yet.');
        return null;
      }
      final token = await messaging.getToken();
      debugPrint('FCM token available: ${token != null && token.isNotEmpty}');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
}
