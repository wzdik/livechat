import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kedelai_hub/app/data/user_model.dart';
import 'package:kedelai_hub/app/services/service_user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  RxBool isLoading = true.obs; // Status loading
  Rx<String> firstNameController = ''.obs;
  Rx<String> lastNameController = ''.obs;
  Rx<String> dateOfBirthController = ''.obs;
  Rx<String> selectedRole = ''.obs;

  final emailController = ''.obs;
  final passwordController = TextEditingController();
  final ServiceUserApi _serviceUserApi = ServiceUserApi();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();

  @override
  void onInit() {
    super.onInit();
    fetchUser(); // Panggil fetchUser saat inisialisasi
  }

  Future<void> fetchUser() async {
    isLoading.value = true; // Mulai loading
    String? id_auth = _prefs.getString('user_token');
    if (id_auth == null) {
      print("User token tidak ditemukan");
      isLoading.value = false; // Selesai loading meski gagal
      return;
    }
    try {
      var response = await _serviceUserApi.getUserByIdAuth(id_auth);
      if (response == null) {
        print("Gagal mendapatkan data user");
        isLoading.value = false; // Selesai loading meski gagal
        return;
      }
      Map<String, dynamic> responseData;
      if (response is String) {
        responseData = json.decode(response as String);
      } else {
        responseData = response;
      }
      loadUserData(responseData);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false; // Selesai loading
    }
  }

  void loadUserData(Map<String, dynamic> responseData) {
    var user = userFromJson(json.encode(responseData));
    firstNameController.value = user.firstName;
    lastNameController.value = user.lastName;
    dateOfBirthController.value = user.dateOfBirth.toIso8601String();
    emailController.value = user.email;
    selectedRole.value = user.role;
  }
}
