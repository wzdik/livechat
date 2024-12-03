import 'dart:convert';

import 'package:kedelai_hub/app/data/user_model.dart';
import 'package:kedelai_hub/app/modules/login/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kedelai_hub/app/services/service_user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ServiceUserApi _serviceUserApi = ServiceUserApi();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  Rx<String> isPenjual = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? id_auth = _prefs.getString('user_token');
    isLoggedIn.value = _prefs.containsKey('user_token');
    if (id_auth == null) {
      print("User token tidak ditemukan");
      return;
    }
    try {
      var response = await _serviceUserApi.getUserByIdAuth(id_auth);
      if (response == null) {
        print("Gagal mendapatkan data user");
        return;
      }
      Map<String, dynamic> responseData;
      if (response is String) {
        responseData = json.decode(response as String);
      } else
        responseData = response;

      var user = userFromJson(json.encode(responseData));
      print(user);
      isPenjual.value = user.role;
      print(user.role);
      print(user.firstName);
      print(user.idAuth);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> registerUser(String email, String password, String FirstName,
      String LastName, String dateOfBirth, String role) async {
    try {
      isLoading.value = true;

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userToken = _auth.currentUser!.uid;
      // _prefs.setString('user_token', userToken);

      await _serviceUserApi.createUser(
          userToken, email, FirstName, LastName, dateOfBirth, role);

      Get.snackbar(
        'Success',
        'Registration successful',
      );
      Get.off(LoginView());
    } catch (error) {
      Get.snackbar(
        'Error',
        'Registration failed: $error',
      );
      print(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _prefs.setString(
          'user_token', _auth.currentUser!.uid); // Simpan token pengguna
      Get.snackbar(
        'Success',
        'Login berhasil', /*backgroundColor: Colors.grey*/
      );

      isLoggedIn.value = true; // Set status login menjadi true
      await checkLoginStatus();
      Get.offAllNamed(
          '/home'); // Navigasi ke halaman Home dan hapus semua halaman sebelumnya
    } catch (error) {
      Get.snackbar(
        'Error',
        'Login gagal: $error', /*backgroundColor: Colors.grey*/
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    _prefs.remove('user_token');
    isLoggedIn.value = false;
    _auth.signOut();
    Get.offAllNamed('/login');
  }
}
