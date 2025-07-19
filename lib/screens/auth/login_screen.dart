import 'package:bookify/providers/book_provider.dart';
import 'package:bookify/providers/rental_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      if (authProvider.role == 'admin') {
        final bookProvider = BookProvider();
        await bookProvider.loadBooks();
        context.go('/admin');
      } else {
        final rentalProvider = RentalProvider();
        await rentalProvider.loadRentals();
        context.go('/home');
      }
    } else {
      setState(() {
        _errorMessage = "Invalid email or password.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) =>
                      value!.isEmpty ? "Email is required" : null,
                ),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? "Password is required" : null,
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
