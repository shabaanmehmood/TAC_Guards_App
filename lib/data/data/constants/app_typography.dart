// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AppTypography {

  
//   static double get screenWidth => Get.width;
//   // Light.
//   static TextStyle kLight14 = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//   );
//   static TextStyle kLight16 = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 16,
//   );
//   static TextStyle kLight30 = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 30 ,
//   );
//   // Bold.
//   static TextStyle kBold14 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 14 ,
//   );
//   static TextStyle kBold15 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 14 ,
//     color: Colors.white,
//   );
//   static TextStyle kBold16 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 16 ,
//   );
//   static TextStyle kBold17 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 16 ,
//     color: Colors.white,
//   );
//   static TextStyle kBold18 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 18 ,
//   );
//   static TextStyle kBold20 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 20 ,
//   );
//   static TextStyle kBold21 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 20 ,
//     color: Colors.white,
//   );
//    static TextStyle kBold24 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 24 ,
//   );
//   static TextStyle kBold25 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 24 ,
//     color: Colors.white,
//   );
//   static TextStyle kBold32 = TextStyle(
//     fontWeight: FontWeight.w700,
//     fontSize: 32 ,
//   );

//     // custom 
//    static TextStyle get customkLight14 {
//     // Calculate a responsive font size
//     // For example, 3.5% of the screen width
//     final double responsiveFontSize = screenWidth * 0.035; 

//     return TextStyle(
//       fontSize: responsiveFontSize,
//       fontWeight: FontWeight.w300,
//       // Add other style properties here
//     );
//   }

//   // Define other responsive text styles
//   static TextStyle get customkBold24 {
//     final double responsiveFontSize = screenWidth * 0.06;
//     return TextStyle(
//       fontSize: responsiveFontSize,
//       fontWeight: FontWeight.bold,
//     );
//   }

//    static TextStyle get customkBold16 {
//     // You can adjust this factor (0.04) to change the scaling.
//     // A factor of 0.04 means the font size will be 4% of the screen width.
//     final double responsiveFontSize = screenWidth * 0.04;

//     return TextStyle(
//       fontSize: responsiveFontSize,
//       fontWeight: FontWeight.bold,
//       // Add other style properties here if needed
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static double get screenWidth => Get.width;

  // --- Light ---
  static TextStyle kLight14 = GoogleFonts.outfit(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static TextStyle kLight16 = GoogleFonts.outfit(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
  static TextStyle kLight30 = GoogleFonts.outfit(
    fontWeight: FontWeight.w400,
    fontSize: 30,
  );

  // --- Bold ---
  static TextStyle kBold14 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );
  static TextStyle kBold15 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: Colors.white,
  );
  static TextStyle kBold16 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );
  static TextStyle kBold17 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: Colors.white,
  );
  static TextStyle kBold18 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );
  static TextStyle kBold20 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );
  static TextStyle kBold21 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Colors.white,
  );
  static TextStyle kBold24 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );
  static TextStyle kBold25 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: Colors.white,
  );
  static TextStyle kBold32 = GoogleFonts.outfit(
    fontWeight: FontWeight.w700,
    fontSize: 32,
  );

  // --- Custom responsive text styles ---
  static TextStyle get customkLight14 {
    final double responsiveFontSize = screenWidth * 0.035;
    return GoogleFonts.outfit(
      fontSize: responsiveFontSize,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle get customkBold24 {
    final double responsiveFontSize = screenWidth * 0.06;
    return GoogleFonts.outfit(
      fontSize: responsiveFontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get customkBold16 {
    final double responsiveFontSize = screenWidth * 0.04;
    return GoogleFonts.outfit(
      fontSize: responsiveFontSize,
      fontWeight: FontWeight.bold,
    );
  }
}
