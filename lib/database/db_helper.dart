import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../screens/models/exercise_model.dart';
import '../screens/models/workout_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // Initialize database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'myFit.db');
    return openDatabase(path, onCreate: (db, version) async {
      // Create Users table
      await db.execute('''
        CREATE TABLE Users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          age INTEGER,
          gender TEXT,
          weight INTEGER,
          goal TEXT,
          daysForWorkout TEXT,
          equipmentAvailable INTEGER,
          physicalIssues TEXT
        );
      ''');

      // Create ProgressLog table
      await db.execute('''
        CREATE TABLE ProgressLog (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          dateStarted TEXT,
          logDate TEXT,
          weight REAL,
          chest REAL,
          waist REAL,
          arms REAL,
          FOREIGN KEY (userId) REFERENCES Users(id)
        );
      ''');

      // Create Routine table
      await db.execute('''
        CREATE TABLE Routine (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          dateStarted TEXT,
          routineData TEXT,
          FOREIGN KEY (userId) REFERENCES Users(id)
        );
      ''');

      // Create Workouts table
      await db.execute('''
        CREATE TABLE Workouts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          workoutName TEXT,
          duration INTEGER,
          date TEXT,
          FOREIGN KEY (userId) REFERENCES Users(id)
        );
      ''');

      // Create Exercises table
      await db.execute('''
        CREATE TABLE Exercises (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          equipmentRequired TEXT,
          physicalIssues TEXT
        );
      ''');
    }, version: 1);
  }

  // Insert a new User into the Users table
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    try {
      return await db.insert(
        'Users',
        user,
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Replace if the user already exists
      );
    } catch (e) {
      print("Error inserting user: $e");
      return -1;
    }
  }

  // Insert a Routine into the Routine table
  Future<int> insertRoutine(Map<String, dynamic> routine) async {
    final db = await database;
    try {
      return await db.insert(
        'Routine',
        routine,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting routine: $e");
      return -1;
    }
  }

  // Insert a ProgressLog into the ProgressLog table
  Future<int> insertProgressLog(Map<String, dynamic> log) async {
    final db = await database;
    try {
      return await db.insert(
        'ProgressLog',
        log,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting progress log: $e");
      return -1;
    }
  }

  // Insert a Workout into the Workouts table
  Future<int> insertWorkout(Map<String, dynamic> workout) async {
    final db = await database;
    try {
      return await db.insert(
        'Workouts',
        workout,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting workout: $e");
      return -1;
    }
  }

  // Get all Progress Logs for a specific User
  Future<List<Map<String, dynamic>>> getProgressLogsByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'ProgressLog',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // Get all Routines for a specific User
  Future<List<Map<String, dynamic>>> getRoutinesByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'Routine',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // Get User details by User ID
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first; // Return the first matching user
    } else {
      return null; // Return null if no user is found
    }
  }

  // Get filtered exercises based on equipment and physical issues
  Future<List<Exercise>> getFilteredExercises({
    required bool hasEquipment,
    required String physicalIssues,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'Exercises',
      where:
          'equipmentRequired = ? AND (physicalIssues LIKE ? OR physicalIssues IS NULL)',
      whereArgs: [hasEquipment ? '1' : '0', '%$physicalIssues%'],
    );

    return List.generate(result.length, (i) {
      return Exercise.fromMap(result[i]);
    });
  }
}
