import 'package:bookify/providers/rental_provider.dart';
import 'package:flutter/material.dart';
import 'package:bookify/models/book_model.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final Book book;
  const BookingScreen({super.key, required this.book});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;

  void _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _confirmBooking() {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date")),
      );
      return;
    }
    Provider.of<RentalProvider>(context, listen: false)
        .addRentalFromBooking(widget.book.title, selectedDate!);
    // Store booking in provider/local db
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Booking Confirmed"),
        content: Text(
            "You've booked '${widget.book.title}' on ${selectedDate!.toLocal()}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop(); // Go back to Home
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Book: ${widget.book.title}"),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Pick a rental date"),
              subtitle: Text(selectedDate == null
                  ? "No date selected"
                  : "${selectedDate!.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _confirmBooking,
              child: const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
