import 'package:get/get.dart';

class CheckInController extends GetxController {
  RxBool isChecked = false.obs;

  void toggleCheck(bool? value) {
    isChecked.value = value ?? false;
  }
}
