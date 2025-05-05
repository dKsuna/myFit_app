import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:myfit/screens/models/user_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'myfit.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            weightKg REAL,
            heightFeet INTEGER,
            heightInches INTEGER,
            fitnessGoal TEXT,
            experienceLevel TEXT,
            physicalIssues TEXT,
            workoutDays TEXT,
            equipmentAccess TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    var client = await db;
    return await client.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    var client = await db;
    final List<Map<String, dynamic>> maps = await client.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }
}
