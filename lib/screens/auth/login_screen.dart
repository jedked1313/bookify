import 'package:bookify/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Welcome to Bookify",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/apple-books.png',
                            height: 150)),
                    const SizedBox(height: 15),
                    Text(
                      "Please login to continue",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) =>
                          value!.isEmpty ? "Email is required" : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? "Password is required" : null,
                    ),
                    const SizedBox(height: 20),
                    if (auth.errorMessage != null)
                      Text(auth.errorMessage!,
                          style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () {
                              auth.login(
                                username: _emailCtrl.text.trim(),
                                password: _passwordCtrl.text.trim(),
                                context: context,
                                formKey: _formKey,
                                emailCtrl: _emailCtrl,
                                passwordCtrl: _passwordCtrl,
                              );
                            },
                      child: auth.isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
