import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/auth_controller.dart';

class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  var selectedRole = 'Penjual'.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordVisible = false.obs;
  final AuthController _authController = Get.put(AuthController());

  void Register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String firstName = firstNameController.text;
    String LastName = lastNameController.text;
    String dateOfBirth = dateOfBirthController.text;
    String role = selectedRole.string;
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
          'Information!', 'Please enter username and email and password!',
          backgroundColor: Colors.grey);
      return;
    }
    await _authController.registerUser(
        email, password, firstName, LastName, dateOfBirth, role);
  }

  bool getIsloading() {
    return _authController.isLoading.value;
  }
}
