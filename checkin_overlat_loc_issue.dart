// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'check_in_controller.dart';
// import 'dummy_data.dart';

// class CheckInPage extends StatelessWidget {
//   final CheckInController controller = Get.put(CheckInController());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         decoration: BoxDecoration(
//           color: Color(0xFF0E1221),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         padding: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   margin: EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white24,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Confirm Your Check-in',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.local_fire_department,
//                           color: Color.fromRGBO(204, 132, 0, 1), size: 16),
//                       SizedBox(width: 4),
//                       Text(
//                         '10:10',
//                         style: TextStyle(
//                             color: Color.fromRGBO(204, 132, 0, 1),
//                             fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               LinearProgressIndicator(
//                 value: 0.75,
//                 backgroundColor: Colors.white12,
//                 color: Color.fromRGBO(204, 132, 0, 1),
//                 minHeight: 4,
//               ),
//               SizedBox(height: 20),
//               _infoCard(
//                 title: 'Job Details',
//                 subtitle: DummyData.jobTitle,
//                 location: DummyData.jobLocation,
//                 time: DummyData.jobTime,
//               ),
//               SizedBox(height: 12),
//               _locationCard(), // Specific card with error handling
//               SizedBox(height: 20),
//               Row(
//                 children: [
//                   Checkbox(
//                     value: controller.isChecked.value,
//                     onChanged: controller.toggleCheck,
//                     side: BorderSide(color: Color(0xFF00D9F5)),
//                     activeColor: Color(0xFF00D9F5),
//                   ),
//                   Expanded(
//                     child: Text(
//                       'I acknowledge my duty at this location and understand my responsibilities for this shift.',
//                       style: TextStyle(color: Colors.white70, fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: Color(0xFF00D9F5)),
//                         foregroundColor: Color(0xFF00D9F5),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                       ),
//                       onPressed: () => Get.back(),
//                       child: Text('Cancel'),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     flex: 7,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF00D9F5),
//                         foregroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                       ),
//                       onPressed: () {
//                         if (controller.isChecked.value) {
//                           // Perform check-in logic here
//                         } else {
//                           Get.snackbar(
//                             "Acknowledgement Required",
//                             "Please check the box to confirm.",
//                             backgroundColor: Colors.redAccent,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                       child: Text('Confirm Check-in'),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoCard({
//     required String title,
//     required String subtitle,
//     String? location,
//     String? time,
//   }) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Color(0xFF161B2C),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           if (location != null && location.isNotEmpty) ...[
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.location_on, color: Colors.white60, size: 16),
//                 SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     location,
//                     style: TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                 )
//               ],
//             ),
//           ],
//           if (time != null) ...[
//             SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, color: Colors.white60, size: 16),
//                 SizedBox(width: 4),
//                 Text('Today',
//                     style: TextStyle(color: Colors.white70, fontSize: 12)),
//                 SizedBox(width: 8),
//                 Icon(Icons.access_time, color: Colors.white60, size: 16),
//                 SizedBox(width: 4),
//                 Text(time,
//                     style: TextStyle(color: Colors.white70, fontSize: 12)),
//               ],
//             )
//           ]
//         ],
//       ),
//     );
//   }

//   /// "Your Location" card with error message + retry button
//   Widget _locationCard() {
//     bool match = false; // For now hardcoded; replace with actual logic
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Color(0xFF161B2C),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Your Location',
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//               if (!match)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(218, 78, 70, 1).withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.warning_amber_rounded,
//                           size: 14, color: Color.fromRGBO(218, 78, 70, 1)),
//                       Text(' Does Not Match',
//                           style: TextStyle(
//                               color: Color.fromRGBO(218, 78, 70, 1),
//                               fontSize: 12)),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Icon(Icons.location_on, color: Colors.white60, size: 16),
//               SizedBox(width: 4),
//               Expanded(
//                 child: Text(
//                   DummyData.userLocation,
//                   style: TextStyle(color: Colors.white70, fontSize: 12),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(204, 132, 0, 1).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             padding: EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Icon(Icons.warning_amber_rounded,
//                     color: Color.fromRGBO(204, 132, 0, 1), size: 16),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     "You are not at the correct job location. Please move to the assigned area before checking in.",
//                     style: TextStyle(
//                         color: Color.fromRGBO(204, 132, 0, 1), fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 12),
//           Center(
//             child: TextButton.icon(
//               onPressed: () {
//                 // Add retry location logic here
//               },
//               icon: Icon(Icons.refresh, color: Color(0xFF00D9F5)),
//               label: Text(
//                 "Retry Location Detection",
//                 style: TextStyle(color: Color(0xFF00D9F5), fontSize: 12),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
