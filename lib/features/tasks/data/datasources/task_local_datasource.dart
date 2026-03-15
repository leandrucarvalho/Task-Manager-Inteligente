import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';
import 'task_local_db.dart';

class TaskLocalDataSource {
  TaskLocalDataSource({required TaskLocalDb db}) : _db = db;

  final TaskLocalDb _db;

  Future<List<TaskModel>> getTasks() async {
    final database = await _db.database;
    final rows = await database.query(
      'tasks',
      orderBy: 'createdAt DESC',
    );
    return rows.map(TaskModel.fromDb).toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final database = await _db.database;
    await database.insert(
      'tasks',
      task.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return task;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final database = await _db.database;
    await database.update(
      'tasks',
      task.toDb(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    return task;
  }

  Future<void> deleteTask(String id) async {
    final database = await _db.database;
    await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
