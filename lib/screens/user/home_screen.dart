import 'package:bookify/models/book_model.dart';
import 'package:bookify/providers/book_provider.dart';
import 'package:bookify/providers/theme_provider.dart';
import 'package:bookify/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    List<Book> books = _searchQuery.isEmpty
        ? bookProvider.books
        : bookProvider.searchBooks(_searchQuery);

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
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
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
                context.go('/');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Search by title or author",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {
                _searchQuery = value;
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCard(
                    book: books[index],
                    onTap: () {
                      context.push('/book/${books[index].id}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
