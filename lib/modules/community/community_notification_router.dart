import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'community_screen.dart';

class CommunityNotificationRouter {
  static void open(Map<String, dynamic> payload) {
    if (payload['type']?.toString() != 'community') return;
    final postId = payload['postId']?.toString();
    if (postId == null || postId.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.to(() => CommunityThreadScreen(postId: postId));
    });
  }
}
