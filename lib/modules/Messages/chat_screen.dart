import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import '../../data/data/constants/app_colors.dart';
import '../../data/data/constants/app_typography.dart';
import 'chat_controller.dart';
import 'client profile/client_profile_screen.dart';
import 'message_model.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String time;
  final String message;
  final String image;
  final String contractorId;

  const ChatScreen({
    Key? key,
    required this.name,
    required this.time,
    required this.message,
    required this.image,
    required this.contractorId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.connectSocket(widget.contractorId);
  }

  @override
  void dispose() {
    controller.disconnect();
    messageController.dispose();
    super.dispose();
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg) {
    final bubbleColor = msg.isMe ? AppColors.kChat : AppColors.kJobCardColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        msg.message,
        style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack, width: 24, height: 24),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Text(widget.name, style: TextStyle(color: AppColors.kWhite)),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final msg = controller.messages[controller.messages.length - 1 - index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      _buildMessageBubble(context, msg),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE h:mma').format(msg.timestamp),
                        style: AppTypography.kLight14?.copyWith(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            )),
          ),
          const Divider(height: 1, color: Colors.white12),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTypography.kLight14.copyWith(
                        color: AppColors.kWhite.withOpacity(0.6),
                      ),
                      filled: true,
                      fillColor: AppColors.kDarkestBlue,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.kWhite.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.kWhite,
                          width: 1.2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Image.asset(
                    AppAssets.kSend,
                    width: 24,
                    height: 24,
                    color: AppColors.kPrimary,
                  ),
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      controller.sendMessage(messageController.text);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}