import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _service = AdminService();

  List<dynamic> _users = [];
  bool _isLoading = false;

  List<dynamic> get users => _users;
  bool get isLoading => _isLoading;

  // Search for both Students and Teachers
  Future<void> searchUsers(String query) async {
    _isLoading = true;
    notifyListeners();

    // This calls the service which now fetches BOTH Students and Teachers
    _users = await _service.searchUsers(query);

    _isLoading = false;
    notifyListeners();
  }

  // Link Card: Requires 'type' to know if it's a student or teacher
  Future<String?> linkCard(String userId, String nfcId, String type) async {
    return await _service.linkCardToUser(userId, nfcId, type);
  }
}
