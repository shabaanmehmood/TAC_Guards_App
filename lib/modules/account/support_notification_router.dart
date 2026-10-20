import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tac/modules/account/support_chat_screens.dart';

class SupportNotificationRouter {
  static void open(Map<String, dynamic> payload) {
    if (payload['type']?.toString() != 'support') return;
    final ticketId = payload['ticketId']?.toString();
    if (ticketId == null || ticketId.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.to(() => SupportThreadScreen(ticketId: ticketId));
    });
  }
}
