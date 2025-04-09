// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';
// import 'package:tac/widhets/common%20widgets/buttons/myJob_card.dart';
// import 'check_in_controller.dart';
// import 'dummy_data.dart'; // Import the dummy data file

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CheckInPage extends StatelessWidget {
//   final String jobTitle;
//   final String errorCode;

//   const CheckInPage({
//     Key? key,
//     this.jobTitle = 'Security Escort for Actor – Airport to Residence',
//     this.errorCode = '1234',
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFF0E1221),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header row with icon and close button
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 padding: const EdgeInsets.all(8),
//                 child: const Icon(Icons.error_outline, color: Colors.red),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: const Icon(Icons.close, color: Colors.white70),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),

//           const Text(
//             "Check-In Error",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "Oops! Something went wrong. Please try again.",
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 20),

//           Text(
//             jobTitle,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 10),

//           Row(
//             children: [
//               const Text(
//                 "Error Code ",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 "#$errorCode",
//                 style: const TextStyle(
//                   color: Colors.white54,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),

//           const Text(
//             "Check your internet connection or contact support.",
//             style: TextStyle(
//               color: Colors.redAccent,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 24),

//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00D9F5),
//                 foregroundColor: Colors.black,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 Get.back(); // Dismiss the bottom sheet
//               },
//               child: const Text(
//                 "Retry",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
