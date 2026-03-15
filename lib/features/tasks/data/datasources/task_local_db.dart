import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class TaskLocalDb {
  TaskLocalDb._();

  static final TaskLocalDb instance = TaskLocalDb._();

  static const _dbName = 'tasks.db';
  static const _dbVersion = 1;

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
  }
}
