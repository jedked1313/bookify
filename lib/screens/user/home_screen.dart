import 'package:bookify/providers/auth_provider.dart';
import 'package:bookify/providers/book_provider.dart';
import 'package:bookify/providers/theme_provider.dart';
import 'package:bookify/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookify"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/profile');
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: const Text(
                'User Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                context.push('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.nightlight_round),
              title: const Text('Night Mode'),
              onTap: () {
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              onTap: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout(context: context);
                context.push('/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search by title or author",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (value) => bookProvider.setSearchQuery(value),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context).themeData.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                ),
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: bookProvider.books.length,
                itemBuilder: (context, index) {
                  return BookCard(
                    book: bookProvider.books[index],
                    onTap: () {
                      context.push('/book/${bookProvider.books[index].id}');
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
