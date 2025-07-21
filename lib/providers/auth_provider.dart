
import 'package:bookify/helper/database_helper.dart';
import 'package:bookify/mock/mocked_users.dart';
import 'package:bookify/providers/book_provider.dart';
import 'package:bookify/providers/rental_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore_for_file: use_build_context_synchronously
class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _role;
  String? get role => _role;
  bool get isAuthenticated => _role != null;

  // This is the token that will be used for authentication
  String? _token;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login({
    required String username,
    required String password,
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailCtrl,
    required TextEditingController passwordCtrl,
  }) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    _setError(null);

    if (mockedUsers.containsKey(username) &&
        mockedUsers[username]!['password'] == password) {
      // Simulate token
      final fakeToken = 'abc123xyz';
      _token = fakeToken;
      _role = mockedUsers[username]!['role'];

      await DatabaseHelper.instance.clearSession();
      await DatabaseHelper.instance.insertSession({
        'token': fakeToken,
        'role': _role,
      });

      notifyListeners();
      _setLoading(false);

      // Navigation to the appropriate screen based on role
      if (_role == 'admin') {
        final bookProvider = BookProvider();
        await bookProvider.loadBooks();
        context.go('/admin');
      } else {
        final rentalProvider = RentalProvider();
        await rentalProvider.loadRentals();
        context.go('/home');
      }
    } else {
      _setError("Invalid email or password.");
      _setLoading(false);
    }
  }

  Future<void> logout({
    required BuildContext context,
  }) async {
    _token = null;
    await DatabaseHelper.instance.clearSession();
    context.go('/login');
    notifyListeners();
  }

  Future<void> tryAutoLogin(BuildContext context) async {
    final token = await DatabaseHelper.instance.getToken();
    final role = await DatabaseHelper.instance.getRole();

    if (token != null) {
      _token = token;
      _role = role;
      notifyListeners();

      if (_role == 'admin') {
        final bookProvider = BookProvider();
        await bookProvider.loadBooks();
        context.go('/admin');
      } else {
        final rentalProvider = RentalProvider();
        await rentalProvider.loadRentals();
        context.go('/home');
      }
    } else {
      context.go('/login');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
