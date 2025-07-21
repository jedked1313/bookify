import 'package:bookify/helper/database_helper.dart';
import 'package:bookify/models/rental_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RentalProvider with ChangeNotifier {
  final List<Rental> _rentals = [];
  List<Rental> get rentals => [..._rentals];

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  Future<void> loadRentals() async {
    final data = await DatabaseHelper().getRentals();
    _rentals.clear();
    _rentals.addAll(data.map((e) => Rental(
          id: e['id'],
          bookTitle: e['bookTitle'],
          date: DateTime.parse(e['date']),
          status: RentalStatus.values.firstWhere(
            (s) => s.name == e['status'],
            orElse: () => RentalStatus.pending,
          ),
        )));
    notifyListeners();
  }

  Future<void> addRentalFromBooking(String bookTitle, DateTime date) async {
    final id = const Uuid().v4();
    final rental = Rental(
      id: id,
      bookTitle: bookTitle,
      date: date,
      status: RentalStatus.pending,
    );
    _rentals.add(rental);
    notifyListeners();

    await DatabaseHelper().insertRental({
      'id': id,
      'bookTitle': bookTitle,
      'date': date.toIso8601String(),
      'status': 'pending',
    });
  }

  Future<void> deleteRental(String id) async {
    _rentals.removeWhere((rental) => rental.id == id);
    notifyListeners();
    await DatabaseHelper().deleteRental(id);
  }

  Future<void> updateStatus(String id, RentalStatus status) async {
    final rental = _rentals.firstWhere((r) => r.id == id);
    rental.status = status;
    notifyListeners();
    await DatabaseHelper().updateStatus(id, status.name);
  }

  Future<void> selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> confirmBooking(BuildContext context, String bookTitle) async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    // Add rental record
    addRentalFromBooking(bookTitle, _selectedDate!);

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Booking Confirmed"),
        content:
            Text("You've booked '$bookTitle' on ${_selectedDate!.toLocal()}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
