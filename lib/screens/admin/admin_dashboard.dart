import 'package:bookify/providers/book_provider.dart';
import 'package:bookify/screens/admin/manage_books_screen.dart';
import 'package:bookify/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.books;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: const Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Manage Rentals'),
              onTap: () {
                context.push('/admin/rentals');
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
      body: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.list_alt),
            label: const Text("Manage Rental Orders"),
            onPressed: () {
              context.push('/admin/rentals');
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: books
                  .map(
                    (book) => BookCard(
                      book: book,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManageBookScreen(book: book),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ManageBookScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
