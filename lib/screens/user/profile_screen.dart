import 'package:bookify/providers/rental_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rentals = Provider.of<RentalProvider>(context).rentals;

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: rentals.isEmpty
            ? const Center(child: Text("No rental history yet."))
            : ListView.builder(
                itemCount: rentals.length,
                itemBuilder: (context, index) {
                  final rental = rentals[index];
                  return Card(
                    child: ListTile(
                      title: Text(rental.bookTitle),
                      subtitle: Text(
                          "Rented on: ${rental.date.toLocal()}".split(' ')[0]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
