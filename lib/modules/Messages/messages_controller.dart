// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/dataproviders/api_service.dart';
//
// // Your Contractor/PersonalDetail model classes should be imported here.
//
// class MessagesController extends GetxController {
//   final RxInt selectedChipIndex = 0.obs;
//   final RxBool isLoading = false.obs;
//   MyApIService myApIService = MyApIService();
//
//   static const List<String> chipLabels = [
//     'All',
//     'Unread',
//     'Blocked',
//     'Favorites'
//   ];
//
//   final RxList<MessageModel> allMessages = <MessageModel>[].obs; // Full list
//   final RxList<MessageModel> messages = <MessageModel>[].obs;    // Filtered list shown in UI
//
//   final TextEditingController searchController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllContractors();
//     // Listen for search query changes
//     searchController.addListener(_onSearchChanged);
//   }
//
//   void _onSearchChanged() {
//     final query = searchController.text.toLowerCase();
//
//     if(query.isEmpty) {
//       messages.value = allMessages;
//     } else {
//       messages.value = allMessages.where((msg) {
//         final nameLower = msg.name.toLowerCase();
//         final emailLower = msg.message.toLowerCase(); // Assuming msg.message stores email
//         return nameLower.contains(query) || emailLower.contains(query);
//       }).toList();
//     }
//   }
//
//   Future<void> fetchAllContractors() async {
//     isLoading.value = true;
//     try {
//       final response = await myApIService.getAllContractorsList();
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> json = jsonDecode(response.body);
//         final List<dynamic> contractors = json['data'] ?? [];
//         allMessages.value = contractors.map<MessageModel>((c) {
//           return MessageModel(
//             name: (c['name']?.isNotEmpty == true) ? c['name'] : (c['email'] ?? "No Name"),
//             time: "",                   // you can format c['updatedDate'] or leave empty
//             message: c['email'] ?? "", // storing email for search here
//             image: AppAssets.kTacLogo, // update to image if available
//             contractorId: c['id'] ?? "",
//           );
//         }).toList();
//
//         // initialize filtered list with all messages
//         messages.value = allMessages;
//       } else {
//         debugPrint('Error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       debugPrint("Error fetching contractors: $e");
//     }
//     isLoading.value = false;
//   }
// }
//
// class MessageModel {
//   final String name;
//   final String time;
//   final String message;
//   final String image;
//   final String contractorId;
//
//   const MessageModel({
//     required this.name,
//     required this.time,
//     required this.message,
//     required this.image,
//     this.contractorId = "",
//   });
// }
//


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tac/modules/Messages/socket_file.dart';
import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_assets.dart';

class MessagesController extends GetxController {
  final RxBool isLoading = false.obs;
  final SocketService _socketService = SocketService();

  final RxList<ChatItemModel> allChats = <ChatItemModel>[].obs;
  final RxList<ChatItemModel> filteredChats = <ChatItemModel>[].obs;

  final TextEditingController searchController = TextEditingController();

  StreamSubscription? _chatListSubscription;

  UserController userController = Get.find<UserController>();

  // User credentials - Replace with actual logged-in user data
  final String userId = Get.find<UserController>().userData.value!.id!;
  final String userType = "Guard";

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
    searchController.addListener(_onSearchChanged);
  }

  void refreshFromChatScreen() {
    if(_socketService.isConnected) {
      fetchChatList();
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    if(_socketService.isConnected) {
      _initializeSocket();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _socketService.dispose();
    _chatListSubscription?.cancel();
    searchController.dispose();
    allChats.clear();
    filteredChats.clear();
    isLoading.value = false;
    debugPrint("Disposed MessagesController and cleared resources");
  }

  void _initializeSocket() {
    isLoading.value = true;

    // Initialize socket connection
    _socketService.initialize();

    // Listen to chat list updates
    _chatListSubscription = _socketService.chatListStream.listen(
          (data) {
        _handleChatListData(data);
      },
      onError: (error) {
        debugPrint('Error in chat list stream: $error');
        isLoading.value = false;
      },
    );

    // Request chat list
    Future.delayed(Duration(seconds: 1), () {
      fetchChatList();
    });
  }

  void fetchChatList() {
    isLoading.value = true;
    _socketService.getChatList(
      userId: userId,
      userType: userType,
    );
  }

  void _handleChatListData(Map<String, dynamic> data) {
    try {
      debugPrint('🔍 Processing chat data: $data');

      if (!data.containsKey('chats')) {
        debugPrint('⚠️ No chats key found in response');
        isLoading.value = false;
        return;
      }

      final List<dynamic> chats = data['chats'] ?? [];
      debugPrint('📊 Found ${chats.length} chats');

      allChats.value = chats.map<ChatItemModel>((chat) {
        debugPrint('Processing chat: $chat');
        final partner = chat['partner'] ?? {};
        final lastMessage = chat['lastMessage'] ?? {};

        return ChatItemModel(
          partnerId: partner['id'] ?? '',
          partnerName: partner['name'] ?? 'Unknown',
          partnerType: partner['type'] ?? 'Contractor',
          lastMessageText: lastMessage['text'] ?? '',
          lastMessageTimestamp: lastMessage['timestamp'] ?? '',
          isSeen: lastMessage['isSeen'] ?? false,
          image: AppAssets.kTacLogo,
        );
      }).toList();

      filteredChats.value = allChats;
      isLoading.value = false;
      debugPrint('✅ Chat list updated with ${allChats.length} items');
    } catch (e) {
      debugPrint('❌ Error parsing chat list: $e');
      isLoading.value = false;
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      filteredChats.value = allChats;
    } else {
      filteredChats.value = allChats.where((chat) {
        final nameLower = chat.partnerName.toLowerCase();
        return nameLower.contains(query);
      }).toList();
    }
  }

  String formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';

    try {
      final DateTime messageDate = DateTime.parse(timestamp);
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime messageDay = DateTime(messageDate.year, messageDate.month, messageDate.day);

      // If message is from today, show time
      if (messageDay == today) {
        return DateFormat('h:mm a').format(messageDate); // 5:16 PM
      } else {
        // If message is from past, show date
        return DateFormat('M/d/yy').format(messageDate); // 9/27/25
      }
    } catch (e) {
      debugPrint('Error formatting timestamp: $e');
      return '';
    }
  }

  @override
  void onClose() {
    _chatListSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}

class ChatItemModel {
  final String partnerId;
  final String partnerName;
  final String partnerType;
  final String lastMessageText;
  final String lastMessageTimestamp;
  final bool isSeen;
  final String image;

  ChatItemModel({
    required this.partnerId,
    required this.partnerName,
    required this.partnerType,
    required this.lastMessageText,
    required this.lastMessageTimestamp,
    required this.isSeen,
    required this.image,
  });
}