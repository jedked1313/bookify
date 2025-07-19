enum RentalStatus { pending, approved, returned }

class Rental {
  final String id;
  final String bookTitle;
  final DateTime date;
  RentalStatus status;

  Rental({
    required this.id,
    required this.bookTitle,
    required this.date,
    this.status = RentalStatus.pending,
  });
}
