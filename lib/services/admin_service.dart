import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  final String baseUrl = "https://api.staging.schoolbase.africa";

  // --- SEARCH USERS (Students & Teachers) ---
  Future<List<dynamic>> searchUsers(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return [];

    List<dynamic> allResults = [];
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      String searchParam = query.isEmpty ? "" : "?search=$query";

      // Fetch BOTH Students and Teachers
      final responses = await Future.wait([
        http.get(
          Uri.parse('$baseUrl/api/v1/students$searchParam'),
          headers: headers,
        ),
        http.get(
          Uri.parse('$baseUrl/api/v1/teachers$searchParam'),
          headers: headers,
        ),
      ]);

      // Process Both
      _processResponse(responses[0], 'student', allResults);
      _processResponse(responses[1], 'teacher', allResults);

      return allResults;
    } catch (e) {
      return [];
    }
  }

  // --- LINK CARD (Handles Both) ---
  Future<String?> linkCardToUser(
    String userId,
    String nfcId,
    String userType,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      // Determine endpoint based on type
      String endpoint = userType.toLowerCase() == 'teacher'
          ? 'teachers'
          : 'students';

      final response = await http.patch(
        Uri.parse('$baseUrl/api/v1/$endpoint/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'nfc_id': nfcId}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return null;
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? "Failed to link card.";
      }
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  void _processResponse(
    http.Response response,
    String type,
    List<dynamic> list,
  ) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List<dynamic> rawData = [];
      if (decoded is Map && decoded['data'] != null) {
        if (decoded['data'] is List) {
          rawData = decoded['data'];
        } else if (decoded['data'] is Map && decoded['data']['data'] != null) {
          rawData = decoded['data']['data'];
        }
      } else if (decoded is List) {
        rawData = decoded;
      }

      for (var item in rawData) {
        list.add({
          'id': item['id'],
          'name': "${item['first_name']} ${item['last_name']}",
          'school_id': item['matric_no'] ?? item['email'] ?? 'ID:${item['id']}',
          'type': type, // 'student' or 'teacher'
        });
      }
    }
  }
}
