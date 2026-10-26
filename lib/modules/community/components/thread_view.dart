import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/Messages/socket_file.dart';
import 'package:tac/routes/app_routes.dart';
import '../community_service.dart';
import 'report_reason_sheet.dart';

Map<String, dynamic>? _mapValue(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

class CommunityThreadView extends StatefulWidget {
  const CommunityThreadView({
    super.key,
    required this.service,
    required this.postId,
    this.commentId,
    required this.canComment,
    required this.onVerifiedPostDenied,
    required this.onHiddenPost,
    this.onCommentCountUpdated,
  });

  final CommunityService service;
  final String postId;
  final String? commentId;
  final bool canComment;
  final VoidCallback onVerifiedPostDenied;
  final VoidCallback onHiddenPost;
  final void Function(int count)? onCommentCountUpdated;

  @override
  State<CommunityThreadView> createState() => _CommunityThreadViewState();
}

class _CommunityThreadViewState extends State<CommunityThreadView> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _commentFocusNode = FocusNode();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final Map<String, String?> _replyCursors = {};
  final Map<String, GlobalKey> _commentKeys = {};
  final Set<String> _reportedTargets = {};
  final Set<String> _locallyCreatedCommentIds = {};
  final Set<String> _expandedCommentIds = {};
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;
  Map<String, dynamic>? _post;
  List<Map<String, dynamic>> _comments = [];
  String? _commentsCursor;
  Map<String, dynamic>? _replyTarget;
  String? _error;
  bool _loading = true;
  bool _loadingOlder = false;
  bool _sending = false;
  bool _composerBlocked = false;
  bool _inactive = false;
  bool _isClosing = false;

  void _closeSheet() {
    if (_isClosing) return;
    _isClosing = true;
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      if (mounted) setState(() {});
    });
    SocketService().initialize();
    _socketSubscription =
        SocketService().communityStream.listen(_onCommunityEvent);
    _loadThread();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    _sheetController.dispose();
    _socketSubscription?.cancel();
    super.dispose();
  }

  void _onCommunityEvent(Map<String, dynamic> event) {
    if (!mounted) return;
    final name = event['event'] as String?;
    final payload = _mapValue(event['payload']);
    if (name == null || payload == null) return;

    if (name == 'community:moderation' &&
        payload['targetType'] == 'post' &&
        payload['targetId'] == widget.postId) {
      if (payload['status'] == 'visible') {
        _loadThread();
      } else if (payload['status'] == 'hidden' ||
          payload['status'] == 'removed') {
        widget.onHiddenPost();
        _closeSheet();
      }
      return;
    }

    setState(() {
      if (name == 'community:comment-created' &&
          payload['postId'] == widget.postId) {
        final id = payload['id'] as String?;
        if (id == null || _locallyCreatedCommentIds.remove(id)) return;
        if (_comments.any((comment) => comment['id'] == id)) return;
        final parentId = payload['parentCommentId'] as String?;
        if (parentId == null) {
          _comments.add(payload);
          _incrementCount(_post, 'comments');
        } else {
          final parent = _comments
              .firstWhereOrNull((comment) => comment['id'] == parentId);
          if (parent == null) return;
          final replies = _mapList(parent['replies']);
          if (!replies.any((reply) => reply['id'] == id)) replies.add(payload);
          parent['replies'] = replies;
          _incrementCount(parent, 'replies');
        }
        _notifyCommentCount();
      } else if (name == 'community:reaction-updated') {
        final targetType = payload['targetType'];
        final targetId = payload['targetId'];
        final counts = _mapValue(payload['counts']);
        if (counts == null) return;
        if (targetType == 'post' && _post?['id'] == targetId) {
          _setReactionCount(_post!, counts['reactions']);
        } else if (targetType == 'comment') {
          final comment = _findComment(targetId);
          if (comment != null) {
            _setReactionCount(comment, counts['reactions']);
          }
        }
      } else if (name == 'community:moderation' &&
          payload['targetType'] == 'comment' &&
          (payload['status'] == 'hidden' || payload['status'] == 'removed')) {
        _comments
            .removeWhere((comment) => comment['id'] == payload['targetId']);
        for (final comment in _comments) {
          final replies = _mapList(comment['replies']);
          replies.removeWhere((reply) => reply['id'] == payload['targetId']);
          comment['replies'] = replies;
        }
      }
    });
  }

  Map<String, dynamic>? _findComment(dynamic id) {
    for (final comment in _comments) {
      if (comment['id'] == id) return comment;
      for (final reply in _mapList(comment['replies'])) {
        if (reply['id'] == id) return reply;
      }
    }
    return null;
  }

  void _setReactionCount(Map<String, dynamic> target, dynamic count) {
    final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
    counts['reactions'] = count;
    target['counts'] = counts;
  }

  void _incrementCount(Map<String, dynamic>? target, String field) {
    if (target == null) return;
    final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
    counts[field] = ((counts[field] as num?)?.toInt() ?? 0) + 1;
    target['counts'] = counts;
  }

  int get _totalCommentsCount {
    final counts = _mapValue(_post?['counts']);
    final serverCount = (counts?['comments'] as num?)?.toInt();
    if (serverCount != null && serverCount >= _comments.length) {
      return serverCount;
    }
    return _comments.length;
  }

  void _notifyCommentCount() {
    final count = _totalCommentsCount;
    widget.onCommentCountUpdated?.call(count);
  }

  bool _isAuthor(Map<String, dynamic>? author) =>
      author?['id'] == widget.service.accountId &&
      author?['type'] == widget.service.accountType;

  bool _canEdit(Map<String, dynamic> comment) {
    final createdAt = DateTime.tryParse(comment['createdAt'] as String? ?? '');
    if (createdAt == null || !_isAuthor(_mapValue(comment['author']))) {
      return false;
    }
    final age = DateTime.now().toUtc().difference(createdAt.toUtc());
    return age <= const Duration(minutes: 15) &&
        age >= const Duration(minutes: -5);
  }

  Future<void> _loadThread() async {
    try {
      final post = await widget.service.fetchPost(widget.postId);
      if (!mounted) return;
      setState(() {
        _post = post;
        _comments = _mapList(post['comments']);
        _commentsCursor = post['commentsCursor'] as String?;
        _loading = false;
      });
      _notifyCommentCount();
      if (widget.commentId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final commentContext = _commentKeys[widget.commentId]?.currentContext;
          if (commentContext != null) {
            Scrollable.ensureVisible(commentContext, alignment: 0.2);
          }
        });
      }
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load this discussion.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadOlderComments() async {
    if (_commentsCursor == null || _loadingOlder) return;
    setState(() => _loadingOlder = true);
    try {
      final page = await widget.service.fetchComments(
        widget.postId,
        cursor: _commentsCursor,
      );
      if (!mounted) return;
      setState(() {
        _appendUnique(_comments, page.posts);
        _commentsCursor = page.nextCursor;
        _loadingOlder = false;
      });
    } on CommunityApiException catch (exception) {
      if (mounted) setState(() => _loadingOlder = false);
      _handleError(exception);
    }
  }

  Future<void> _loadReplies(Map<String, dynamic> comment) async {
    final commentId = comment['id'] as String?;
    if (commentId == null) return;
    try {
      final page = await widget.service.fetchReplies(
        commentId,
        cursor: _replyCursors[commentId],
      );
      if (!mounted) return;
      final replies = _mapList(comment['replies']);
      _appendUnique(replies, page.posts);
      setState(() {
        comment['replies'] = replies;
        _replyCursors[commentId] = page.nextCursor;
      });
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    }
  }

  void _appendUnique(
    List<Map<String, dynamic>> target,
    List<Map<String, dynamic>> incoming,
  ) {
    final existingIds = target.map((item) => item['id']).toSet();
    target.addAll(incoming.where((item) => !existingIds.contains(item['id'])));
  }

  List<Map<String, dynamic>> _mapList(dynamic value) => value is List
      ? value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
      : <Map<String, dynamic>>[];

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || text.length > 1000 || _sending) return;
    final parentId =
        (_replyTarget?['parentCommentId'] ?? _replyTarget?['id']) as String?;
    setState(() => _sending = true);
    try {
      final comment = await widget.service.createComment(
        widget.postId,
        text: text,
        parentCommentId: parentId,
      );
      if (!mounted) return;
      setState(() {
        if (comment['id'] is String) {
          _locallyCreatedCommentIds.add(comment['id'] as String);
        }
        if (parentId == null) {
          final previousLength = _comments.length;
          _appendUnique(_comments, [comment]);
          if (_comments.length > previousLength) {
            _incrementCount(_post, 'comments');
          }
        } else {
          final parent =
              _comments.firstWhereOrNull((item) => item['id'] == parentId);
          if (parent != null) {
            final replies = _mapList(parent['replies']);
            final previousLength = replies.length;
            _appendUnique(replies, [comment]);
            parent['replies'] = replies;
            if (replies.length > previousLength) {
              _incrementCount(parent, 'replies');
            }
            _expandedCommentIds.add(parentId);
          }
        }
        _commentController.clear();
        _replyTarget = null;
        _sending = false;
      });
      _notifyCommentCount();
    } on CommunityApiException catch (exception) {
      if (mounted) setState(() => _sending = false);
      if (exception.statusCode == 403 &&
          exception.message == 'Only verified accounts can post') {
        widget.onVerifiedPostDenied();
        setState(() => _composerBlocked = true);
      }
      _handleError(exception);
    }
  }

  void _handleError(CommunityApiException exception) {
    if (exception.statusCode == 401) {
      Get.offAllNamed(AppRoutes.signIn);
      return;
    }
    if (exception.statusCode == 404) {
      _closeSheet();
      return;
    }
    if (!mounted) return;
    setState(() {
      _error = exception.message;
      if (exception.statusCode == 403 &&
          exception.message == 'Account is inactive') {
        _inactive = true;
      }
    });
    Get.snackbar('Community', exception.message);
  }

  Future<void> _react(
    Map<String, dynamic> target, {
    required String targetType,
    required String reaction,
  }) async {
    final id = target['id'] as String?;
    if (id == null) return;
    try {
      final result = await widget.service.react(
        targetType: targetType,
        targetId: id,
        type: reaction,
      );
      if (!mounted) return;
      setState(() {
        target['myReaction'] = result['myReaction'];
        final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
        final resultCounts = _mapValue(result['counts']);
        if (resultCounts != null) {
          counts['reactions'] = resultCounts['reactions'];
        }
        target['counts'] = counts;
      });
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    }
  }

  Future<void> _report(
    Map<String, dynamic> target, {
    required String targetType,
  }) async {
    final targetId = target['id'] as String?;
    if (targetId == null) return;
    if (_reportedTargets.contains('$targetType:$targetId')) {
      Get.snackbar(
        'Already reported',
        'You have already reported this $targetType.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kDarkestBlue,
        colorText: Colors.white,
      );
      return;
    }
    final reason = await showReportReasonSheet(
      context: context,
      title: targetType == 'post' ? 'Report post' : 'Report comment',
    );
    if (reason == null) return;
    try {
      final result = await widget.service.report(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
      );
      if (!mounted) return;
      setState(() {
        _reportedTargets.add('$targetType:$targetId');
        if (result['hidden'] == true) {
          if (targetType == 'post') {
            widget.onHiddenPost();
            _closeSheet();
          } else {
            _comments.removeWhere((item) => item['id'] == targetId);
          }
        }
      });
      Get.snackbar(
        'Report submitted',
        'Thank you for reporting. Our moderation team will review this.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kDarkestBlue,
        colorText: Colors.white,
      );
    } on CommunityApiException catch (exception) {
      if (exception.statusCode == 409) {
        setState(() => _reportedTargets.add('$targetType:$targetId'));
        Get.snackbar(
          'Already reported',
          exception.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.kDarkestBlue,
          colorText: Colors.white,
        );
      } else {
        _handleError(exception);
      }
    }
  }

  Future<void> _editComment(Map<String, dynamic> comment) async {
    final initial = comment['text'] as String? ?? '';
    final updatedText = await showDialog<String>(
      context: context,
      builder: (dialogCtx) => _EditCommentDialog(initialText: initial),
    );
    if (updatedText == null || updatedText.isEmpty) return;
    if (!mounted) return;
    try {
      final response = await widget.service.editComment(
        comment['id'] as String,
        text: updatedText,
      );
      if (!mounted) return;
      setState(() {
        comment['text'] = response['text'] ?? updatedText;
        comment['editedAt'] =
            response['editedAt'] ?? DateTime.now().toUtc().toIso8601String();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment updated successfully'),
          backgroundColor: AppColors.kJobCardColor,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } on CommunityApiException catch (exception) {
      if (!mounted) return;
      _handleError(exception);
    }
  }

  Future<void> _deleteComment(Map<String, dynamic> comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.kJobCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete comment?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to delete this comment?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.service.deleteComment(comment['id'] as String);
      if (mounted) {
        setState(() {
          comment['removed'] = true;
          comment['text'] = 'Comment removed';
        });
      }
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    }
  }

  String _timeAgo(String? timestamp) {
    final date = DateTime.tryParse(timestamp ?? '')?.toLocal();
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final hasComments = _comments.isNotEmpty;
    final isComposerEnabled =
        widget.canComment && !_composerBlocked && !_inactive;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (_isClosing) return false;
        final currentExtent = notification.extent;

        // Dismiss if dragged down below 0.50
        if (currentExtent < 0.50) {
          _closeSheet();
          return true;
        }

        return false;
      },
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.70,
        minChildSize: 0.30,
        maxChildSize: 0.75,
        snap: true,
        snapSizes: const [0.70],
        builder: (context, sheetScrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.kDarkBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Scaffold(
                backgroundColor: AppColors.kDarkBlue,
                resizeToAvoidBottomInset: false,
                body: Column(
                  children: [
                    // Drag Handle & Top Header Row wrapped in GestureDetector to dismiss on downward drag from any level
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: (details) {
                        if ((details.primaryDelta ?? 0) > 6) {
                          _closeSheet();
                        }
                      },
                      onVerticalDragEnd: (details) {
                        if ((details.primaryVelocity ?? 0) > 60) {
                          _closeSheet();
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Container(
                              width: 44,
                              height: 4.5,
                              margin: const EdgeInsets.only(top: 10, bottom: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  'Comments ($_totalCommentsCount)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _closeSheet,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        color: Colors.white70, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white10, height: 1),
                        ],
                      ),
                    ),

                    // Content Area
                    Expanded(
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.kSkyBlue))
                          : _inactive
                              ? const Center(
                                  child: Text(
                                    'Your account is inactive.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                )
                              : ListView(
                                  controller: sheetScrollController,
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                  children: [
                                    if (_commentsCursor != null)
                                      Center(
                                        child: TextButton(
                                          onPressed: _loadingOlder
                                              ? null
                                              : _loadOlderComments,
                                          child: Text(
                                            _loadingOlder
                                                ? 'Loading...'
                                                : 'Load older comments',
                                            style: const TextStyle(
                                                color: AppColors.kSkyBlue,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),

                                    if (!hasComments)
                                      _buildEmptyIllustration(),

                                    if (hasComments)
                                      ..._comments.map(
                                          (comment) => _commentCard(comment)),

                                    if (_error != null)
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(_error!,
                                            style: const TextStyle(
                                                color: Colors.redAccent)),
                                      ),
                                  ],
                                ),
                    ),

                    // Bottom Comment Input Composer
                    if (isComposerEnabled) _commentComposer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyIllustration() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white38,
              size: 56,
            ),
            SizedBox(height: 10),
            Text(
              'No comments yet',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreadActionRow({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 6),
        child: Row(
          children: [
            // Smooth curved connector line (L shape) matching LinkedIn screenshots
            SizedBox(
              width: 34,
              height: 22,
              child: Stack(
                children: [
                  Positioned(
                    left: 17,
                    top: 0,
                    width: 14,
                    height: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCommentActionsSheet(Map<String, dynamic> comment) async {
    final author = _mapValue(comment['author']) ?? const <String, dynamic>{};
    final owner = _isAuthor(author);
    final id = comment['id'] as String? ?? '';
    final removed = comment['removed'] == true;
    final canEdit = owner && _canEdit(comment) && !removed;
    final isReported = _reportedTargets.contains('comment:$id');

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: const BoxDecoration(
            color: AppColors.kJobCardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (canEdit)
                ListTile(
                  leading: const Icon(Icons.edit_outlined,
                      color: Colors.white, size: 22),
                  title: const Text(
                    'Edit comment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'edit'),
                ),
              if (owner && !removed)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded,
                      color: Colors.redAccent, size: 22),
                  title: const Text(
                    'Delete comment',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'delete'),
                ),
              if (!owner && !isReported)
                ListTile(
                  leading: const Icon(Icons.flag_outlined,
                      color: Colors.white70, size: 22),
                  title: const Text(
                    'Report comment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'report'),
                )
              else if (!owner && isReported)
                ListTile(
                  leading: const Icon(Icons.flag_rounded,
                      color: Colors.amber, size: 22),
                  title: const Text(
                    'Reported',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'You have already reported this comment',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext),
                ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );

    if (action == 'edit') {
      _editComment(comment);
    } else if (action == 'delete') {
      _deleteComment(comment);
    } else if (action == 'report') {
      _report(comment, targetType: 'comment');
    }
  }

  Widget _commentCard(Map<String, dynamic> comment,
      {bool isReply = false, String? parentAuthorName}) {
    final author = _mapValue(comment['author']) ?? const <String, dynamic>{};
    final replies = _mapList(comment['replies']);
    final counts = _mapValue(comment['counts']) ?? const <String, dynamic>{};
    final removed = comment['removed'] == true;
    final id = comment['id'] as String? ?? '';
    final isLiked = comment['myReaction'] != null;
    final reactionCount = counts['reactions'] as num? ?? 0;
    final repliesCount = (counts['replies'] as num? ?? 0).toInt();
    final effectiveRepliesCount =
        repliesCount > replies.length ? repliesCount : replies.length;
    final profileImagePath = author['profileImage'] as String?;
    final avatarUrl = profileImagePath != null && profileImagePath.isNotEmpty
        ? widget.service.imageUrl(profileImagePath)
        : null;
    final authorRole = author['type'] != null &&
            (author['type'] as String).isNotEmpty
        ? '${author['type'][0].toUpperCase()}${author['type'].substring(1)}'
        : 'Member';
    final timeStr = _timeAgo(comment['createdAt'] as String?);
    final isExpanded = _expandedCommentIds.contains(id);

    // For root comments, determine which replies to display
    final List<Map<String, dynamic>> visibleReplies = !isReply
        ? (isExpanded
            ? replies
            : (replies.isNotEmpty
                ? [replies.first]
                : const <Map<String, dynamic>>[]))
        : const <Map<String, dynamic>>[];

    return Padding(
      key: id.isEmpty ? null : _commentKeys.putIfAbsent(id, GlobalKey.new),
      padding: EdgeInsets.only(bottom: isReply ? 8 : 14),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: isReply ? 15 : 18,
                  backgroundColor: AppColors.kJobCardColor,
                  backgroundImage:
                      avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Icon(Icons.person,
                          color: Colors.white70, size: isReply ? 16 : 20)
                      : null,
                ),
                const SizedBox(width: 10),

                // Comment Content Column (Clean & Flat, No Box)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top line: Name + Time on Left, 3-dots on Far Right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    author['name'] as String? ?? 'Community member',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '· $timeStr',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _showCommentActionsSheet(comment),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8, top: 2, bottom: 2),
                              child: Icon(Icons.more_vert_rounded,
                                  color: Colors.white54, size: 18),
                            ),
                          ),
                        ],
                      ),

                    // Role / Headline Subtitle + Professional Badge
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            authorRole,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (author['professionalBadge'] != null &&
                            (author['professionalBadge'] as String).isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.kSkyBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColors.kSkyBlue.withValues(alpha: 0.4),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              author['professionalBadge'] as String,
                              style: const TextStyle(
                                color: AppColors.kSkyBlue,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Comment Body Text (with mention if reply - text only, NO container)
                    if (isReply && parentAuthorName != null && !removed)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$parentAuthorName ',
                              style: const TextStyle(
                                color: AppColors.kSkyBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            TextSpan(
                              text: comment['text'] as String? ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.35,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        removed
                            ? 'Comment removed'
                            : (comment['text'] as String? ?? ''),
                        style: TextStyle(
                          color: removed ? Colors.white54 : Colors.white,
                          fontStyle:
                              removed ? FontStyle.italic : FontStyle.normal,
                          height: 1.35,
                          fontSize: 13.5,
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Like & Reply Action Row
                    Row(
                      children: [
                        // Like Icon & Count
                        GestureDetector(
                          onTap: () => _react(
                            comment,
                            targetType: 'comment',
                            reaction:
                                comment['myReaction'] as String? ?? 'like',
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isLiked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                  size: 14,
                                  color: isLiked
                                      ? AppColors.kSkyBlue
                                      : Colors.white60,
                                ),
                                if (reactionCount > 0) ...[
                                  const SizedBox(width: 5),
                                  Text(
                                    '$reactionCount',
                                    style: TextStyle(
                                      color: isLiked
                                          ? AppColors.kSkyBlue
                                          : Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Reply Button (Available for both root comments & replies)
                        GestureDetector(
                          onTap: () {
                            setState(() => _replyTarget = comment);
                            _commentFocusNode.requestFocus();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Row(
                              children: [
                                Icon(Icons.chat_bubble_outline_rounded,
                                    size: 13.5, color: Colors.white60),
                                SizedBox(width: 5),
                                Text(
                                  'Reply',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Nested Replies with Vertical Connector Guide Line
          if (visibleReplies.isNotEmpty) ...[
            const SizedBox(height: 6),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vertical guide line matching LinkedIn screenshot
                  Container(
                    width: 1.5,
                    margin: const EdgeInsets.only(
                        left: 17, right: 14, top: 2, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...visibleReplies.map((reply) => _commentCard(
                              reply,
                              isReply: true,
                              parentAuthorName: author['name'] as String?,
                            )),
                        if (isExpanded &&
                            replies.length < effectiveRepliesCount)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 6),
                            child: GestureDetector(
                              onTap: () => _loadReplies(comment),
                              child: Text(
                                'Load more replies (${effectiveRepliesCount - replies.length})',
                                style: const TextStyle(
                                  color: AppColors.kSkyBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Professional LinkedIn-style "See more replies" / "Collapse replies" Connector
          if (!isReply && effectiveRepliesCount > 0) ...[
            if (effectiveRepliesCount == 1) ...[
              // Exactly 1 reply: if not loaded yet, allow loading it. If already loaded & visible, show NOTHING!
              if (replies.isEmpty)
                _buildThreadActionRow(
                  label: 'See 1 reply',
                  onTap: () async {
                    setState(() => _expandedCommentIds.add(id));
                    await _loadReplies(comment);
                  },
                ),
            ] else ...[
              // More than 1 reply:
              if (isExpanded)
                _buildThreadActionRow(
                  label: 'Collapse replies',
                  onTap: () => setState(() => _expandedCommentIds.remove(id)),
                )
              else
                _buildThreadActionRow(
                  label: visibleReplies.isNotEmpty
                      ? 'See ${effectiveRepliesCount - visibleReplies.length} more ${effectiveRepliesCount - visibleReplies.length == 1 ? 'reply' : 'replies'}'
                      : 'See $effectiveRepliesCount replies',
                  onTap: () async {
                    setState(() => _expandedCommentIds.add(id));
                    if (replies.length < effectiveRepliesCount) {
                      await _loadReplies(comment);
                    }
                  },
                ),
            ],
          ],
        ],
      ),
    ),
  );
}

  Widget _commentComposer() {
    final hasText = _commentController.text.trim().isNotEmpty;
    final isReplying = _replyTarget != null;
    final targetAuthor =
        isReplying ? _mapValue(_replyTarget!['author']) : null;
    final targetName = targetAuthor?['name'] as String? ?? 'comment';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kDarkBlue,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: MediaQuery.of(context).viewInsets.bottom == 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clean text indicator when replying (NO heavy container)
              if (isReplying)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        'Replying to ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12.5,
                        ),
                      ),
                      Text(
                        targetName,
                        style: const TextStyle(
                          color: AppColors.kSkyBlue,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _replyTarget = null),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(Icons.close,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.7)),
                        ),
                      ),
                    ],
                  ),
                ),

              // Single Row Text Input: [TextField] [Send Button]
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        maxLength: 1000,
                        minLines: 1,
                        maxLines: 4,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          height: 1.35,
                        ),
                        decoration: InputDecoration(
                          hintText: isReplying
                              ? 'Write a reply...'
                              : 'Write a comment...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 14,
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: (!hasText || _sending) ? null : _sendComment,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: hasText
                            ? AppColors.kSkyBlue
                            : Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: _sending
                          ? const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.kBlack,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              size: 19,
                              color:
                                  hasText ? AppColors.kBlack : Colors.white38,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditCommentDialog extends StatefulWidget {
  final String initialText;
  const _EditCommentDialog({required this.initialText});

  @override
  State<_EditCommentDialog> createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<_EditCommentDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.kJobCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Edit comment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _controller,
        maxLength: 1000,
        maxLines: 4,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
          labelText: 'Comment',
          labelStyle: TextStyle(color: Colors.white70),
          counterStyle: TextStyle(color: Colors.white38),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.kSkyBlue),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kSkyBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            Navigator.of(context).pop(text);
          },
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
