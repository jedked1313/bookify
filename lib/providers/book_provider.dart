import 'package:flutter/material.dart';
import 'package:bookify/models/book_model.dart';
import 'package:bookify/helper/database_helper.dart';
import 'package:uuid/uuid.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _books = [];

  String _searchQuery = '';
  List<Book> get books => _searchQuery.isEmpty
      ? _books
      : _books
          .where((book) =>
              book.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  double _rating = 3.0;
  double get rating => _rating;

  bool _isAvailable = true;
  bool get isAvailable => _isAvailable;

  // Load books from local SQLite DB
  Future<void> loadBooks() async {
    final data = await DatabaseHelper.instance.getBooks();
    _books.clear();
    _books.addAll(data.map((e) => Book.fromJson(e)));
    notifyListeners();
  }

  /// Add book (admin side)
  Future<void> addBook(Book newBook) async {
    _books.add(newBook);
    notifyListeners();
    await DatabaseHelper.instance.insertBook(newBook.toJson());
  }

  Future<void> saveBook(
    BuildContext context,
    GlobalKey<FormState> formKey,
    Book? existingBook, {
    required TextEditingController titleCtrl,
    required TextEditingController authorCtrl,
    required TextEditingController descCtrl,
    required TextEditingController imageCtrl,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final newBook = Book(
      id: existingBook?.id ?? const Uuid().v4(),
      title: titleCtrl.text.trim(),
      author: authorCtrl.text.trim(),
      description: descCtrl.text.trim(),
      imageUrl: imageCtrl.text.trim(),
      rating: rating,
      isAvailable: isAvailable,
    );

    if (existingBook == null) {
      addBook(newBook);
    } else {
      updateBook(newBook);
    }

    Navigator.pop(context);
  }

  /// Update book
  Future<void> updateBook(Book updated) async {
    final index = _books.indexWhere((book) => book.id == updated.id);
    if (index != -1) {
      _books[index] = updated;
      notifyListeners();
      await DatabaseHelper.instance.updateBook(updated.id, updated.toJson());
    }
  }

  /// Delete book
  Future<void> deleteBook(String id) async {
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
    await DatabaseHelper.instance.deleteBook(id);
  }

  Book? getById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  setRating(double value) {
    _rating = value;
    notifyListeners();
  }

  void checkAvailablity(bool value) {
    _isAvailable = value;
    notifyListeners();
  }
}
