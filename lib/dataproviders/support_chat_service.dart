import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/models/support_chat_model.dart';

class SupportApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, String> fieldErrors;

  const SupportApiException(
    this.statusCode,
    this.message, {
    this.fieldErrors = const {},
  });

  @override
  String toString() => message;
}

class SupportFile {
  final String name;
  final String dataUri;

  const SupportFile({required this.name, required this.dataUri});
}

class SupportTicketPage {
  final List<SupportTicket> tickets;
  final int page;
  final int totalPages;

  const SupportTicketPage({
    required this.tickets,
    required this.page,
    required this.totalPages,
  });
}

class SupportThreadPage {
  final SupportTicket ticket;
  final List<SupportMessage> messages;
  final int page;
  final int totalPages;

  const SupportThreadPage({
    required this.ticket,
    required this.messages,
    required this.page,
    required this.totalPages,
  });
}

class SupportChatService {
  static const String _baseUrl =
      'https://api.control1security.com.au/api/v1/support';

  String get _token {
    final token = Get.find<UserController>().accessToken.value;
    if (token == null || token.trim().isEmpty) {
      throw StateError('A login token is required to use support chat.');
    }
    return token.trim();
  }

  Map<String, String> get _headers {
    final token = _token;
    return {
      'Content-Type': 'application/json',
      'Authorization':
          token.toLowerCase().startsWith('bearer ') ? token : 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    };
  }

  Future<SupportTicketPage> getTickets({int page = 1, int limit = 20}) async {
    final json = await _request(
      'GET',
      '/tickets',
      queryParameters: {'page': '$page', 'limit': '$limit'},
    );
    final data = json['data'];
    final pagination = _asMap(_asMap(json['meta'])?['pagination']) ?? {};
    return SupportTicketPage(
      tickets: data is List
          ? data
              .whereType<Map>()
              .map((ticket) =>
                  SupportTicket.fromJson(Map<String, dynamic>.from(ticket)))
              .toList()
          : const [],
      page: _intValue(pagination['page'], page),
      totalPages: _intValue(pagination['totalPages'], page),
    );
  }

  Future<SupportThreadPage> getThread(
    String ticketId, {
    int? page,
    int limit = 50,
  }) async {
    final json = await _request(
      'GET',
      '/tickets/${Uri.encodeComponent(ticketId)}',
      queryParameters: {
        if (page != null) 'page': '$page',
        'limit': '$limit',
      },
    );
    final data = _asMap(json['data']);
    if (data == null) {
      throw const FormatException(
          'Support chat response is missing ticket data.');
    }
    final rawMessages = data['messages'];
    final pagination = _asMap(_asMap(json['meta'])?['pagination']) ?? {};
    return SupportThreadPage(
      ticket: SupportTicket.fromJson(data),
      messages: rawMessages is List
          ? rawMessages
              .whereType<Map>()
              .map((message) =>
                  SupportMessage.fromJson(Map<String, dynamic>.from(message)))
              .toList()
          : const [],
      page: _intValue(pagination['page'], page ?? 1),
      totalPages: _intValue(pagination['totalPages'], 1),
    );
  }

  Future<SupportThreadPage> createTicket({
    required String subject,
    required String text,
    List<SupportFile> attachments = const [],
  }) async {
    final json = await _request(
      'POST',
      '/tickets',
      body: {
        'subject': subject,
        'text': text,
        'attachments': attachments.map((file) => file.dataUri).toList(),
      },
      acceptedStatusCodes: const {201},
    );
    final data = _asMap(json['data']);
    if (data == null) {
      throw const FormatException(
          'Support chat response is missing ticket data.');
    }
    final rawMessages = data['messages'];
    return SupportThreadPage(
      ticket: SupportTicket.fromJson(data),
      messages: rawMessages is List
          ? rawMessages
              .whereType<Map>()
              .map((message) =>
                  SupportMessage.fromJson(Map<String, dynamic>.from(message)))
              .toList()
          : const [],
      page: 1,
      totalPages: 1,
    );
  }

  Future<SupportMessage> sendMessage(
    String ticketId, {
    required String text,
    List<SupportFile> attachments = const [],
  }) async {
    final json = await _request(
      'POST',
      '/tickets/${Uri.encodeComponent(ticketId)}/messages',
      body: {
        'text': text,
        'attachments': attachments.map((file) => file.dataUri).toList(),
      },
      acceptedStatusCodes: const {201},
    );
    final data = _asMap(json['data']);
    final message = _asMap(data?['message']);
    if (message == null) {
      throw const FormatException(
          'Support chat response is missing the message.');
    }
    return SupportMessage.fromJson(message);
  }

  Future<SupportTicket> closeTicket(String ticketId) async {
    final json = await _request(
      'POST',
      '/tickets/${Uri.encodeComponent(ticketId)}/close',
    );
    final data = _asMap(json['data']);
    if (data == null) {
      throw const FormatException(
          'Support chat response is missing ticket data.');
    }
    return SupportTicket.fromJson(data);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    Set<int> acceptedStatusCodes = const {200},
  }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(
      queryParameters: queryParameters,
    );
    final request = http.Request(method, uri)..headers.addAll(_headers);
    if (body != null) request.body = jsonEncode(body);

    final client = http.Client();
    late final http.Response response;
    try {
      response = await client.send(request).then(http.Response.fromStream);
    } finally {
      client.close();
    }
    return _decodeResponse(response, acceptedStatusCodes);
  }

  Map<String, dynamic> _decodeResponse(
    http.Response response,
    Set<int> acceptedStatusCodes,
  ) {
    final dynamic decoded = jsonDecode(response.body);
    final json = _asMap(decoded);
    if (json == null) {
      throw const FormatException('Support chat returned an invalid response.');
    }
    if (!acceptedStatusCodes.contains(response.statusCode)) {
      final fieldErrors = <String, String>{};
      final errors = json['data'];
      if (errors is List) {
        for (final error in errors.whereType<Map>()) {
          final field = error['field']?.toString();
          final message = error['message']?.toString();
          if (field != null && message != null) fieldErrors[field] = message;
        }
      }
      throw SupportApiException(
        response.statusCode,
        json['message']?.toString() ?? 'Support request failed.',
        fieldErrors: fieldErrors,
      );
    }
    return json;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static int _intValue(dynamic value, int fallback) =>
      int.tryParse(value?.toString() ?? '') ?? fallback;
}
