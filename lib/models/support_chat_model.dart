class SupportTicket {
  final String id;
  final String subject;
  final String status;
  final Map<String, dynamic> requester;
  final Map<String, dynamic>? claimedBy;
  final String? lastMessageAt;
  final String? lastMessagePreview;
  final int requesterUnreadCount;
  final String? closedAt;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.requester,
    required this.claimedBy,
    required this.lastMessageAt,
    required this.lastMessagePreview,
    required this.requesterUnreadCount,
    required this.closedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      status: json['status']?.toString() ?? 'open',
      requester: _mapValue(json['requester']) ?? const {},
      claimedBy: _mapValue(json['claimedBy']),
      lastMessageAt: json['lastMessageAt']?.toString(),
      lastMessagePreview: json['lastMessagePreview']?.toString(),
      requesterUnreadCount:
          int.tryParse(json['requesterUnreadCount']?.toString() ?? '') ?? 0,
      closedAt: json['closedAt']?.toString(),
    );
  }

  SupportTicket copyWith({
    String? status,
    Map<String, dynamic>? claimedBy,
    bool clearClaimedBy = false,
    String? lastMessageAt,
    String? lastMessagePreview,
    int? requesterUnreadCount,
    String? closedAt,
  }) {
    return SupportTicket(
      id: id,
      subject: subject,
      status: status ?? this.status,
      requester: requester,
      claimedBy: clearClaimedBy ? null : claimedBy ?? this.claimedBy,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      requesterUnreadCount: requesterUnreadCount ?? this.requesterUnreadCount,
      closedAt: closedAt ?? this.closedAt,
    );
  }
}

class SupportMessage {
  final String id;
  final String senderType;
  final String? senderId;
  final String? senderName;
  final String text;
  final List<String> attachments;
  final String? createdAt;

  const SupportMessage({
    required this.id,
    required this.senderType,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.attachments,
    required this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    final rawAttachments = json['attachments'];
    return SupportMessage(
      id: json['id']?.toString() ?? '',
      senderType: json['senderType']?.toString() ?? 'system',
      senderId: json['senderId']?.toString(),
      senderName: json['senderName']?.toString(),
      text: json['text']?.toString() ?? '',
      attachments: rawAttachments is List
          ? rawAttachments.map((value) => value.toString()).toList()
          : const [],
      createdAt: json['createdAt']?.toString(),
    );
  }
}

Map<String, dynamic>? _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
