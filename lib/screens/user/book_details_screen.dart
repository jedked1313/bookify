import 'package:bookify/providers/book_provider.dart';
import 'package:bookify/screens/user/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatelessWidget {
  final String bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final book = Provider.of<BookProvider>(context).getById(bookId);

    if (book == null) {
      return const Scaffold(body: Center(child: Text("Book not found")));
    }

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(book.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
            Text("by ${book.author}", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text("Rating: ⭐ ${book.rating}"),
            const SizedBox(height: 16),
            Text(book.description),
            const SizedBox(height: 16),
            Text("Availability: ${book.isAvailable ? 'Available' : 'Not Available'}"),
            const Spacer(),
            if (book.isAvailable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(book: book),
                      ),
                    );
                  },
                  child: const Text("Rent Book"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
