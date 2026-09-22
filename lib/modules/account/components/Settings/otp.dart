import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/account/components/Settings/reset.dart';

import '../../../../dataproviders/api_service.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;
  final UserController userController = Get.put(UserController());
  //Enter OTP Screen usage things
  var otpCode = ''.obs; // Holds the entered OTP
  List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes =
  List.generate(4, (index) => FocusNode());


  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 30;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  //verify OTP
  Future<void> verifyOtp() async {
      final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.verifyOtp(
          userController.userData.value!.email.toString(),
          otpControllers.map((controller) => controller.text).join().toString(),
        );

        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.to(() => ResetPasswordScreen());
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error verify Otp failed: ${response.body}');
        }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: const Text("Update Password",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.kinput, size: 16),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Get.back();
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColors.kgrey, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              "Enter OTP",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter OTP received at your registered email",
              style: TextStyle(color: AppColors.kinput, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 40,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: AppColors.kSkyBlue),
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  child: TextFormField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.kWhite, fontSize: 18),
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 4) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (otpControllers.every((controller) => controller.text.isNotEmpty)) {
                    verifyOtp();
                  } else {
                    Get.snackbar("Error", "Please enter all OTP digits",
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text("Verify Account",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: _canResend
                  ? GestureDetector(
                      onTap: () {
                        startTimer();
                      },
                      child: const Text("Resend OTP",
                          style: TextStyle(color: AppColors.kSkyBlue)),
                    )
                  : RichText(
                      text: TextSpan(
                        text: 'Re-try in ',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                        children: [
                          TextSpan(
                            text:
                                '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: AppColors.kSkyBlue),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
