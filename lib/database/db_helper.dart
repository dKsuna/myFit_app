import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import '../screens/models/exercise_model.dart';
//import '../screens/models/workout_model.dart';

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
    return openDatabase(
      path,
      version: 2, // bump version to trigger onUpgrade
      onCreate: (db, version) async {
        print('Database created!');
        await _createTables(db);
        //await insertUser(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          print(
              'onUpgrade called: oldVersion $oldVersion to newVersion $newVersion');
          // Drop all existing tables
          await db.execute('DROP TABLE IF EXISTS Users');
          await db.execute('DROP TABLE IF EXISTS ProgressLog');
          await db.execute('DROP TABLE IF EXISTS Routine');
          await db.execute('DROP TABLE IF EXISTS Workouts');
          await db.execute('DROP TABLE IF EXISTS Exercises');

          // Recreate tables
          await _createTables(db);
          //await DBHelper().insertUser(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    //id INTEGER ,
    await db.execute('''
      CREATE TABLE Users (  
        name TEXT PRIMARY KEY,
        age INTEGER,
        gender TEXT,        
        weightKg INTEGER,
        heightFeet TEXT,
        heightInches TEXT,
        goal TEXT,
        experienceLevel TEXT,
        physicalIssues TEXT,
        daysForWorkout TEXT,
        equipmentAvailable TEXT
        
      );
    ''');

    await db.execute('''
      CREATE TABLE ProgressLog (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        dateStarted TEXT,
        logDate TEXT,
        gender TEXT,
        weight REAL,
        chest REAL,
        waist REAL,
        arms REAL,
        FOREIGN KEY (userId) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Routine (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        dateStarted TEXT,
        routineData TEXT,
        FOREIGN KEY (userId) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Workouts (        
        userId INTEGER PRIMARY KEY,
        workoutName TEXT,
        duration INTEGER,
        date TEXT,
        day TEXT,
        type TEXT,
        exercises TEXT,
        FOREIGN KEY (userId) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        gender TEXT,
        description TEXT,
        bodyPart TEXT,
        equipment TEXT,
        category TEXT,
        physicalIssues TEXT,
        sets INTEGER,
        reps TEXT
      );
    ''');
  }

  // Insert a new User into the Users table
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    try {
      return await db.insert(
        'Users',
        user,
        conflictAlgorithm: ConflictAlgorithm.replace,
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
      return result.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserByName(String userName) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'name = ?',
      whereArgs: [userName],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('User Name not Found');
    }
  }
}
