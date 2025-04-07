import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotificationController extends GetxController {
  var notifications = [
    {
      "title": "Badge Earned",
      "message": "Congratulations! You have earned the Leader badge.",
      "time": "03:35 PM",
      "icon": 'assets/logo.png',
    },
    {
      "title": "Congratulations! Alex hired you.",
      "message": "Your application for 'Job Name' is approved.",
      "time": "03:35 PM",
      "icon": 'assets/logo.png',
    },
    {
      "title": "Message Received",
      "message": "New message from your contractor John Smith.",
      "time": "03:15 PM",
      "icon": 'assets/logo.png',
    },
    {
      "title": "Shift Reminder",
      "message": "Your shift starts in 30 minutes. Please check in.",
      "time": "03:15 PM",
      "icon": 'assets/logo.png',
    },
    {
      "title": "Job Complete. Contract ended by contractor.",
      "message": "Your License(ID) is expiring soon. Update it in the system.",
      "time": "03:15 PM",
      "icon": 'assets/logo.png',
    },
    {
      "title": "App Update Available",
      "message": "View your recommended match today!",
      "time": "03:35 PM",
      "icon": 'assets/logo.png',
    },
  ].obs;
}

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F), // Dark Blue Background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Notifications",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              controller.notifications.clear();
            },
            child: const Text(
              "Mark all read",
              style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Obx(() {
          return ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              var item = controller.notifications[index];

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF112240), // Card Background
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(item["icon"]!, height: 30, width: 30),
                    ),
                    const SizedBox(width: 12),
                    // Notification Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item["message"]!,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Time Stamp
                    Text(
                      item["time"]!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}