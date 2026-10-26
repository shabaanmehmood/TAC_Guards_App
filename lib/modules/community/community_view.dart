import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/models/job_model.dart';
import 'package:tac/models/userdata_model.dart';
import 'package:tac/modules/Guards/job_details/job_details_screen.dart';
import 'package:tac/modules/Messages/socket_file.dart';
import 'package:tac/routes/app_routes.dart';

import 'community_service.dart';
import 'components/create_post_view.dart';
import 'components/post_card.dart';
import 'components/report_reason_sheet.dart';
import 'components/thread_view.dart';

export 'components/create_post_view.dart';
export 'components/post_card.dart';
export 'components/report_reason_sheet.dart';
export 'components/thread_view.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final ScrollController _scrollController = ScrollController();
  late final Data? _user;
  late final UserController _userController;
  CommunityService? _service;
  List<Map<String, dynamic>> _topics = [];
  List<Map<String, dynamic>> _posts = [];
  final Set<String> _followedAccounts = {};
  final Set<String> _reportedTargets = {};
  final Set<String> _locallyCreatedPostIds = {};
  final Set<String> _animatingOutPostIds = {};
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;
  String _filter = 'everyone';
  String? _topicId;
  String? _nextCursor;
  String? _error;
  int _feedGeneration = 0;
  bool _loading = true;
  bool _loadingMore = false;
  bool _inactive = false;
  bool _postingBlockedByServer = false;

  String get _accountType => _userController.accountType.value;

  bool get _canPost =>
      !_postingBlockedByServer &&
      _user?.isActive != false &&
      (_user?.isVerified == true || _accountType == 'admin');

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();
    _user = _userController.userData.value;
    final token = _userController.accessToken.value;
    final accountId = _userController.accountId.value;
    final accountType = _userController.accountType.value;
    if (_tokenIsUsable(token)) {
      _service = CommunityService(
        token: token!,
        accountId: accountId ?? '',
        accountType: accountType,
      );
    }
    SocketService().initialize();
    _socketSubscription =
        SocketService().communityStream.listen(_onCommunityEvent);
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  bool _tokenIsUsable(String? token) => token != null && token.isNotEmpty;

  @override
  void dispose() {
    _scrollController.dispose();
    _socketSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    if (_user?.isActive == false) {
      setState(() {
        _inactive = true;
        _loading = false;
      });
      return;
    }
    if (_service == null) {
      setState(() {
        _error = 'Your session has expired. Please sign in again.';
        _loading = false;
      });
      return;
    }
    try {
      _topics = await _service!.fetchTopics();
      await _loadFollowing();
      await _loadFeed(reset: true);
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load the community. Check your connection.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadFeed({bool reset = false, bool silent = false}) async {
    if (_service == null || (!reset && _loadingMore)) return;
    if (!reset && _nextCursor == null) return;
    final generation = ++_feedGeneration;
    final filter = _filter;
    final topicId = _topicId;
    final cursor = reset ? null : _nextCursor;
    if (!silent) {
      setState(() {
        if (reset) {
          _loading = true;
          _loadingMore = false;
          _error = null;
        } else {
          _loadingMore = true;
        }
      });
    }
    try {
      final page = await _service!.fetchFeed(
        filter: filter,
        topicId: topicId,
        cursor: cursor,
      );
      if (!mounted || generation != _feedGeneration) return;
      setState(() {
        if (reset)
          _posts = page.posts;
        else
          _posts.addAll(page.posts);
        _nextCursor = page.nextCursor;
        _loading = false;
        _loadingMore = false;
      });
    } on CommunityApiException catch (exception) {
      if (mounted && generation == _feedGeneration) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
      _handleApiError(exception);
    } catch (_) {
      if (mounted && generation == _feedGeneration) {
        setState(() {
          if (!silent) {
            _error = 'Could not load posts. Check your connection.';
          }
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 360 &&
        !_loading &&
        !_loadingMore &&
        _nextCursor != null) {
      _loadFeed();
    }
  }

  void _onCommunityEvent(Map<String, dynamic> event) {
    if (!mounted) return;
    final name = event['event'] as String?;
    final payload = _mapValue(event['payload']);
    if (name == null || payload == null) return;
    setState(() {
      if (name == 'community:post-created') {
        final id = payload['id'] as String?;
        if (id == null || _locallyCreatedPostIds.remove(id)) return;
        if (_posts.any((post) => post['id'] == id)) return;
        final topic = _mapValue(payload['topic']);
        final author = _mapValue(payload['author']);
        if (_topicId != null && topic?['id'] != _topicId) return;
        if (_filter == 'following') {
          final key = _accountKey(
            author?['type'] as String? ?? '',
            author?['id'] as String? ?? '',
          );
          if (!_followedAccounts.contains(key)) return;
        }
        _posts.insert(0, payload);
      } else if (name == 'community:reaction-updated' &&
          payload['targetType'] == 'post') {
        final id = payload['targetId'];
        final post = _posts.firstWhereOrNull((item) => item['id'] == id);
        final counts = _mapValue(payload['counts']);
        if (post != null && counts != null) {
          final postCounts = _mapValue(post['counts']) ?? <String, dynamic>{};
          postCounts['reactions'] = counts['reactions'];
          post['counts'] = postCounts;
        }
      } else if (name == 'community:comment-created') {
        final postId = payload['postId'] as String?;
        final post = _posts.firstWhereOrNull((item) => item['id'] == postId);
        if (post != null) {
          final postCounts =
              Map<String, dynamic>.from(_mapValue(post['counts']) ?? {});
          final current = (postCounts['comments'] as num?)?.toInt() ?? 0;
          postCounts['comments'] = current + 1;
          post['counts'] = postCounts;
        }
      } else if (name == 'community:comment-deleted') {
        final postId = payload['postId'] as String?;
        final post = _posts.firstWhereOrNull((item) => item['id'] == postId);
        if (post != null) {
          final postCounts =
              Map<String, dynamic>.from(_mapValue(post['counts']) ?? {});
          final current = (postCounts['comments'] as num?)?.toInt() ?? 0;
          if (current > 0) {
            postCounts['comments'] = current - 1;
            post['counts'] = postCounts;
          }
        }
      } else if (name == 'community:moderation' &&
          payload['targetType'] == 'post') {
        final status = payload['status'];
        if (status == 'hidden' || status == 'removed') {
          _posts.removeWhere((post) => post['id'] == payload['targetId']);
        }
      }
    });
  }

  void _handleApiError(CommunityApiException exception) {
    if (!mounted) return;
    if (exception.statusCode == 401) {
      Get.offAllNamed(AppRoutes.signIn);
      return;
    }
    setState(() {
      _loading = false;
      _loadingMore = false;
      if (exception.statusCode == 403 &&
          exception.message == 'Account is inactive') {
        _inactive = true;
      } else if (exception.statusCode == 403 &&
          exception.message == 'Only verified accounts can post') {
        _postingBlockedByServer = true;
      }
      _error = exception.message;
    });
  }

  Future<void> _changeFeed({
    String? filter,
    String? topicId,
    bool updateTopic = false,
  }) async {
    setState(() {
      if (filter != null) _filter = filter;
      if (updateTopic) _topicId = topicId;
      _nextCursor = null;
      _posts = [];
    });
    await _loadFeed(reset: true);
  }

  Future<void> _createPost() async {
    if (!_canPost || _service == null) return;
    final createdPost = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => CreatePostView(
          service: _service!,
          topics: _topics,
          onPostingDenied: () {
            if (mounted) setState(() => _postingBlockedByServer = true);
          },
          onInactive: () {
            if (mounted) setState(() => _inactive = true);
          },
        ),
      ),
    );
    if (createdPost != null && mounted) {
      final postId = createdPost['id'] as String?;
      if (postId != null) {
        _locallyCreatedPostIds.add(postId);
      }
      setState(() {
        _posts.removeWhere((post) => post['id'] == createdPost['id']);
        _posts.insert(0, createdPost);
      });
      _loadFeed(reset: true);
    }
  }

  void _showPostingEligibility() {
    Get.snackbar('Verification required', 'Only verified accounts can post.');
  }

  String _accountKey(String type, String id) => '$type:$id';

  bool _isAuthor(Map<String, dynamic>? author) =>
      author?['id'] == _userController.accountId.value &&
      author?['type'] == _userController.accountType.value;

  bool _canEdit(Map<String, dynamic> post) {
    final author = _mapValue(post['author']);
    final isOwn = _isAuthor(author) ||
        (post['id'] is String && _locallyCreatedPostIds.contains(post['id']));
    if (!isOwn) return false;

    final createdAtRaw = post['createdAt'] as String?;
    if (createdAtRaw == null || createdAtRaw.isEmpty) return true;
    final createdAt = DateTime.tryParse(createdAtRaw);
    if (createdAt == null) return true;

    final age = DateTime.now().toUtc().difference(createdAt.toUtc());
    // Allow up to 15 minutes after creation; tolerate clock skew (up to 5 minutes in future)
    return age <= const Duration(minutes: 15) && age >= const Duration(minutes: -5);
  }

  Future<void> _loadFollowing() async {
    if (_service == null) return;
    try {
      final followed = await _service!.fetchFollowing();
      if (!mounted) return;
      setState(() {
        _followedAccounts
          ..clear()
          ..addAll(followed.map((entry) {
            final author = _mapValue(entry['author']) ??
                _mapValue(entry['following']) ??
                _mapValue(entry['target']);
            final type = (author?['type'] ??
                    entry['followingType'] ??
                    entry['targetType'] ??
                    entry['type'] ??
                    '')
                .toString();
            final id = (author?['id'] ??
                    entry['followingId'] ??
                    entry['targetId'] ??
                    entry['id'] ??
                    '')
                .toString();
            if (type.isEmpty || id.isEmpty) return '';
            return _accountKey(type, id);
          }).where((key) => key.isNotEmpty && key != ':'));
      });
    } catch (_) {}
  }

  Future<void> _toggleFollow(Map<String, dynamic> author) async {
    final type = author['type'] as String?;
    final id = author['id'] as String?;
    if (_service == null || id == null || type == null) return;
    if (type != 'guard' && type != 'contractor') return;
    final key = _accountKey(type, id);
    final follow = !_followedAccounts.contains(key);

    // Instant optimistic update (0ms lag)
    setState(() {
      if (follow) {
        _followedAccounts.add(key);
      } else {
        _followedAccounts.remove(key);
      }
    });

    try {
      await _service!.follow(
        followingType: type,
        followingId: id,
        follow: follow,
      );
      if (!mounted) return;
      if (_filter == 'following' && _topicId == null) {
        final followingPage = await _service!.fetchFeed(filter: 'following');
        if (mounted && _filter == 'following' && _topicId == null) {
          setState(() {
            _posts = followingPage.posts;
            _nextCursor = followingPage.nextCursor;
          });
        }
      }
    } on CommunityApiException catch (exception) {
      // Revert state if network call fails
      if (mounted) {
        setState(() {
          if (follow) {
            _followedAccounts.remove(key);
          } else {
            _followedAccounts.add(key);
          }
        });
      }
      _handleApiError(exception);
    }
  }

  Future<void> _reactToPost(
      Map<String, dynamic> post, String reactionType) async {
    final id = post['id'] as String?;
    if (_service == null || id == null) return;
    try {
      final result = await _service!.react(
        targetType: 'post',
        targetId: id,
        type: reactionType,
      );
      if (!mounted) return;
      setState(() {
        final target = _posts.firstWhereOrNull((item) => item['id'] == id);
        if (target != null) _applyReaction(target, result);
      });
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    }
  }

  void _applyReaction(
      Map<String, dynamic> target, Map<String, dynamic> result) {
    target['myReaction'] = result['myReaction'];
    final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
    final responseCounts = _mapValue(result['counts']);
    if (responseCounts != null && responseCounts.containsKey('reactions')) {
      counts['reactions'] = responseCounts['reactions'];
    }
    target['counts'] = counts;
  }

  Future<void> _editPost(Map<String, dynamic> post) async {
    if (_service == null || !_canEdit(post)) return;
    final topic = _mapValue(post['topic']);
    final currentTopicId = topic?['id'] as String?;
    final currentText = post['text'] as String? ?? '';

    final updated = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _EditPostSheet(
        initialText: currentText,
        initialTopicId: currentTopicId,
        topics: _topics,
      ),
    );

    if (updated == null || (updated['text'] as String).isEmpty) return;
    if (!mounted) return;

    try {
      final response = await _service!.editPost(
        post['id'] as String,
        text: updated['text'] as String,
        topicId: updated['topicId'] as String?,
      );
      if (!mounted) return;
      setState(() {
        post['text'] = response['text'] ?? updated['text'];
        post['topic'] = response.containsKey('topic')
            ? response['topic']
            : _topics
                .cast<Map<String, dynamic>?>()
                .firstWhereOrNull((item) => item?['id'] == updated['topicId']);
        post['editedAt'] =
            response['editedAt'] ?? DateTime.now().toUtc().toIso8601String();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post updated successfully'),
          backgroundColor: AppColors.kJobCardColor,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } on CommunityApiException catch (exception) {
      if (!mounted) return;
      _handleApiError(exception);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update post: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deletePost(Map<String, dynamic> post) async {
    if (_service == null || !_isAuthor(_mapValue(post['author']))) return;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete post?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This post will be permanently removed from the feed.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white70)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Delete',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    try {
      await _service!.deletePost(post['id'] as String);
      if (mounted)
        setState(() => _posts.removeWhere((item) => item['id'] == post['id']));
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    }
  }

  Future<void> _reportTarget(String targetType, String targetId) async {
    if (_service == null) return;
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
      await _service!.report(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
      );
      if (!mounted) return;
      setState(() {
        _reportedTargets.add('$targetType:$targetId');
      });
      Get.snackbar(
        'Report submitted',
        'Thank you for reporting. Our moderation team will review this.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kDarkestBlue,
        colorText: Colors.white,
      );
      if (targetType == 'post') {
        // Allow user to briefly see "Reported" in amber before smooth exit
        await Future.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;
        setState(() => _animatingOutPostIds.add(targetId));
        await Future.delayed(const Duration(milliseconds: 320));
        if (!mounted) return;
        setState(() {
          _posts.removeWhere((post) => post['id'] == targetId);
          _animatingOutPostIds.remove(targetId);
        });
      }
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
        if (targetType == 'post') {
          await Future.delayed(const Duration(milliseconds: 700));
          if (!mounted) return;
          setState(() => _animatingOutPostIds.add(targetId));
          await Future.delayed(const Duration(milliseconds: 320));
          if (!mounted) return;
          setState(() {
            _posts.removeWhere((post) => post['id'] == targetId);
            _animatingOutPostIds.remove(targetId);
          });
        }
      } else {
        _handleApiError(exception);
      }
    }
  }

  Future<void> _openJob(Map<String, dynamic> job) async {
    final id = job['id'] as String?;
    if (id == null) return;
    Get.to<void>(() => JobDetailsScreen(
          jobData: JobData(
            id: id,
            title: job['title'] as String? ?? 'Job',
            description: '',
            responsibilities: '',
            location: job['location'] as String? ?? '',
            latitude: '',
            longitude: '',
            noOfGuardsRequired: 0,
            leaderRequired: 0,
            payPerHour: job['payPerHour']?.toString() ?? '',
            jobSOPs: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            contractorId: '',
            contractorName: '',
            categoryName: '',
            premisesTypeName: '',
            shifts: const [],
          ),
          bottomAction: const SizedBox.shrink(),
        ));
  }

  void _openThread(Map<String, dynamic> post) {
    final id = post['id'] as String?;
    if (id == null || _service == null) return;
    Get.bottomSheet<void>(
      CommunityThreadView(
        service: _service!,
        postId: id,
        canComment: _canPost,
        onVerifiedPostDenied: () {
          if (mounted) setState(() => _postingBlockedByServer = true);
        },
        onHiddenPost: () {
          if (mounted) {
            setState(() => _posts.removeWhere((item) => item['id'] == id));
          }
        },
        onCommentCountUpdated: (count) {
          if (mounted) {
            setState(() {
              final targetPost = _posts.firstWhereOrNull((p) => p['id'] == id);
              if (targetPost != null) {
                final postCounts =
                    Map<String, dynamic>.from(_mapValue(targetPost['counts']) ?? {});
                postCounts['comments'] = count;
                targetPost['counts'] = postCounts;
              }
            });
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final blocked = _inactive || _user == null || _service == null;
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: AppColors.kDarkBlue,
              foregroundColor: Colors.white,
              title: const Text('Community'),
              leading: IconButton(
                tooltip: 'Show map',
                icon: const Icon(Icons.map_outlined),
                onPressed: Get.back,
              ),
              actions: [
                IconButton(
                  tooltip: 'Refresh feed',
                  icon: const Icon(Icons.refresh),
                  onPressed: blocked ? null : () => _loadFeed(reset: true),
                ),
              ],
            )
          : null,
      body: blocked
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _inactive
                      ? 'Your account is inactive.'
                      : _error ?? 'Please sign in again to open the community.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            )
          : Column(
              children: [
                _feedControls(),
                Expanded(child: _feedBody()),
              ],
            ),
        floatingActionButton: !blocked
          ? FloatingActionButton(
              tooltip: _canPost ? 'Create post' : 'Posting requires verification',
              backgroundColor:
                  _postingBlockedByServer ? Colors.grey : AppColors.kSkyBlue,
              foregroundColor: AppColors.kBlack,
              onPressed: _postingBlockedByServer
                  ? null
                  : _canPost
                      ? _createPost
                      : _showPostingEligibility,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }

  Widget _feedControls() {
    final isEveryone = _filter == 'everyone';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Everyone / Following Switcher with Identical Shape (borderRadius: 8) & Smooth Sliding Animation
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            height: 42,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.kJobCardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.kSkyBlue.withValues(alpha: 0.5),
                width: 1.2,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final halfWidth = constraints.maxWidth / 2;
                return Stack(
                  children: [
                    // Smooth Sliding Indicator (Shape matches topics tab)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      left: isEveryone ? 0 : halfWidth,
                      top: 0,
                      bottom: 0,
                      width: halfWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.kSkyBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),

                    // Switcher Tap Targets
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _changeFeed(filter: 'everyone'),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  color: isEveryone ? AppColors.kBlack : AppColors.kWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                                child: const Text('Everyone'),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _changeFeed(filter: 'following'),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  color: !isEveryone ? AppColors.kBlack : AppColors.kWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                                child: const Text('Following'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Professional Spacing Between Switcher & Topics
        const SizedBox(height: 12),

        // Topics Tab (Preserved EXACTLY as Previous Shape: borderRadius: 8)
        if (_topics.isNotEmpty)
          SizedBox(
            height: 42,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _topicPill(null, 'All topics'),
                ..._topics.map((topic) => _topicPill(
                      topic['id'] as String?,
                      topic['name'] as String? ?? 'Topic',
                    )),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _topicPill(String? id, String label) {
    final selected = _topicId == id;
    return GestureDetector(
      onTap: () => _changeFeed(topicId: id, updateTopic: true),
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.kSkyBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.kSkyBlue.withValues(alpha: selected ? 1.0 : 0.65),
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.kBlack : AppColors.kWhite,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _feedBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null && _posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70)),
        ),
      );
    }
    if (_posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadFeed(reset: true),
        child: ListView(
          controller: _scrollController,
          children: const [
            SizedBox(height: 120),
            Center(
              child: Text('No posts yet',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _loadFeed(reset: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
        itemCount: _posts.length + (_loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _postCard(_posts[index]);
        },
      ),
    );
  }

  Widget _postCard(Map<String, dynamic> post) {
    final author = post['author'] is Map
        ? Map<String, dynamic>.from(post['author'] as Map)
        : const <String, dynamic>{};
    final canFollow = !_isAuthor(author) &&
        (author['type'] == 'guard' || author['type'] == 'contractor');
    final accountKey = _accountKey(
      author['type'] as String? ?? '',
      author['id'] as String? ?? '',
    );
    final ownPost = _isAuthor(author) ||
        (post['id'] is String && _locallyCreatedPostIds.contains(post['id']));
    final postId = post['id'] as String? ?? '';
    final isDisappearing = _animatingOutPostIds.contains(postId);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        opacity: isDisappearing ? 0.0 : 1.0,
        child: isDisappearing
            ? const SizedBox.shrink()
            : LinkedInPostCard(
                post: post,
                service: _service!,
                accountLabel: _accountLabel,
                dateLabel: _dateLabel,
                isFollowed: _followedAccounts.contains(accountKey),
                canFollow: canFollow,
                onFollowToggle: () => _toggleFollow(author),
                onOpenThread: () => _openThread(post),
                onReact: (reaction) => _reactToPost(post, reaction),
                onEdit: () => _editPost(post),
                onDelete: () => _deletePost(post),
                onReport: () => _reportTarget('post', post['id'] as String),
                onOpenJob: (job) => _openJob(job),
                canEdit: ownPost && _canEdit(post),
                ownPost: ownPost,
                isReported: _reportedTargets.contains('post:${post['id']}'),
              ),
      ),
    );
  }

  String _accountLabel(String? type) {
    if (type == null || type.isEmpty) return 'Member';
    return '${type[0].toUpperCase()}${type.substring(1)}';
  }

  String _dateLabel(String? value) {
    final date = DateTime.tryParse(value ?? '')?.toLocal();
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
    return '${date.day}/${date.month}/${date.year}';
  }
}

Map<String, dynamic>? _mapValue(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

class _EditPostSheet extends StatefulWidget {
  final String initialText;
  final String? initialTopicId;
  final List<Map<String, dynamic>> topics;

  const _EditPostSheet({
    required this.initialText,
    required this.initialTopicId,
    required this.topics,
  });

  @override
  State<_EditPostSheet> createState() => _EditPostSheetState();
}

class _EditPostSheetState extends State<_EditPostSheet> {
  late final TextEditingController _textController;
  late String? _selectedTopicId;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _selectedTopicId = widget.initialTopicId;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.kDarkBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Topic Selector
            if (widget.topics.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('No Topic'),
                      selected: _selectedTopicId == null,
                      selectedColor: AppColors.kSkyBlue,
                      backgroundColor: AppColors.kJobCardColor,
                      labelStyle: TextStyle(
                        color: _selectedTopicId == null
                            ? Colors.black
                            : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedTopicId = null),
                    ),
                    ...widget.topics.map((t) {
                      final tid = t['id'] as String?;
                      final isSel = _selectedTopicId == tid;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(t['name'] as String? ?? 'Topic'),
                          selected: isSel,
                          selectedColor: AppColors.kSkyBlue,
                          backgroundColor: AppColors.kJobCardColor,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.black : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) =>
                              setState(() => _selectedTopicId = tid),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Text Field
            Container(
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: TextField(
                controller: _textController,
                maxLength: 2000,
                maxLines: 5,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                cursorColor: AppColors.kSkyBlue,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "What's on your mind?",
                  hintStyle:
                      TextStyle(color: Colors.white38, fontSize: 14),
                  counterStyle:
                      TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final text = _textController.text.trim();
                  if (text.isEmpty) return;
                  Navigator.of(context).pop({
                    'text': text,
                    'topicId': _selectedTopicId,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


