import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
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
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // FIXED: Platform-specific permission request
    await _requestPlatformSpecificPermissions();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // FIXED: Safe platform-specific permission request
  static Future<void> _requestPlatformSpecificPermissions() async {
    if (Platform.isAndroid) {
      // Only request Android permissions on Android devices
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // SAFE: Check for null before calling methods
      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        print("Android notification permission requested");
      } else {
        print("Android plugin not available - running on iOS");
      }
    } else if (Platform.isIOS) {
      // iOS permissions are handled by DarwinInitializationSettings
      print("iOS notification permissions handled during initialization");

      // For iOS simulator, we can add specific handling if needed
      final bool isSimulator = await _isIOSSimulator();
      if (isSimulator) {
        print(
            "Running on iOS simulator - some notification features may be limited");
      }
    }
  }

  // Helper method to detect iOS simulator
  static Future<bool> _isIOSSimulator() async {
    if (!Platform.isIOS) return false;

    try {
      // Try to get APNS token - simulators usually return null
      final apnsToken = await messaging.getAPNSToken();
      return apnsToken == null;
    } catch (e) {
      return true; // If we can't get APNS token, assume simulator
    }
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    // navigatorKey.currentState!
    //     .pushNamed("/message", arguments: notificationResponse);
    print("Notification tapped: ${notificationResponse.payload}");
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
      if (Platform.isIOS && await _isIOSSimulator()) {
        // Return dummy token for iOS simulator
        final dummyToken =
            "fkN6dPp-TyKv4VWBrBqLp3:APA91bFakeTokenForTesting_1aBCdEfG2HiJkLmNoPqRsTuVwXyZ0A1b2C3dE4fG5hIjK6lM7nO8pQ9rS0tU1vWxYzA2B3C4D5E6F7G8H9I0J1K2L3M4N5O6P7Q8R9S0T1U2V3W4X5Y6Z7a8b9c0d1e2f3g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0x1y2z3";
        //   "ios_simulator_dummy_fcm_${DateTime.now().millisecondsSinceEpoch}";
        print("Using dummy FCM token for iOS simulator: $dummyToken");
        return dummyToken;
      } else {
        // Get real token for Android and real iOS devices
        final token = await messaging.getToken();
        print("FCM Token: $token");
        return token;
      }
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }
}
