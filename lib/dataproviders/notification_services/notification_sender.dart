// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:taccontractor/dataproviders/notification_services/server_key.dart';

// //calling method 
// // final notifySender = NotificationSenderController();
// // await notifySender.sendPushNotification(
// //   title: "Test Notification",
// //   body: "This is a dynamic message.",
// //   token: devToken ?? "", // Ensure token is not null
// // );

// class NotificationSenderController {
//   Future<void> sendPushNotification({
//     required String title,
//     required String body,
//     required String token,
//   }) async {
//     try {
//       final get = get_server_key();
//       String serverToken = await get.server_token();

//       final response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/v1/projects/taccontractor-f77ef/messages:send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $serverToken',
//         },
//         body: jsonEncode(<String, dynamic>{
//           "message": {
//             "token": token,
//             "notification": {
//               "title": title,
//               "body": body,
//             },
           
//           }
//         }),
//       );

//       if (response.statusCode == 200) {
//         print("✅ Notification sent successfully.");
//       } else {
//         print("❌ Failed to send notification: ${response.statusCode}");
//         print("Response: ${response.body}");
//       }
//     } catch (e) {
//       print("❌ Error sending notification: $e");
//     }
//   }
// }