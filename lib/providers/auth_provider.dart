import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool _isLoading = false;
  String _role = '';

  bool get isLoading => _isLoading;
  String get role => _role;

  // Check if user is already logged in on app start
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _role = (prefs.getString('user_role') ?? '').toLowerCase();
    notifyListeners();
  }

  // Login Function
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    String? error = await _service.login(email, password);

    if (error == null) {
      // Login Success: Update role from storage
      final prefs = await SharedPreferences.getInstance();
      _role = (prefs.getString('user_role') ?? '').toLowerCase();
    }

    _isLoading = false;
    notifyListeners();
    return error;
  }

  // Logout Function
  Future<void> logout() async {
    await _service.logout();
    _role = '';
    notifyListeners();
  }
}
