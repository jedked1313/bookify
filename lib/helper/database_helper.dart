import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bookify.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // This method is called when the database is created for the first time
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE books (
      id TEXT PRIMARY KEY,
      title TEXT,
      author TEXT,
      description TEXT,
      imageUrl TEXT,
      rating REAL,
      isAvailable INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE rentals (
      id TEXT PRIMARY KEY,
      bookTitle TEXT,
      date TEXT,
      status TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE session (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      token TEXT,
      role TEXT
    )
  ''');
  }

  // Get user role from session
  Future<String?> getRole() async {
    final db = await database;
    final result = await db.query('session', limit: 1);
    if (result.isNotEmpty) {
      return result.first['role'] as String?;
    }
    return null;
  }

  // Rental management methods
  Future<void> insertRental(Map<String, dynamic> rental) async {
    final db = await database;
    await db.insert('rentals', rental);
  }

  Future<List<Map<String, dynamic>>> getRentals() async {
    final db = await database;
    return await db.query('rentals');
  }

  Future<void> updateStatus(String id, String status) async {
    final db = await database;
    await db.update(
      'rentals',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteRental(String id) async {
    final db = await database;
    await db.delete(
      'rentals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete('rentals');
  }

  // Book management methods
  Future<void> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    await db.insert('books', book);
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }

  Future<void> updateBook(String id, Map<String, dynamic> book) async {
    final db = await database;
    await db.update('books', book, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  // Session management methods
  Future<void> insertSession(Map<String, dynamic> session) async {
    final db = await database;
    await db.insert('session', session);
  }

  Future<String?> getToken() async {
    final db = await database;
    final result = await db.query('session', limit: 1);
    if (result.isNotEmpty) {
      return result.first['token'] as String;
    }
    return null;
  }

  Future<void> clearSession() async {
    final db = await database;
    await db.delete('session');
  }
}
