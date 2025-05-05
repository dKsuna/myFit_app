import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'myfit.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        weightKg REAL NOT NULL,
        heightFeet INTEGER NOT NULL,
        heightInches INTEGER NOT NULL,
        fitnessGoal TEXT NOT NULL,
        experienceLevel TEXT NOT NULL,
        physicalIssues TEXT NOT NULL,
        workoutDays TEXT NOT NULL,
        equipmentAccess TEXT NOT NULL
      )
    ''');
  }

  // Insert User
  static Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch User (optional, for testing)
  static Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  static Future<void> copyDatabaseToDownloads() async {
    String dbPath = join(await getDatabasesPath(), 'myfit.db');

    // Path to Downloads folder (Android only)
    Directory downloadsDir = Directory('/storage/emulated/0/Download');
    if (!(await downloadsDir.exists())) {
      print('Downloads folder not found!');
      return;
    }

    String newDbPath = join(downloadsDir.path, 'myfit_copy.db');
    await File(dbPath).copy(newDbPath);

    print('Database copied to: $newDbPath');
  }
}
