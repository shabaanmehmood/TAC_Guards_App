import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/modules/Messages/socket_file.dart';

class CommunityController extends GetxController {
  final MyApIService _api = MyApIService();
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> topics = <Map<String, dynamic>>[].obs;
  final Rxn<Map<String, dynamic>> openPost = Rxn<Map<String, dynamic>>();
  final RxString filter = 'everyone'.obs;
  final RxnString topicId = RxnString();
  final RxnString feedError = RxnString();
  final RxnString openPostId = RxnString();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isComposerVisible = true.obs;

  String? _nextCursor;
  int _feedGeneration = 0;
  bool _topicsLoaded = false;
  bool _socketListening = false;

  UserController get _user => Get.find<UserController>();
  String? get accountId => _user.accountId.value;
  String get accountType => _user.accountType.value;

  @override
  void onInit() {
    super.onInit();
    _listenForCommunitySocketEvents();
  }

  Future<void> loadInitial() async {
    await loadTopics();
    await loadFeed(reset: true);
  }

  Future<void> loadTopics() async {
    if (_topicsLoaded) return;
    try {
      final response = await _api.getCommunityTopics();
      final decoded = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }

      final data = decoded['data'];
      final rawTopics = data is List
          ? data
          : data is Map
              ? (data['topics'] ?? data['items'] ?? const [])
              : const [];
      topics.assignAll(
        (rawTopics as List)
            .whereType<Map>()
            .map((topic) => Map<String, dynamic>.from(topic)),
      );
      _topicsLoaded = true;
    } catch (error) {
      feedError.value = error.toString();
    }
  }

  Future<void> loadFeed({bool reset = false}) async {
    final requestGeneration = reset ? ++_feedGeneration : _feedGeneration;
    if (reset) {
      _nextCursor = null;
      posts.clear();
      isLoading.value = true;
      isLoadingMore.value = false;
    } else {
      if (_nextCursor == null || isLoadingMore.value || isLoading.value) return;
      isLoadingMore.value = true;
    }
    feedError.value = null;

    try {
      final response = await _api.getCommunityFeed(
        filter: filter.value,
        topicId: topicId.value,
        cursor: reset ? null : _nextCursor,
      );
      if (requestGeneration != _feedGeneration) return;
      final decoded = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }

      final data = decoded['data'];
      final rawPosts = data is List
          ? data
          : data is Map
              ? (data['posts'] ?? data['items'] ?? const [])
              : const [];
      final received = (rawPosts as List)
          .whereType<Map>()
          .map((post) => Map<String, dynamic>.from(post))
          .toList();
      final meta = decoded['meta'] is Map
          ? Map<String, dynamic>.from(decoded['meta'] as Map)
          : data is Map && data['meta'] is Map
              ? Map<String, dynamic>.from(data['meta'] as Map)
              : <String, dynamic>{};
      _nextCursor = meta['nextCursor']?.toString();
      if (reset) {
        posts.assignAll(received);
      } else {
        final knownIds = posts.map((post) => post['id']).toSet();
        posts.addAll(received.where((post) => !knownIds.contains(post['id'])));
      }
    } catch (error) {
      if (requestGeneration == _feedGeneration) {
        feedError.value = error.toString();
      }
    } finally {
      if (requestGeneration == _feedGeneration) {
        isLoading.value = false;
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> showEveryone() async {
    filter.value = 'everyone';
    topicId.value = null;
    await loadFeed(reset: true);
  }

  Future<void> showFollowing() async {
    filter.value = 'following';
    topicId.value = null;
    await loadFeed(reset: true);
  }

  Future<void> showTopic(String selectedTopicId) async {
    filter.value = 'everyone';
    topicId.value = selectedTopicId;
    await loadFeed(reset: true);
  }

  Future<bool> createPost({
    required String text,
    required List<String> images,
    String? selectedTopicId,
    String? jobId,
  }) async {
    final body = <String, dynamic>{
      'text': text,
      'images': images,
      if (selectedTopicId != null) 'topicId': selectedTopicId,
      if (jobId != null && jobId.isNotEmpty) 'jobId': jobId,
    };
    try {
      final response = await _api.createCommunityPost(body);
      final decoded = _decodeResponse(response.body);
      if (response.statusCode == 403 &&
          _errorMessage(decoded, response.statusCode)
              .contains('Only verified accounts can post')) {
        isComposerVisible.value = false;
        return false;
      }
      if (response.statusCode != 201) {
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      final data = _asMap(decoded['data']) ?? decoded;
      final post = _asMap(data['post']) ?? data;
      _prependPost(post);
      return true;
    } catch (error) {
      _showError(error);
      return false;
    }
  }

  Future<bool> editPost({
    required String postId,
    required String text,
    String? selectedTopicId,
  }) async {
    try {
      final response = await _api.editCommunityPost(postId, {
        'text': text,
        'topicId': selectedTopicId,
      });
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final decoded = _decodeResponse(response.body);
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      final decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : _decodeResponse(response.body);
      final index = posts.indexWhere((post) => post['id'] == postId);
      if (index != -1) {
        final edited = _asMap(decoded['data']);
        posts[index] = {
          ...posts[index],
          if (edited != null) ...edited,
          'text': text,
          'topicId': selectedTopicId,
        };
      }
      return true;
    } catch (error) {
      _showError(error);
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      final response = await _api.deleteCommunityPost(postId);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final decoded = _decodeResponse(response.body);
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      posts.removeWhere((post) => post['id'] == postId);
      return true;
    } catch (error) {
      _showError(error);
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchPost(
    String postId, {
    String? commentsCursor,
  }) async {
    final response = await _api.getCommunityPost(
      postId,
      commentsCursor: commentsCursor,
    );
    final decoded = _decodeResponse(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CommunityApiException(_errorMessage(decoded, response.statusCode));
    }
    final data = _asMap(decoded['data']) ?? decoded;
    final post = _asMap(data['post']);
    return post == null ? data : {...data, ...post};
  }

  Future<void> openThread(String postId) async {
    openPostId.value = postId;
    openPost.value = null;
    try {
      openPost.value = await fetchPost(postId);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> loadOlderComments() async {
    final post = openPost.value;
    final cursor = post?['commentsCursor']?.toString();
    final postId = openPostId.value;
    if (cursor == null || postId == null) return;

    try {
      final older = await fetchPost(postId, commentsCursor: cursor);
      final oldComments = _asListOfMaps(post?['comments']);
      final received = _asListOfMaps(older['comments']);
      openPost.value = {
        ...post!,
        'comments': [...received, ...oldComments],
        'commentsCursor': older['commentsCursor'],
      };
    } catch (error) {
      _showError(error);
    }
  }

  Future<Map<String, dynamic>?> createComment({
    required String postId,
    required String text,
    String? parentCommentId,
  }) async {
    try {
      final response = await _api.createCommunityComment(postId, {
        'text': text,
        if (parentCommentId != null) 'parentCommentId': parentCommentId,
      });
      final decoded = _decodeResponse(response.body);
      if (response.statusCode == 403 &&
          _errorMessage(decoded, response.statusCode)
              .contains('Only verified accounts can post')) {
        isComposerVisible.value = false;
        return null;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      final data = _asMap(decoded['data']) ?? decoded;
      final comment = _asMap(data['comment']) ?? data;
      _appendComment(comment, postId);
      return comment;
    } catch (error) {
      _showError(error);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> loadReplies(
    Map<String, dynamic> comment,
  ) async {
    final id = comment['id']?.toString();
    if (id == null) return _asListOfMaps(comment['replies']);
    try {
      final response = await _api.getCommunityReplies(id);
      final decoded = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      final data = decoded['data'];
      final replies = data is List
          ? data
          : data is Map
              ? (data['replies'] ?? data['items'] ?? const [])
              : const [];
      final parsed = _asListOfMaps(replies);
      _updateOpenComment(id, (item) => {...item, 'replies': parsed});
      return parsed;
    } catch (error) {
      _showError(error);
      return _asListOfMaps(comment['replies']);
    }
  }

  Future<void> toggleReaction({
    required String targetType,
    required Map<String, dynamic> target,
    required String reactionType,
  }) async {
    final targetId = target['id']?.toString();
    if (targetId == null) return;
    try {
      final response = await _api.reactToCommunityItem({
        'targetType': targetType,
        'targetId': targetId,
        'type': reactionType,
      });
      final decoded = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      final data = _asMap(decoded['data']) ?? decoded;
      final updated = {
        ...target,
        'myReaction': data['myReaction'],
        if (data['counts'] is Map)
          'counts': {
            ...?_asMap(target['counts']),
            'reactions': _asMap(data['counts'])?['reactions'],
          },
      };
      if (targetType == 'post') {
        _replacePost(targetId, updated);
      } else {
        _updateOpenComment(targetId, (_) => updated);
      }
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> toggleFollow(
      Map<String, dynamic> author, bool isFollowing) async {
    final id = author['id']?.toString();
    final type = author['type']?.toString().toLowerCase();
    if (id == null || (type != 'guard' && type != 'contractor')) return;
    final body = {'followingType': type, 'followingId': id};
    try {
      final response = isFollowing
          ? await _api.unfollowCommunityAuthor(body)
          : await _api.followCommunityAuthor(body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final decoded = _decodeResponse(response.body);
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      await showFollowing();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> reportItem({
    required String targetType,
    required String targetId,
    required String reason,
  }) async {
    try {
      final response = await _api.reportCommunityItem({
        'targetType': targetType,
        'targetId': targetId,
        'reason': reason,
      });
      final decoded = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CommunityApiException(
            _errorMessage(decoded, response.statusCode));
      }
      final data = _asMap(decoded['data']) ?? decoded;
      if (data['hidden'] == true) {
        if (targetType == 'post') {
          posts.removeWhere((post) => post['id'] == targetId);
        } else {
          _removeOpenComment(targetId);
        }
      }
      Get.snackbar(
          'Report submitted', 'Thank you for helping keep the community safe.');
    } catch (error) {
      _showError(error);
    }
  }

  void _listenForCommunitySocketEvents() {
    if (_socketListening) return;
    _socketListening = true;
    final socket = SocketService();
    socket.initialize();
    socket.communityStream.listen(_handleCommunityEvent);
  }

  void _handleCommunityEvent(Map<String, dynamic> event) {
    final name = event['event']?.toString();
    final eventData = _asMap(event['data']) ?? event;
    final payload = _asMap(eventData['data']) ?? eventData;
    switch (name) {
      case 'community:post-created':
        final post = _asMap(payload['post']) ?? payload;
        if (post['id'] != null) _prependPost(post);
        break;
      case 'community:comment-created':
        final comment = _asMap(payload['comment']) ?? payload;
        final postId = (comment['postId'] ?? payload['postId'])?.toString();
        if (postId != null) _appendComment(comment, postId);
        break;
      case 'community:reaction-updated':
        final id = (payload['targetId'] ?? payload['id'])?.toString();
        final counts = _asMap(payload['counts']);
        if (id != null && counts != null) {
          final postIndex = posts.indexWhere((post) => post['id'] == id);
          if (postIndex != -1) {
            posts[postIndex] = {
              ...posts[postIndex],
              'counts': {
                ...?_asMap(posts[postIndex]['counts']),
                'reactions': counts['reactions'],
              },
            };
          }
          _updateOpenComment(
              id,
              (comment) => {
                    ...comment,
                    'counts': {
                      ...?_asMap(comment['counts']),
                      'reactions': counts['reactions'],
                    },
                  });
        }
        break;
      case 'community:moderation':
        final id = (payload['id'] ?? payload['targetId'])?.toString();
        final postId =
            (payload['postId'] ?? payload['targetPostId'])?.toString();
        final status = payload['status']?.toString();
        final moderatedId = id ?? postId;
        if (moderatedId == null) return;
        if (status == 'hidden' || status == 'removed') {
          posts.removeWhere((post) => post['id'] == moderatedId);
          _removeOpenComment(moderatedId);
        } else if (status == 'visible' &&
            (openPostId.value == moderatedId || openPostId.value == postId)) {
          openThread(openPostId.value!);
        }
        break;
    }
  }

  void _prependPost(Map<String, dynamic> post) {
    final id = post['id'];
    if (id == null || posts.any((existing) => existing['id'] == id)) return;
    posts.insert(0, post);
  }

  void _replacePost(String id, Map<String, dynamic> updated) {
    final index = posts.indexWhere((post) => post['id'] == id);
    if (index != -1) posts[index] = updated;
    final open = openPost.value;
    if (open?['id'] == id) openPost.value = updated;
  }

  void _appendComment(Map<String, dynamic> comment, String postId) {
    if (openPostId.value != postId || openPost.value == null) return;
    final current = openPost.value!;
    final comments = _asListOfMaps(current['comments']);
    final commentId = comment['id'];
    final parentId = comment['parentCommentId']?.toString();
    if (parentId != null) {
      final parentIndex = comments.indexWhere((item) => item['id'] == parentId);
      if (parentIndex == -1) return;
      final parent = comments[parentIndex];
      final replies = _asListOfMaps(parent['replies']);
      if (!replies.any((reply) => reply['id'] == commentId)) {
        replies.add(comment);
        comments[parentIndex] = {...parent, 'replies': replies};
      }
    } else if (!comments.any((item) => item['id'] == commentId)) {
      comments.add(comment);
    }
    openPost.value = {...current, 'comments': comments};
  }

  void _updateOpenComment(
    String id,
    Map<String, dynamic> Function(Map<String, dynamic>) transform,
  ) {
    final current = openPost.value;
    if (current == null) return;
    final comments = _asListOfMaps(current['comments']);
    for (var index = 0; index < comments.length; index++) {
      final comment = comments[index];
      if (comment['id'] == id) {
        comments[index] = transform(comment);
        openPost.value = {...current, 'comments': comments};
        return;
      }
      final replies = _asListOfMaps(comment['replies']);
      final replyIndex = replies.indexWhere((reply) => reply['id'] == id);
      if (replyIndex != -1) {
        replies[replyIndex] = transform(replies[replyIndex]);
        comments[index] = {...comment, 'replies': replies};
        openPost.value = {...current, 'comments': comments};
        return;
      }
    }
  }

  void _removeOpenComment(String id) {
    final current = openPost.value;
    if (current == null) return;
    final comments = _asListOfMaps(current['comments']);
    comments.removeWhere((comment) => comment['id'] == id);
    for (var index = 0; index < comments.length; index++) {
      final comment = comments[index];
      final replies = _asListOfMaps(comment['replies'])
        ..removeWhere((reply) => reply['id'] == id);
      comments[index] = {...comment, 'replies': replies};
    }
    openPost.value = {...current, 'comments': comments};
  }

  Map<String, dynamic> _decodeResponse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map) {
      throw const FormatException('Unexpected Community response format.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  String _errorMessage(Map<String, dynamic> decoded, int statusCode) {
    final message = decoded['message'] ?? decoded['error'];
    return message?.toString() ?? 'Community request failed ($statusCode).';
  }

  void _showError(Object error) {
    debugPrint('Community request failed: $error');
    Get.snackbar('Community error', error.toString());
  }

  static Map<String, dynamic>? _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : null;

  static List<Map<String, dynamic>> _asListOfMaps(dynamic value) =>
      value is List
          ? value
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
          : <Map<String, dynamic>>[];
}

class CommunityApiException implements Exception {
  final String message;
  const CommunityApiException(this.message);

  @override
  String toString() => message;
}
