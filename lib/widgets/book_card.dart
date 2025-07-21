import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  book.imageUrl,
                  width: 120,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(book.author,
                        style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 25),
                    Text(
                      'Rating: ⭐ ${book.rating}',
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  ],
                ),
              ),
              Icon(book.isAvailable ? Icons.check : Icons.close,
                  color: book.isAvailable ? Colors.green : Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
