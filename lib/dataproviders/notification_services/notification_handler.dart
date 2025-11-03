import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tac/dataproviders/notification_services/notification_services.dart';
import 'dart:io';

class NotificationHandlerController {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _currentFCMToken;

  static Future<void> initializeFCMHandlers() async {
    try {
      // 🔹 Request notification permissions first
      await NotificationServices.requestNotificationPermission();

      // 🔹 Get and handle FCM token - USE DUMMY FOR SIMULATOR
      await _handleFCMToken();

      // 🔹 Set up message handlers
      await _setupMessageHandlers();

      // 🔹 Handle terminated state notifications
      await handleTerminatedState();

      print("✅ FCM Handlers initialized successfully");
    } catch (e) {
      print("❌ Error initializing FCM handlers: $e");
    }
  }

  static Future<void> _handleFCMToken() async {
    try {
      // 🔹 SIMULATOR DETECTION - Use dummy token for simulator
      if (await _isSimulator()) {
        _currentFCMToken = _generateDummyFCMToken();
        print(
            "🎮 iOS Simulator detected - Using DUMMY FCM Token: $_currentFCMToken");

        // Send dummy token to backend for testing
        await _sendTokenToBackend(_currentFCMToken!);
        return;
      }

      // 🔹 REAL DEVICE - Get actual FCM token
      String? fcmToken = await _messaging.getToken();

      if (fcmToken != null && fcmToken.isNotEmpty) {
        _currentFCMToken = fcmToken;
        print("📱 Real Device - FCM Token: $fcmToken");
        await _sendTokenToBackend(fcmToken);
      } else {
        // Fallback to dummy token if real token is null/empty
        _currentFCMToken = _generateDummyFCMToken();
        print(
            "⚠️  Real token empty - Using DUMMY FCM Token: $_currentFCMToken");
        await _sendTokenToBackend(_currentFCMToken!);
      }

      // Listen for token refreshes (only on real devices)
      if (!await _isSimulator()) {
        _messaging.onTokenRefresh.listen((newToken) {
          print("🔄 FCM Token refreshed: $newToken");
          _currentFCMToken = newToken;
          _sendTokenToBackend(newToken);
        });
      }
    } catch (e) {
      print("❌ Error handling FCM token: $e");
      // Always fallback to dummy token on error
      _currentFCMToken = _generateDummyFCMToken();
      await _sendTokenToBackend(_currentFCMToken!);
    }
  }

  /// 🔹 SIMULATOR DETECTION
  static Future<bool> _isSimulator() async {
    try {
      if (Platform.isIOS) {
        // iOS Simulator detection
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          return true; // No APNS token = simulator
        }

        // Additional check: try to get FCM token
        final fcmToken = await _messaging.getToken();
        if (fcmToken == null || fcmToken.isEmpty) {
          return true; // No FCM token = simulator
        }

        return false; // Has tokens = real device
      }

      // Android emulator detection (optional)
      if (Platform.isAndroid) {
        // Android emulators usually can get FCM tokens,
        // but you can add detection if needed
        return false;
      }

      return false;
    } catch (e) {
      print("🎮 Simulator detection error, assuming simulator: $e");
      return true; // Assume simulator on error
    }
  }

  /// 🔹 GENERATE REALISTIC DUMMY FCM TOKEN
  static String _generateDummyFCMToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomId = _generateRandomString(16);

    if (Platform.isIOS) {
      return "ios_simulator_dummy_fcm_${timestamp}_${randomId}";
    } else {
      return "android_emulator_dummy_fcm_${timestamp}_${randomId}";
    }
  }

  /// 🔹 GENERATE RANDOM STRING FOR DUMMY TOKEN
  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  static Future<void> _setupMessageHandlers() async {
    // 🔹 FOREGROUND MESSAGES
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message received on ${Platform.operatingSystem}");
      print("📊 Message data: ${message.data}");

      String payloadData = jsonEncode(message.data);

      // Show notification
      if (message.notification != null) {
        NotificationServices.showSimpleNotification(
          title: message.notification!.title ?? "New Notification",
          body: message.notification!.body ?? "You have a new message",
          payload: payloadData,
        );
      } else if (message.data.isNotEmpty) {
        // Show notification for data-only messages
        NotificationServices.showSimpleNotification(
          title: message.data['title'] ?? "Notification",
          body: message.data['body'] ?? "New update available",
          payload: payloadData,
        );
      }
    });

    // 🔹 APP OPENED FROM BACKGROUND/TERMINATED
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 App opened via notification");
      _handleNotificationNavigation(message);
    });

    // 🔹 BACKGROUND MESSAGE HANDLER
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  }

  // Background message handler
  @pragma('vm:entry-point')
  static Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
    print("🔵 Background message received");

    // Note: On iOS simulator, background messages won't work
    // On real devices, this handles background data processing
    if (message.data.isNotEmpty) {
      print("📊 Background data: ${message.data}");
    }
  }

  static Future<void> handleTerminatedState() async {
    try {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print("🚀 App launched from terminated state by notification");
        _handleNotificationNavigation(initialMessage);
      }
    } catch (e) {
      print("❌ Error handling terminated state: $e");
    }
  }

  static void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;

    if (data.containsKey('screen')) {
      String screen = data['screen'];
      print("🧭 Navigating to: $screen");
      // Add your navigation logic here
    }
  }

  static Future<void> _sendTokenToBackend(String token) async {
    try {
      // Replace with your actual backend API call
      print("📤 Sending FCM token to backend: $token");
      print("📱 Platform: ${Platform.operatingSystem}");
      print("🎮 Is Simulator: ${await _isSimulator()}");

      // Example: Send to your backend
      // await http.post(
      //   Uri.parse('your-api-url/save-token'),
      //   body: jsonEncode({
      //     'fcmToken': token,
      //     'platform': Platform.operatingSystem,
      //     'isSimulator': await _isSimulator(),
      //     'deviceId': 'simulator_${DateTime.now().millisecondsSinceEpoch}',
      //   }),
      // );
    } catch (e) {
      print("❌ Error sending token to backend: $e");
    }
  }

  // 🔹 GET CURRENT FCM TOKEN (DUMMY OR REAL)
  static String? get currentFCMToken => _currentFCMToken;

  // 🔹 MANUAL TOKEN REFRESH
  static Future<void> refreshFCMToken() async {
    print("🔄 Manually refreshing FCM token...");
    await _handleFCMToken();
  }

  // 🔹 CHECK IF USING DUMMY TOKEN
  static Future<bool> isUsingDummyToken() async {
    return await _isSimulator();
  }
}
