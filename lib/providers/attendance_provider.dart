import 'package:flutter/material.dart';
import '../services/attendance_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // --- GATEMAN: MARK ENTRY/EXIT ---
  // Works for both Students and Teachers (backend handles the difference)
  Future<Map<String, dynamic>> markGateEntry(String tagId, String type) async {
    // We don't set global _isLoading here to allow the UI to handle
    // its own "Processing" state (like the orange ripple effect)
    // without rebuilding the entire screen.
    return await _service.markGateAttendance(tagId, type);
  }

  // --- SYNC DATA ---
  // Uploads offline records to the server
  Future<String> syncData() async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.syncOfflineRecords();

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
