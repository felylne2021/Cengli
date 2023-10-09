// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'cengli_database.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE groups(
            id TEXT PRIMARY KEY,
            name TEXT
          )
        ''');

    await db.execute(''' 
          CREATE TABLE participants(
            id TEXT PRIMARY KEY,
            group_id TEXT,
            name TEXT
          )
    ''');

    await db.execute('''
          CREATE TABLE expenses(
            id TEXT PRIMARY KEY,
            group_id TEXT,
            amount TEXT,
            category TEXT,
            date TEXT
          )
        ''');
  }

  Future<bool> isDatabaseEmpty() async {
    final database = await _initDatabase();
    final result = await database.rawQuery('SELECT COUNT(*) FROM groups');
    final count = Sqflite.firstIntValue(result);

    return count == 0;
  }
}
