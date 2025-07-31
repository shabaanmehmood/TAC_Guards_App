import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/dataproviders/api_service.dart';

// Your Contractor/PersonalDetail model classes should be imported here.

class MessagesController extends GetxController {
  final RxInt selectedChipIndex = 0.obs;
  final RxBool isLoading = false.obs;
  MyApIService myApIService = MyApIService();

  static const List<String> chipLabels = [
    'All',
    'Unread',
    'Blocked',
    'Favorites'
  ];

  final RxList<MessageModel> allMessages = <MessageModel>[].obs; // Full list
  final RxList<MessageModel> messages = <MessageModel>[].obs;    // Filtered list shown in UI

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllContractors();
    // Listen for search query changes
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();

    if(query.isEmpty) {
      messages.value = allMessages;
    } else {
      messages.value = allMessages.where((msg) {
        final nameLower = msg.name.toLowerCase();
        final emailLower = msg.message.toLowerCase(); // Assuming msg.message stores email
        return nameLower.contains(query) || emailLower.contains(query);
      }).toList();
    }
  }

  Future<void> fetchAllContractors() async {
    isLoading.value = true;
    try {
      final response = await myApIService.getAllContractorsList();
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> contractors = json['data'] ?? [];
        allMessages.value = contractors.map<MessageModel>((c) {
          return MessageModel(
            name: (c['name']?.isNotEmpty == true) ? c['name'] : (c['email'] ?? "No Name"),
            time: "",                   // you can format c['updatedDate'] or leave empty
            message: c['email'] ?? "", // storing email for search here
            image: AppAssets.kTacLogo, // update to image if available
            contractorId: c['id'] ?? "",
          );
        }).toList();

        // initialize filtered list with all messages
        messages.value = allMessages;
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Error fetching contractors: $e");
    }
    isLoading.value = false;
  }
}

class MessageModel {
  final String name;
  final String time;
  final String message;
  final String image;
  final String contractorId;

  const MessageModel({
    required this.name,
    required this.time,
    required this.message,
    required this.image,
    this.contractorId = "",
  });
}

