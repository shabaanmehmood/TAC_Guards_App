// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import '../../controllers/user_controller.dart';
// import 'message_model.dart';
//
// class ChatController extends GetxController {
//   late IO.Socket socket;
//   final UserController userController = Get.find<UserController>();
//   RxList<ChatMessage> messages = <ChatMessage>[].obs;
//   final String guardType = "Contractor";
//   String _contractorId = "";
//
//   void connectSocket(String contractorId) {
//     _contractorId = contractorId;
//
//     // Initialize socket connection
//     socket = IO.io('http://148.66.158.113:3006/', <String, dynamic>{
//       'transports': ['websocket'],
//     });
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       print('Socket connected');
//       // Fetch message history when connected
//       _fetchMessageHistory();
//     });
//
//     // Listen for new messages
//     socket.on('new-message', (data) {
//       print('Received: $data');
//       final msg = ChatMessage(
//           message: data['text'] ?? '',
//           timestamp: DateTime.now(),
//           isMe: data['senderId'] == userController.userData.value!.id!,
//           isSeen: false
//       );
//       messages.add(msg);
//     });
//
//     // Listen for message history
//     socket.on('message-history', (data) {
//       final List<dynamic> messageList = data['messages'] ?? [];
//       final List<ChatMessage> historicalMessages = messageList.map((msg) {
//         return ChatMessage(
//             message: msg['message'] ?? '',
//             timestamp: DateTime.parse(msg['timestamp']),
//             isMe: msg['sender']['id'] == userController.userData.value!.id!,
//             isSeen: msg['isSeen'] ?? false
//         );
//       }).toList();
//
//       messages.assignAll(historicalMessages);
//     });
//
//     socket.onDisconnect((_) => print('Socket disconnected'));
//   }
//
//   void _fetchMessageHistory() {
//     final userId = userController.userData.value!.id!;
//     socket.emit('message-history', {
//       'user1Id': userId,
//       'user1Type': guardType,
//       'user2Id': _contractorId,
//       'user2Type': "Guard",
//       'limit': 50, // Adjust limit as needed
//     });
//     print('Requesting message history for user: $userId');
//   }
//
//   void sendMessage(String text) {
//     if (text.trim().isEmpty || _contractorId.isEmpty) return;
//
//     final message = {
//       "senderId": userController.userData.value!.id!,
//       "senderType": guardType,
//       "receiverId": _contractorId,
//       "receiverType": "Guard",
//       "text": text,
//     };
//
//     socket.emit('send_message', message);
//     debugPrint("Message sent: $message");
//
//     messages.add(ChatMessage(
//         message: text,
//         timestamp: DateTime.now(),
//         isMe: true,
//         isSeen: false
//     ));
//   }
//
//   void disconnect() {
//     socket.dispose();
//   }
// }
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import '../../controllers/user_controller.dart';
// import 'message_model.dart';
//
// class ChatController extends GetxController {
//   late IO.Socket socket;
//   final UserController userController = Get.find<UserController>();
//   RxList<ChatMessage> messages = <ChatMessage>[].obs;
//   final String guardType = "Contractor";
//   String _contractorId = "";
//
//   void connectSocket(String contractorId) {
//     _contractorId = contractorId;
//
//     // Initialize socket connection
//     socket = IO.io('http://148.66.158.113:3006/', <String, dynamic>{
//       'transports': ['websocket'],
//       'query': {
//         'userId': userController.userData.value!.id!
//       }
//     });
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       print('Socket connected');
//       // Fetch message history when connected
//       _fetchMessageHistory();
//     });
//
//     // Listen for new messages
//     socket.on('new-message', (data) {
//       print('Received new message: $data');
//       if (data != null && data['text'] != null) {
//         final msg = ChatMessage(
//             message: data['text'],
//             timestamp: DateTime.now(),
//             isMe: data['senderId'] == userController.userData.value!.id!,
//             isSeen: false
//         );
//         messages.add(msg);
//       }
//     });
//
//     // Listen for message history
//     socket.on('message-history', (data) {
//       print('Received message history: $data');
//       if (data != null && data['messages'] != null) {
//         final List<dynamic> messageList = data['messages'];
//         final List<ChatMessage> historicalMessages = messageList.map<ChatMessage>((msg) {
//           return ChatMessage(
//               message: msg['message'] ?? '',
//               timestamp: DateTime.parse(msg['timestamp']),
//               isMe: msg['sender']['id'] == userController.userData.value!.id!,
//               isSeen: msg['isSeen'] ?? false
//           );
//         }).toList();
//
//         messages.assignAll(historicalMessages.reversed.toList());
//       }
//     });
//
//     socket.onDisconnect((_) => print('Socket disconnected'));
//     socket.onError((error) => print('Socket error: $error'));
//     socket.onConnectError((error) => print('Socket connect error: $error'));
//   }
//
//   void _fetchMessageHistory() {
//     final userId = userController.userData.value!.id!;
//     print('Requesting message history with userId: $userId');
//
//     socket.emit('get-message', {
//       'user1Id': userId,
//       'user1Type': "Contractor",
//       'user2Id': _contractorId,
//       'user2Type': "Guard",
//       'limit': 50, // Adjust limit as needed
//     });
//   }
//
//   void sendMessage(String text) {
//     if (text.trim().isEmpty || _contractorId.isEmpty) return;
//
//     final message = {
//       "senderId": userController.userData.value!.id!,
//       "senderType": guardType,
//       "receiverId": _contractorId,
//       "receiverType": "Guard",
//       "text": text,
//     };
//
//     socket.emit('send-message', message);
//     debugPrint("Sending message: $message");
//
//     // Add message to local list immediately for UI update
//     messages.add(ChatMessage(
//         message: text,
//         timestamp: DateTime.now(),
//         isMe: true,
//         isSeen: false
//     ));
//   }
//
//   void disconnect() {
//     if (socket.connected) {
//       socket.disconnect();
//       socket.dispose();
//     }
//   }
//
//   @override
//   void onClose() {
//     disconnect();
//     super.onClose();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tac/modules/Messages/socket_file.dart';
import '../../controllers/user_controller.dart';
import 'message_model.dart';

class ChatController extends GetxController {
  late IO.Socket socket;
  final UserController userController = Get.find<UserController>();
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final String guardType = "Guard";
  String _contractorId = "";
  final SocketService _socketService = SocketService();

  void connectSocket(String contractorId) {
    _contractorId = contractorId;

    // Initialize socket connection
    socket = IO.io('http://148.66.158.113:3006/', <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        'userId': userController.userData.value!.id!
      }
    });

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
      // Fetch message history when connected
      _fetchMessageHistory();
    });

    // Listen for new messages
    socket.on('new-message', (data) {
      print('Received new message: $data');
      if (data != null && data['text'] != null) {
        final msg = ChatMessage(
            message: data['text'],
            timestamp: DateTime.now(),
            isMe: data['senderId'] == userController.userData.value!.id!,
            isSeen: false
        );
        messages.add(msg);
      }
    });

    // Listen for message history response
    socket.on('message-history', (data) {
      print('Received message history: $data');
      if (data != null && data['messages'] != null) {
        final List<dynamic> messageList = data['messages'];
        final List<ChatMessage> historicalMessages = messageList.map<ChatMessage>((msg) {
          // Handle different possible message structures
          final senderId = msg['sender'] != null ? msg['sender']['id'] : msg['senderId'];
          final messageText = msg['message'] ?? msg['text'] ?? '';

          return ChatMessage(
              message: messageText,
              timestamp: DateTime.parse(msg['timestamp'] ?? msg['createdAt'] ?? DateTime.now().toIso8601String()),
              isMe: senderId == userController.userData.value!.id!,
              isSeen: msg['isSeen'] ?? false
          );
        }).toList();

        // Clear existing messages and add historical ones
        messages.clear();
        messages.addAll(historicalMessages.reversed.toList());
      }
    });

    socket.onDisconnect((_) => print('Socket disconnected'));
    socket.onError((error) => print('Socket error: $error'));
    socket.onConnectError((error) => print('Socket connect error: $error'));
  }

  void _fetchMessageHistory() {
    final userId = userController.userData.value!.id!;

    // Create the request payload matching your example
    final payload = {
      'user1Id': userId,
      'user1Type': guardType,  // "Contractor"
      'user2Id': _contractorId,
      'user2Type': "Contractor",
      'limit': 100,  // Adjust limit as needed
    };

    print('Requesting message history with payload: $payload');

    // Emit to 'get-messages' (with 's') as per your specification
    socket.emit('get-messages', payload);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty || _contractorId.isEmpty) return;

    final message = {
      "senderId": userController.userData.value!.id!,
      "senderType": guardType,
      "receiverId": _contractorId,
      "receiverType": "Contractor",
      "text": text,
    };

    socket.emit('send-message', message);
    debugPrint("Sending message: $message");

    // Add message to local list immediately for UI update
    messages.add(ChatMessage(
        message: text,
        timestamp: DateTime.now(),
        isMe: true,
        isSeen: false
    ));
    _socketService.refreshChatList();
  }

  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
      socket.dispose();
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}