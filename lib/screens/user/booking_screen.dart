import 'package:bookify/providers/rental_provider.dart';
import 'package:flutter/material.dart';
import 'package:bookify/models/book_model.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    var rentalProvider = Provider.of<RentalProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Book: ${book.title}"),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Pick a rental date"),
              subtitle: Text(rentalProvider.selectedDate == null
                  ? "No date selected"
                  : "${rentalProvider.selectedDate!.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => rentalProvider.selectDate(context),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () =>
                  rentalProvider.confirmBooking(context, book.title),
              child: const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
