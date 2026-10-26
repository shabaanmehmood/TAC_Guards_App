import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tac/dataproviders/api_service.dart';

class CommunityApiException implements Exception {
  final int statusCode;
  final String message;

  const CommunityApiException(this.statusCode, this.message);
}

class CommunityPage {
  final List<Map<String, dynamic>> posts;
  final String? nextCursor;

  const CommunityPage({required this.posts, required this.nextCursor});
}

class CommunityService {
  CommunityService({
    required this.token,
    required this.accountId,
    required this.accountType,
  })  : _baseUrl = '${MyApIService().baseurl}community/',
        _origin = Uri.parse(MyApIService().baseurl).origin;

  final String token;
  final String accountId;
  final String accountType;
  final String _baseUrl;
  final String _origin;

  String imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final relativePath = path.startsWith('/') ? path.substring(1) : path;
    return '$_origin/uploads/$relativePath';
  }

  Future<List<Map<String, dynamic>>> fetchTopics() async {
    final response = await _send('GET', 'topics');
    return _asMapList(response['data']);
  }

  Future<CommunityPage> fetchFeed({
    required String filter,
    String? topicId,
    String? cursor,
    int limit = 20,
  }) async {
    final query = <String, String>{
      'limit': '$limit',
      'filter': filter,
      if (topicId != null) 'topicId': topicId,
      if (cursor != null) 'cursor': cursor,
    };
    final response = await _send('GET', 'feed', query: query);
    final meta = response['meta'] is Map
        ? Map<String, dynamic>.from(response['meta'] as Map)
        : const <String, dynamic>{};
    return CommunityPage(
      posts: _asMapList(response['data']),
      nextCursor: meta['nextCursor'] as String?,
    );
  }

  Future<Map<String, dynamic>> createPost({
    required String text,
    required List<String> images,
    String? topicId,
    String? jobId,
  }) async {
    final response = await _send(
      'POST',
      'posts',
      body: {
        'text': text,
        if (images.isNotEmpty) 'images': images,
        if (topicId != null) 'topicId': topicId,
        if (jobId != null) 'jobId': jobId,
      },
    );
    final post = response['data'] ?? response;
    if (post is! Map) {
      throw const CommunityApiException(500, 'The post response was invalid.');
    }
    return Map<String, dynamic>.from(post);
  }

  Future<Map<String, dynamic>> fetchPost(String postId) async {
    final response = await _send('GET', 'posts/${Uri.encodeComponent(postId)}');
    return _dataMap(response);
  }

  Future<CommunityPage> fetchComments(
    String postId, {
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _send(
      'GET',
      'posts/${Uri.encodeComponent(postId)}/comments',
      query: {
        'limit': '$limit',
        if (cursor != null) 'cursor': cursor,
      },
    );
    return _page(response);
  }

  Future<CommunityPage> fetchReplies(
    String commentId, {
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _send(
      'GET',
      'comments/${Uri.encodeComponent(commentId)}/replies',
      query: {
        'limit': '$limit',
        if (cursor != null) 'cursor': cursor,
      },
    );
    return _page(response);
  }

  Future<Map<String, dynamic>> createComment(
    String postId, {
    required String text,
    String? parentCommentId,
  }) async {
    final response = await _send(
      'POST',
      'posts/${Uri.encodeComponent(postId)}/comments',
      body: {
        'text': text,
        if (parentCommentId != null) 'parentCommentId': parentCommentId,
      },
    );
    return _dataMap(response);
  }

  Future<Map<String, dynamic>> editPost(
    String postId, {
    required String text,
    required String? topicId,
  }) async {
    final response = await _send(
      'PATCH',
      'posts/${Uri.encodeComponent(postId)}',
      body: {'text': text, 'topicId': topicId},
    );
    return _dataMap(response);
  }

  Future<void> deletePost(String postId) async {
    await _send('DELETE', 'posts/${Uri.encodeComponent(postId)}');
  }

  Future<Map<String, dynamic>> editComment(
    String commentId, {
    required String text,
  }) async {
    final response = await _send(
      'PATCH',
      'comments/${Uri.encodeComponent(commentId)}',
      body: {'text': text},
    );
    return _dataMap(response);
  }

  Future<void> deleteComment(String commentId) async {
    await _send('DELETE', 'comments/${Uri.encodeComponent(commentId)}');
  }

  Future<Map<String, dynamic>> react({
    required String targetType,
    required String targetId,
    required String type,
  }) async {
    final response = await _send(
      'POST',
      'reactions',
      body: {'targetType': targetType, 'targetId': targetId, 'type': type},
    );
    return _dataMap(response);
  }

  Future<void> follow({
    required String followingType,
    required String followingId,
    required bool follow,
  }) async {
    await _send(
      follow ? 'POST' : 'DELETE',
      'follows',
      body: {'followingType': followingType, 'followingId': followingId},
    );
  }

  Future<List<Map<String, dynamic>>> fetchFollowing() async {
    final response = await _send(
      'GET',
      'follows',
      query: const {'direction': 'following'},
    );
    return _asMapList(response['data']);
  }

  Future<List<dynamic>> fetchOpenOwnedJobs() async {
    return const [];
  }

  Future<Map<String, dynamic>> report({
    required String targetType,
    required String targetId,
    required String reason,
  }) async {
    final response = await _send(
      'POST',
      'reports',
      body: {
        'targetType': targetType,
        'targetId': targetId,
        'reason': reason,
      },
    );
    return _dataMap(response);
  }

  CommunityPage _page(Map<String, dynamic> response) {
    final meta = response['meta'] is Map
        ? Map<String, dynamic>.from(response['meta'] as Map)
        : const <String, dynamic>{};
    return CommunityPage(
      posts: _asMapList(response['data']),
      nextCursor: meta['nextCursor'] as String?,
    );
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return response;
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    var uri = Uri.parse('$_baseUrl$path');
    if (query != null) uri = uri.replace(queryParameters: query);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    final response = switch (method) {
      'GET' => await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 25)),
      'POST' => await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 40)),
      'PATCH' => await http
          .patch(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30)),
      'DELETE' => await http
          .delete(
            uri,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(const Duration(seconds: 25)),
      _ => throw ArgumentError.value(method, 'method'),
    };

    Map<String, dynamic> payload;
    try {
      if (response.body.isEmpty) {
        payload = {};
      } else {
        final decoded = jsonDecode(response.body);
        payload = decoded is Map ? Map<String, dynamic>.from(decoded) : {};
      }
    } on FormatException {
      payload = {};
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      var message =
          payload['message'] as String? ?? 'Community request failed.';
      final details = payload['data'];
      if (details is List && details.isNotEmpty && details.first is Map) {
        final firstError = Map<String, dynamic>.from(details.first as Map);
        message = firstError['message'] as String? ?? message;
      }
      throw CommunityApiException(response.statusCode, message);
    }
    return payload;
  }

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
