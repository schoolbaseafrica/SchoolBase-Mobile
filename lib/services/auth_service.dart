import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://api.staging.schoolbase.africa";

  Future<String?> login(String email, String password) async {
    // Backdoor for testing
    if (email.trim() == 'gate@school.com' && password == 'gateman1') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'fake-gateman-token');
      await prefs.setString('user_role', 'gateman');
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String? token = data['access_token']?.toString();
        if (token == null && data['data'] != null) {
          token = data['data']['access_token']?.toString();
        }

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await _fetchAndSaveRole(token);
          return null;
        }
      }
      return "Login failed. Check credentials.";
    } catch (e) {
      return 'Connection Error: $e';
    }
  }

  Future<void> _fetchAndSaveRole(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String role = 'student';
        var userData = (data['data'] != null) ? data['data'] : data;
        if (userData['role'] != null) {
          List roles = (userData['role'] is List)
              ? userData['role']
              : [userData['role']];
          if (roles.isNotEmpty) role = roles.first.toString().toLowerCase();
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', role);
        await prefs.setString(
          'user_name',
          "${userData['first_name']} ${userData['last_name']}",
        );
      }
    } catch (e) {
      print("Role error: $e");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
