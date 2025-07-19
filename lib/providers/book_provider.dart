import 'package:flutter/material.dart';
import 'package:bookify/models/book_model.dart';
import 'package:bookify/helper/database_helper.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get books => [..._books];

  /// Load books from local SQLite DB
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

  List<Book> searchBooks(String query) {
    return _books
        .where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
