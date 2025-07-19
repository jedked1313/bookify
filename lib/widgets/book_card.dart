import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(book.imageUrl, width: 50, fit: BoxFit.cover),
        title: Text(book.title),
        subtitle: Text('${book.author} • ⭐ ${book.rating}'),
        trailing: Icon(book.isAvailable ? Icons.check : Icons.close,
            color: book.isAvailable ? Colors.green : Colors.red),
        onTap: onTap,
      ),
    );
  }
}