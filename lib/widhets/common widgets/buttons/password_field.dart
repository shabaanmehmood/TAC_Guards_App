import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data/constants/app_colors.dart';

class CustomPasswordField extends StatelessWidget {
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final String iconPath;
  final bool passwordVisible;
  final VoidCallback onPressed;

  const CustomPasswordField({
    Key? key,
    required this.keyboardType,
    required this.obscureText,
    required this.controller,
    this.inputFormatters,
    required this.hintText,
    required this.iconPath,
    required this.passwordVisible,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.kSkyBlue,
      style: const TextStyle(color: AppColors.kWhite),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        contentPadding: const EdgeInsets.all(15),
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(iconPath, color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
