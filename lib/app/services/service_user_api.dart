import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceUserApi {
  static const String baseUrl = 'http://192.168.1.118:5000/api/users';

  Future<void> createUser(String idAuth, String email, String FirstName,
      String LastName, String dateOfBirth, String role) async {
    final data = {
      "id_auth": idAuth,
      "firstName": FirstName, // Tambahkan sesuai input pengguna
      "lastName": LastName, // Tambahkan sesuai input pengguna
      "dateOfBirth": dateOfBirth, // Tambahkan sesuai input pengguna
      "role": role, // Tambahkan sesuai input pengguna
      "email": email,
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Data berhasil dikirim ke API');
      } else {
        print('Gagal mengirim data ke API: ${response.body}');
      }
    } catch (error) {
      print('Error mengirim data ke API: $error');
    }
  }

  // GET Request - Mendapatkan User Berdasarkan id_auth
  Future<Map<String, dynamic>?> getUserByIdAuth(String idAuth) async {
    final url = Uri.parse('$baseUrl/$idAuth'); // Pastikan baseUrl valid
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Berhasil, kembalikan data
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // User tidak ditemukan
        print('User not found');
        return null;
      } else {
        // Error dari server
        print('Server error (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      // Error jaringan atau parsing
      print('Request failed: $e');
      return null;
    }
  }
}
