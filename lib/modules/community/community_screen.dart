import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:tac/dataproviders/api_service.dart';

import 'community_controller.dart';

const Color _communityBackground = Color(0xFF0B132B);
const Color _communityAccent = Color(0xFF00D3FF);

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityController controller = Get.isRegistered<CommunityController>()
      ? Get.find<CommunityController>()
      : Get.put(CommunityController(), permanent: true);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.loadInitial();
    _scrollController.addListener(_loadNextPage);
  }

  void _loadNextPage() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      controller.loadFeed();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadNextPage)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = controller.posts;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeedTabs(),
          _buildTopics(),
          if (controller.feedError.value != null && posts.isEmpty)
            Expanded(
              child: _errorState(controller.feedError.value!, controller.loadInitial),
            )
          else if (controller.isLoading.value && posts.isEmpty)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: _communityAccent),
              ),
            )
          else if (posts.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No posts yet. Start the conversation!',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                color: _communityAccent,
                onRefresh: () => controller.loadFeed(reset: true),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                  itemCount: posts.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == posts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: _communityAccent,
                          ),
                        ),
                      );
                    }
                    return CommunityPostCard(
                      post: posts[index],
                      controller: controller,
                    );
                  },
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildFeedTabs() {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              _filterChip(
                'Everyone',
                controller.topicId.value == null &&
                    controller.filter.value == 'everyone',
                controller.showEveryone,
              ),
              const SizedBox(width: 8),
              _filterChip(
                'Following',
                controller.filter.value == 'following',
                controller.showFollowing,
              ),
            ],
          ),
        ));
  }

  Widget _buildTopics() {
    return Obx(() {
      if (controller.topics.isEmpty) return const SizedBox(height: 4);
      return SizedBox(
        height: 42,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _filterChip(
              'All topics',
              controller.topicId.value == null,
              controller.showEveryone,
            ),
            ...controller.topics.map((topic) {
              final id = topic['id']?.toString();
              if (id == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _filterChip(
                  (topic['name'] ?? topic['title'] ?? 'Topic').toString(),
                  controller.topicId.value == id,
                  () => controller.showTopic(id),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _filterChip(String label, bool selected, VoidCallback onPressed) {
    return ActionChip(
      label: Text(label, style: TextStyle(color: selected ? _communityBackground : Colors.white)),
      backgroundColor: selected ? _communityAccent : const Color(0xFF17213D),
      side: BorderSide(color: selected ? _communityAccent : Colors.white24),
      onPressed: onPressed,
    );
  }

  Widget _errorState(String message, VoidCallback retry) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: retry, child: const Text('Try again')),
            ],
          ),
        ),
      );
}

class CommunityPostCard extends StatelessWidget {
  CommunityPostCard({
    super.key,
    required this.post,
    required this.controller,
  });

  final Map<String, dynamic> post;
  final CommunityController controller;

  Map<String, dynamic> get author => _asMap(post['author']) ?? {};
  String get postId => post['id']?.toString() ?? '';
  bool get isOwner =>
      author['id']?.toString() == controller.accountId &&
      author['type']?.toString().toLowerCase() == controller.accountType;
  bool get canEdit {
    if (!isOwner) return false;
    final createdAt = DateTime.tryParse(post['createdAt']?.toString() ?? '');
    return createdAt != null &&
        DateTime.now().difference(createdAt).inMinutes < 15 &&
        !DateTime.now().isBefore(createdAt);
  }

  @override
  Widget build(BuildContext context) {
    final rawImages = post['images'];
    final images = (rawImages is List ? rawImages : const [])
        .map((image) => image is Map ? image['url'] ?? image['imageUrl'] : image)
        .whereType<String>()
        .toList();
    final counts = _asMap(post['counts']) ?? {};
    final reactions = counts['reactions'];
    final reactionCount = reactions is num
        ? reactions.toInt()
        : reactions is Map
            ? reactions.values.whereType<num>().fold<int>(0, (sum, value) => sum + value.toInt())
            : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111C36),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _profileAvatar(author),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (author['fullName'] ?? author['name'] ?? 'Community member').toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _timeLabel(post['createdAt']?.toString()),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.white70),
                onSelected: (action) => _onMenuAction(context, action),
                itemBuilder: (_) => [
                  if (isOwner && canEdit)
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (isOwner)
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  if (!isOwner)
                    const PopupMenuItem(value: 'report', child: Text('Report')),
                ],
              ),
            ],
          ),
          if ((post['text'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              post['text'].toString(),
              style: const TextStyle(color: Colors.white, height: 1.4),
            ),
          ],
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            _postImages(images),
          ],
          if (post['topic'] != null || post['topicName'] != null) ...[
            const SizedBox(height: 10),
            Text(
              '#${_topicName(post)}',
              style: const TextStyle(color: _communityAccent, fontSize: 12),
            ),
          ],
          const Divider(color: Colors.white12, height: 22),
          Row(
            children: [
              _reactionMenu(
                targetType: 'post',
                target: post,
                controller: controller,
                count: reactionCount,
                selected: post['myReaction'] != null,
              ),
              const SizedBox(width: 18),
              _actionButton(
                icon: Icons.mode_comment_outlined,
                label: '${counts['comments'] ?? post['commentsCount'] ?? 0}',
                onPressed: () => Get.to(() => CommunityThreadScreen(postId: postId)),
              ),
              const Spacer(),
              if (!isOwner &&
                  (author['type']?.toString().toLowerCase() == 'guard' ||
                      author['type']?.toString().toLowerCase() == 'contractor'))
                TextButton(
                  onPressed: () => controller.toggleFollow(
                    author,
                    author['isFollowing'] == true,
                  ),
                  child: Text(
                    author['isFollowing'] == true ? 'Following' : 'Follow',
                    style: const TextStyle(color: _communityAccent),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postImages(List<String> images) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              communityImageUrl(images[index]),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.white10,
                child: const Center(
                  child: Icon(Icons.broken_image_outlined, color: Colors.white54),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool selected = false,
  }) =>
      InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? _communityAccent : Colors.white70),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(color: selected ? _communityAccent : Colors.white70)),
          ],
        ),
      );

  Widget _profileAvatar(Map<String, dynamic> author) {
    final path = author['profileImage']?.toString();
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white12,
      backgroundImage: path == null || path.isEmpty
          ? null
          : NetworkImage(communityImageUrl(path)),
      child: path == null || path.isEmpty
          ? const Icon(Icons.person, color: Colors.white70)
          : null,
    );
  }

  Future<void> _onMenuAction(BuildContext context, String action) async {
    if (action == 'report') {
      await showReportDialog(context, controller, 'post', postId);
    } else if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete post?'),
          content: const Text('This post will be removed from the community.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
          ],
        ),
      );
      if (confirmed == true) await controller.deletePost(postId);
    } else if (action == 'edit') {
      final editedText = await showEditPostDialog(context, post['text']?.toString() ?? '');
      if (editedText != null) {
        await controller.editPost(
          postId: postId,
          text: editedText,
          selectedTopicId: null,
        );
      }
    }
  }
}

class CommunityComposerScreen extends StatefulWidget {
  const CommunityComposerScreen({super.key});

  @override
  State<CommunityComposerScreen> createState() => _CommunityComposerScreenState();
}

class _CommunityComposerScreenState extends State<CommunityComposerScreen> {
  final CommunityController controller = Get.find<CommunityController>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _jobIdController = TextEditingController();
  final List<String> _images = [];
  String? _selectedTopicId;
  bool _submitting = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _textController.dispose();
    _jobIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_images.length >= 4) return;
    final selected = await _imagePicker.pickMultiImage();
    for (final image in selected) {
      if (_images.length >= 4) break;
      final mimeType = lookupMimeType(image.path)?.toLowerCase();
      if (!const ['image/jpeg', 'image/png', 'image/webp'].contains(mimeType)) {
        Get.snackbar('Unsupported image', 'Choose a JPEG, PNG, or WebP image.');
        continue;
      }
      final bytes = await File(image.path).readAsBytes();
      _images.add('data:$mimeType;base64,${base64Encode(bytes)}');
    }
    setState(() {});
  }

  Future<void> _submit() async {
    if (_textController.text.trim().isEmpty) {
      Get.snackbar('Add some text', 'Write something before creating your post.');
      return;
    }
    setState(() => _submitting = true);
    final created = await controller.createPost(
      text: _textController.text.trim(),
      images: List<String>.from(_images),
      selectedTopicId: _selectedTopicId,
      jobId: controller.accountType == 'contractor'
          ? _jobIdController.text.trim()
          : null,
    );
    if (created && mounted) Get.back();
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _communityBackground,
        appBar: AppBar(
          backgroundColor: _communityBackground,
          foregroundColor: Colors.white,
          title: const Text('Create a post'),
          actions: [
            TextButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Post', style: TextStyle(color: _communityAccent)),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _textController,
              autofocus: true,
              minLines: 4,
              maxLines: 8,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'What would you like to share?',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
            if (controller.accountType == 'contractor') ...[
              const SizedBox(height: 12),
              TextField(
                controller: _jobIdController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Open job ID (optional)',
                  helperText: 'Only use an open job owned by your account.',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            if (_images.isNotEmpty)
              Wrap(
                spacing: 8,
                children: List.generate(
                  _images.length,
                  (index) => Chip(
                    label: Text('Image ${index + 1}'),
                    onDeleted: () => setState(() => _images.removeAt(index)),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _images.length >= 4 ? null : _pickImages,
              icon: const Icon(Icons.image_outlined),
              label: Text('Add images (${_images.length}/4)'),
            ),
            const SizedBox(height: 18),
            const Text('Topic', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Obx(() => DropdownButtonFormField<String?>(
                  value: _selectedTopicId,
                  dropdownColor: const Color(0xFF17213D),
                  decoration: const InputDecoration(
                    hintText: 'No topic',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('No topic')),
                    ...controller.topics.map((topic) {
                      final id = topic['id']?.toString();
                      return DropdownMenuItem<String?>(
                        value: id,
                        child: Text((topic['name'] ?? topic['title'] ?? 'Topic').toString()),
                      );
                    }),
                  ],
                  onChanged: (value) => setState(() => _selectedTopicId = value),
                )),
          ],
        ),
      );
}

class CommunityThreadScreen extends StatefulWidget {
  const CommunityThreadScreen({super.key, required this.postId});

  final String postId;

  @override
  State<CommunityThreadScreen> createState() => _CommunityThreadScreenState();
}

class _CommunityThreadScreenState extends State<CommunityThreadScreen> {
  final CommunityController controller = Get.isRegistered<CommunityController>()
      ? Get.find<CommunityController>()
      : Get.put(CommunityController(), permanent: true);
  final TextEditingController _commentController = TextEditingController();
  String? _replyToId;
  String? _replyToName;
  bool _sendingComment = false;

  @override
  void initState() {
    super.initState();
    controller.openThread(widget.postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() => _sendingComment = true);
    final comment = await controller.createComment(
      postId: widget.postId,
      text: text,
      parentCommentId: _replyToId,
    );
    if (comment != null && mounted) {
      _commentController.clear();
      setState(() {
        _replyToId = null;
        _replyToName = null;
      });
    }
    if (mounted) setState(() => _sendingComment = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _communityBackground,
        appBar: AppBar(
          backgroundColor: _communityBackground,
          foregroundColor: Colors.white,
          title: const Text('Post'),
        ),
        body: Obx(() {
          final post = controller.openPost.value;
          if (post == null) {
            return const Center(
              child: CircularProgressIndicator(color: _communityAccent),
            );
          }
          final comments = _asMapList(post['comments']);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    CommunityPostCard(post: post, controller: controller),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Comments', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                    ...comments.map((comment) => _buildComment(comment)),
                    if (post['commentsCursor'] != null)
                      Center(
                        child: TextButton(
                          onPressed: controller.loadOlderComments,
                          child: const Text('Load older comments'),
                        ),
                      ),
                  ],
                ),
              ),
              if (controller.isComposerVisible.value) _commentComposer(),
            ],
          );
        }),
      );

  Widget _buildComment(Map<String, dynamic> comment) {
    final removed = comment['removed'] == true;
    final author = _asMap(comment['author']) ?? {};
    final replies = _asMapList(comment['replies']);
    final replyCount = _asMap(comment['counts'])?['replies'];
    final hasMoreReplies = replyCount is num && replyCount > replies.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111C36),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        removed
                            ? 'Comment removed'
                            : (author['fullName'] ?? author['name'] ?? 'Community member').toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (!removed)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz, color: Colors.white54, size: 20),
                        onSelected: (reason) => showReportDialog(context, controller, 'comment', comment['id'].toString(), initialReason: reason),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'spam', child: Text('Report spam')),
                          PopupMenuItem(value: 'harassment', child: Text('Report harassment')),
                          PopupMenuItem(value: 'unsafe', child: Text('Report unsafe content')),
                          PopupMenuItem(value: 'other', child: Text('Report for another reason')),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  removed ? 'Comment removed' : comment['text']?.toString() ?? '',
                  style: TextStyle(color: removed ? Colors.white54 : Colors.white, height: 1.35),
                ),
                if (!removed)
                  Row(
                    children: [
                      _reactionMenu(
                        targetType: 'comment',
                        target: comment,
                        controller: controller,
                        count: _reactionCount(comment),
                        selected: comment['myReaction'] != null,
                        compact: true,
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _replyToId = comment['id']?.toString();
                          _replyToName = (author['fullName'] ?? author['name'] ?? 'member').toString();
                        }),
                        child: const Text('Reply'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: Column(
                children: replies.map((reply) => _buildReply(reply)).toList(),
              ),
            ),
          if (hasMoreReplies)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => controller.loadReplies(comment),
                child: Text('Load ${replyCount - replies.length} more replies'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReply(Map<String, dynamic> reply) {
    final author = _asMap(reply['author']) ?? {};
    final text = reply['removed'] == true ? 'Comment removed' : (reply['text'] ?? '').toString();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${author['fullName'] ?? author['name'] ?? 'Community member'}: $text',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _commentComposer() => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          decoration: const BoxDecoration(
            color: Color(0xFF111C36),
            border: Border(top: BorderSide(color: Colors.white12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_replyToName != null)
                Row(
                  children: [
                    Expanded(
                      child: Text('Replying to $_replyToName', style: const TextStyle(color: _communityAccent)),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        _replyToId = null;
                        _replyToName = null;
                      }),
                      icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                    ),
                  ],
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendingComment ? null : _sendComment,
                    icon: _sendingComment
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send, color: _communityAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

Widget _reactionMenu({
  required String targetType,
  required Map<String, dynamic> target,
  required CommunityController controller,
  required int count,
  required bool selected,
  bool compact = false,
}) =>
    PopupMenuButton<String>(
      tooltip: 'React',
      onSelected: (type) => controller.toggleReaction(
        targetType: targetType,
        target: target,
        reactionType: type,
      ),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'like', child: Text('Like')),
        PopupMenuItem(value: 'useful', child: Text('Useful')),
        PopupMenuItem(value: 'support', child: Text('Support')),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: compact ? 8 : 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
              size: 18,
              color: selected ? _communityAccent : Colors.white70,
            ),
            const SizedBox(width: 5),
            Text(
              '$count',
              style: TextStyle(
                color: selected ? _communityAccent : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );

Future<void> showReportDialog(
  BuildContext context,
  CommunityController controller,
  String targetType,
  String targetId, {
  String? initialReason,
}) async {
  const reasons = ['spam', 'harassment', 'unsafe', 'other'];
  var reason = initialReason ?? reasons.first;
  final selected = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Report content'),
        content: DropdownButtonFormField<String>(
          value: reason,
          items: reasons
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => reason = value);
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, reason), child: const Text('Report')),
        ],
      ),
    ),
  );
  if (selected != null) {
    await controller.reportItem(
      targetType: targetType,
      targetId: targetId,
      reason: selected,
    );
  }
}

Future<String?> showEditPostDialog(BuildContext context, String text) async {
  final textController = TextEditingController(text: text);
  final edited = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit post'),
      content: TextField(
        controller: textController,
        minLines: 2,
        maxLines: 6,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, textController.text.trim()), child: const Text('Save')),
      ],
    ),
  );
  textController.dispose();
  if (edited == null || edited.isEmpty) return null;
  return edited;
}

String communityImageUrl(String path) {
  if (path.startsWith('http')) return path;
  final origin = Uri.parse(MyApIService().baseurl).origin;
  return '$origin/uploads/${path.startsWith('/') ? path.substring(1) : path}';
}

Map<String, dynamic>? _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

List<Map<String, dynamic>> _asMapList(dynamic value) => value is List
    ? value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList()
    : <Map<String, dynamic>>[];

String _topicName(Map<String, dynamic> post) {
  final topic = _asMap(post['topic']);
  return (topic?['name'] ?? post['topicName'] ?? 'topic').toString();
}

int _reactionCount(Map<String, dynamic> item) {
  final reactions = _asMap(item['counts'])?['reactions'];
  if (reactions is num) return reactions.toInt();
  if (reactions is Map) {
    return reactions.values.whereType<num>().fold(0, (sum, value) => sum + value.toInt());
  }
  return 0;
}

String _timeLabel(String? value) {
  final date = DateTime.tryParse(value ?? '');
  if (date == null) return '';
  final difference = DateTime.now().difference(date);
  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inHours < 1) return '${difference.inMinutes}m ago';
  if (difference.inDays < 1) return '${difference.inHours}h ago';
  return '${date.day}/${date.month}/${date.year}';
}
