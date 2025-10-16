// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'dummy_data.dart';

// import 'job_live_controller.dart';

// class JobLiveScreen_inprogress extends StatelessWidget {
//   final controller = Get.put(JobLiveController());

//   JobLiveScreen_inprogress({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0E21),
//       appBar: AppBar(
//         backgroundColor: AppColors.kDarkestBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: Image.asset(AppAssets.kBack, width: 24, height: 24),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Job Details',
//           style: TextStyle(color: AppColors.kWhite, fontSize: 18),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 16),
//             child: Center(
//               child: Text("Need Support?",
//                   style: TextStyle(color: Colors.lightBlue)),
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _buildHeaderCard(),
//                   const SizedBox(height: 16),
//                   _buildShiftCard(),
//                   const SizedBox(height: 16),
//                   _buildLocationCard(),
//                   const SizedBox(height: 16),
//                   _buildCheckInCard(),
//                   const SizedBox(height: 8),
//                   _buildManagerCard(),
//                   const SizedBox(height: 80),
//                 ],
//               ),
//             ),
//           ),
//           _buildBottomSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderCard() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF141927),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   dummyJob['title']!,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(dummyJob['name']!,
//                         style: const TextStyle(color: Colors.white70)),
//                     const SizedBox(width: 6),
//                     const Text("Actor", style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Text(
//                       "Job Details",
//                       style: TextStyle(color: Colors.lightBlue),
//                     ),
//                     const SizedBox(width: 4),
//                     Image.asset(
//                       AppAssets.kShare,
//                       width: 16,
//                       height: 16,
//                       color: Colors.lightBlue,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               Text(
//                 dummyJob['rate']!,
//                 style: const TextStyle(
//                     color: Colors.cyanAccent,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildShiftCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1F2E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Shift",
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//               Text("In Progress",
//                   style: TextStyle(color: Colors.lightBlueAccent)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           const Text("Start Time  Today, 9:00 AM",
//               style: TextStyle(color: Colors.white70)),
//           const SizedBox(height: 12),
//           Center(
//             child: Text(
//               controller.timerText,
//               style: const TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1F2E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Live Location Alerts",
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//               Icon(Icons.info_outline, color: Colors.white30, size: 18),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: const [
//               Icon(Icons.circle, size: 12, color: Colors.green),
//               SizedBox(width: 8),
//               Text("You are on track.",
//                   style: TextStyle(color: Colors.white70)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               const Icon(Icons.location_on_outlined,
//                   color: Colors.white70, size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   dummyJob['location']!,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Image.asset(AppAssets.kMap,
//                     height: 160, width: double.infinity, fit: BoxFit.cover),
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.lightBlueAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 12),
//                     ),
//                     child: const Text("Get Directions",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCheckInCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1F2E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Image.asset(AppAssets.kCal,
//               width: 24, height: 24, color: Colors.white60),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Check In Selfie", style: TextStyle(color: Colors.white)),
//                 SizedBox(height: 4),
//                 Text("Submitted", style: TextStyle(color: Colors.white38)),
//               ],
//             ),
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: Image.asset(AppAssets.kPer,
//                 width: 40, height: 40, fit: BoxFit.cover),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildManagerCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1F2E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Image.asset(AppAssets.kCal,
//               width: 24, height: 24, color: Colors.white60),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Hitesh Sapara", style: TextStyle(color: Colors.white)),
//                 SizedBox(height: 4),
//                 Text("Reporting Manager",
//                     style: TextStyle(color: Colors.white38)),
//               ],
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.lightBlueAccent,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             padding: const EdgeInsets.all(8),
//             child: const Icon(Icons.phone, color: Colors.white, size: 16),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomSection() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Divider(color: AppColors.kinput), // No padding applied here
//         Container(
//           padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
//           decoration: const BoxDecoration(
//             color: Color(0xFF0A0E21),
//             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Obx(() => Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Checkbox(
//                         value: controller.checkboxValue.value,
//                         onChanged: (val) {
//                           controller.checkboxValue.value = val ?? false;
//                         },
//                         activeColor: Colors.lightBlueAccent,
//                       ),
//                       const Expanded(
//                         child: Text(
//                           "I confirm that I am intentionally ending my shift before the scheduled time. I understand that this action cannot be undone and may require supervisor approval.",
//                           style: TextStyle(color: Colors.white70, fontSize: 10),
//                         ),
//                       )
//                     ],
//                   )),
//               const SizedBox(height: 12),
//               ElevatedButton(
//                 onPressed: controller.checkboxValue.value
//                     ? controller.toggleApproval
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightBlueAccent,
//                   disabledBackgroundColor: AppColors.kSkyBlue,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   minimumSize: const Size.fromHeight(40),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text("Close My Shift",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
