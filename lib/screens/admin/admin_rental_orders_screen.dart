import 'package:bookify/models/rental_model.dart';
import 'package:bookify/providers/rental_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRentalOrdersScreen extends StatelessWidget {
  const AdminRentalOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rentalProvider = Provider.of<RentalProvider>(context);
    final rentals = rentalProvider.rentals;

    return Scaffold(
      appBar: AppBar(title: const Text("Rental Orders")),
      body: rentals.isEmpty
          ? const Center(child: Text("No rental orders yet."))
          : ListView.builder(
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                return Card(
                  child: ListTile(
                    title: Text(rental.bookTitle),
                    subtitle: Text(
                      "Date: ${rental.date.toLocal().toString().split(' ')[0]}\nStatus: ${rental.status.name}",
                    ),
                    trailing: DropdownButton<RentalStatus>(
                      value: rental.status,
                      onChanged: (status) {
                        if (status != null) {
                          rentalProvider.updateStatus(rental.id, status);
                        }
                      },
                      items: RentalStatus.values
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name),
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
