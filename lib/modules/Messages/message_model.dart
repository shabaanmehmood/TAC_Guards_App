class ChatMessage {
  final String message;
  final DateTime timestamp;
  final bool isMe;
  final bool isSeen;

  ChatMessage({
    required this.message,
    required this.timestamp,
    required this.isMe,
    required this.isSeen,
  });
}