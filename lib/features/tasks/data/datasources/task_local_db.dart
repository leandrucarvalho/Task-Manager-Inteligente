import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class TaskLocalDb {
  TaskLocalDb._();

  static final TaskLocalDb instance = TaskLocalDb._();

  static const _dbName = 'tasks.db';
  static const _dbVersion = 2;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        priority INTEGER NOT NULL,
        status INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ai_priority_cache (
        cacheKey TEXT PRIMARY KEY,
        priority INTEGER NOT NULL,
        reason TEXT NOT NULL,
        source TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE ai_priority_cache (
          cacheKey TEXT PRIMARY KEY,
          priority INTEGER NOT NULL,
          reason TEXT NOT NULL,
          source TEXT NOT NULL,
          createdAt TEXT NOT NULL
        )
      ''');
    }
  }
}

