import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tac/dataproviders/api_service.dart';
import '../models/getUserById_model.dart';
import '../models/userdata_model.dart';

class UserController extends GetxController {
  Rxn<Data> userData = Rxn<Data>();
  final RxnString accessToken = RxnString();
  final RxnString accountId = RxnString();
  final RxString accountType = 'guard'.obs;
  late MyApIService apiService;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiService = MyApIService();
  }

  void setUser(Data data) {
    userData.value = data;
    accountId.value ??= data.id;
  }

  void setAuthentication({
    required String? token,
    required String? id,
    String type = 'guard',
  }) {
    accessToken.value = token;
    accountId.value = id;
    accountType.value = type.toLowerCase();
  }

  void clearUser() {
    userData.value = null;
    accessToken.value = null;
    accountId.value = null;
    accountType.value = 'guard';
  }

  Future<void> getUserData({String? userId}) async {
    try {
      final response = await apiService.getUserByID(userId ?? userData.value?.id ?? '');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final userData = GetUserById.fromJson(json).data;

        if (userData != null) {
          setUser(userData);
          debugPrint('User data refreshed successfully');
        } else {
          clearUser();
          debugPrint('No user data received');
        }
      } else {
        clearUser();
        debugPrint('Error fetching user data: ${response.statusCode}');
      }
    } catch (e) {
      clearUser();
      debugPrint('Exception while fetching user data: $e');
    }
  }

  bool get isLoggedIn => userData.value != null;

}
