// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelperSqflite {
//   static final DatabaseHelperSqflite _instance =
//       DatabaseHelperSqflite._internal();
//   static Database? _database;

//   factory DatabaseHelperSqflite() => _instance;

//   DatabaseHelperSqflite._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, 'my_money.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE categories (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title TEXT NOT NULL,
//         color TEXT NOT NULL
//       )
//     ''');
//     await db.execute('''
//       CREATE TABLE expenses (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         categoryId INTEGER,
//         price REAL NOT NULL,
//         date INTEGER NOT NULL,
//         FOREIGN KEY (categoryId) REFERENCES categories(id)
//       )
//     ''');
//   }

//   // Category Methods
//   Future<int> addCategory(Map<String, dynamic> category) async {
//     final db = await database;
//     return await db.insert('categories', category);
//   }

//   Future<List<Map<String, dynamic>>> getCategories() async {
//     final db = await database;
//     return await db.query('categories');
//   }

//   Future<int> deleteCategory(int id) async {
//     final db = await database;
//     return await db.delete(
//       'categories',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   // Expense Methods
//   Future<int> addExpense(Map<String, dynamic> expense) async {
//     final db = await database;
//     return await db.insert('expenses', expense);
//   }

//   Future<List<Map<String, dynamic>>> getExpenses(
//       {int? fromDate, int? toDate}) async {
//     final db = await database;
//     String whereClause = '';
//     List<dynamic> whereArgs = [];

//     if (fromDate != null && toDate != null) {
//       whereClause = 'date BETWEEN ? AND ?';
//       whereArgs = [fromDate, toDate];
//     } else if (fromDate != null) {
//       whereClause = 'date >= ?';
//       whereArgs = [fromDate];
//     } else if (toDate != null) {
//       whereClause = 'date < ?';
//       whereArgs = [toDate];
//     }

//     return await db.query(
//       'expenses',
//       where: whereClause,
//       whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
//       orderBy: 'date DESC, id DESC',
//     );
//   }

//   Future<int> deleteExpense(int id) async {
//     final db = await database;
//     return await db.delete(
//       'expenses',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   // ... (Implement other methods like getHomeInfo, getReport)
// }
