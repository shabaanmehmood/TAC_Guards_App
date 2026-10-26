import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/dataproviders/api_service.dart';

import 'community_service.dart';
import 'community_view.dart';

export 'community_service.dart';
export 'community_view.dart';
export 'components/create_post_view.dart';
export 'components/post_card.dart';
export 'components/report_reason_sheet.dart';
export 'components/thread_view.dart';

String communityImageUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  final origin = Uri.parse(MyApIService().baseurl).origin;
  final clean = path.startsWith('/') ? path.substring(1) : path;
  return '$origin/uploads/$clean';
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommunityView(showAppBar: false);
  }
}

class CommunityThreadScreen extends StatelessWidget {
  const CommunityThreadScreen({
    super.key,
    required this.postId,
    this.commentId,
  });

  final String postId;
  final String? commentId;

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final token = userController.accessToken.value ?? '';
    final accountId = userController.accountId.value ?? '';
    final accountType = userController.accountType.value;
    final service = CommunityService(
      token: token,
      accountId: accountId,
      accountType: accountType,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B132B),
        elevation: 0,
        title: const Text(
          'Post Thread',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CommunityThreadView(
        service: service,
        postId: postId,
        commentId: commentId,
        canComment: true,
        onVerifiedPostDenied: () {},
        onHiddenPost: () => Navigator.pop(context),
      ),
    );
  }
}

class CommunityComposerScreen extends StatelessWidget {
  const CommunityComposerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final token = userController.accessToken.value ?? '';
    final accountId = userController.accountId.value ?? '';
    final accountType = userController.accountType.value;
    final service = CommunityService(
      token: token,
      accountId: accountId,
      accountType: accountType,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B132B),
        elevation: 0,
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CreatePostView(
        service: service,
        topics: const [],
        onPostingDenied: () {},
        onInactive: () {},
      ),
    );
  }
}
