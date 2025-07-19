import 'package:flutter/material.dart';
import '../mock/mocked_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _role;

  String? get role => _role;
  bool get isAuthenticated => _role != null;

  Future<bool> login(String email, String password) async {
    if (mockedUsers.containsKey(email) &&
        mockedUsers[email]!['password'] == password) {
      _role = mockedUsers[email]!['role'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', _role!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('role')) {
      _role = prefs.getString('role');
      notifyListeners();
    }
  }
}