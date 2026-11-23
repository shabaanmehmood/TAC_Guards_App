import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tac/dataproviders/notification_services/notification_services.dart';
import 'package:tac/modules/account/support_notification_router.dart';
import 'package:tac/modules/community/community_notification_router.dart';

class NotificationHandlerController {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _currentFCMToken;
  static bool _handlersInitialized = false;
  static bool _messageHandlersRegistered = false;
  static bool _tokenRefreshRegistered = false;

  static Future<void> initializeFCMHandlers() async {
    if (_handlersInitialized) return;
    try {
      await NotificationServices.requestNotificationPermission();
      _listenForTokenRefresh();
      await _handleFCMToken();
      _setupMessageHandlers();
      await handleTerminatedState();
      _handlersInitialized = true;
      debugPrint('FCM handlers initialized.');
    } catch (error) {
      debugPrint('Error initializing FCM handlers: $error');
    }
  }

  static Future<void> _handleFCMToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken;
        for (var attempt = 0; attempt < 10 && apnsToken == null; attempt++) {
          apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future<void>.delayed(const Duration(milliseconds: 500));
          }
        }
        if (apnsToken == null) {
          debugPrint('APNs token unavailable; skipping FCM token retrieval.');
          return;
        }
      }

      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('FCM token unavailable.');
        return;
      }
      _currentFCMToken = token;
      debugPrint('FCM token retrieved.');
    } catch (error) {
      debugPrint('Error retrieving FCM token: $error');
    }
  }

  static void _listenForTokenRefresh() {
    if (_tokenRefreshRegistered) return;
    _tokenRefreshRegistered = true;
    _messaging.onTokenRefresh.listen((token) {
      _currentFCMToken = token;
      debugPrint('FCM token refreshed.');
    });
  }

  static void _setupMessageHandlers() {
    if (_messageHandlersRegistered) return;
    _messageHandlersRegistered = true;

    FirebaseMessaging.onMessage.listen((message) {
      final payload = jsonEncode(message.data);
      final notification = message.notification;
      final title = notification?.title ?? message.data['title']?.toString();
      final body = notification?.body ?? message.data['body']?.toString();
      if (title == null && body == null) return;
      NotificationServices.showSimpleNotification(
        title: title ?? 'Notification',
        body: body ?? 'New update available',
        payload: payload,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNavigation);
  }

  static Future<void> handleTerminatedState() async {
    try {
      final message = await _messaging.getInitialMessage();
      if (message != null) _handleNotificationNavigation(message);
    } catch (error) {
      debugPrint('Error handling terminated notification: $error');
    }
  }

  static void _handleNotificationNavigation(RemoteMessage message) {
    CommunityNotificationRouter.open(message.data);
    SupportNotificationRouter.open(message.data);
  }

  static String? get currentFCMToken => _currentFCMToken;

  static Future<void> refreshFCMToken() => _handleFCMToken();
}
