import 'package:sqflite/sqflite.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_priority_suggestion.dart';
import '../datasources/task_local_db.dart';

class TaskAiCacheDataSource {
  TaskAiCacheDataSource({required TaskLocalDb db}) : _db = db;

  final TaskLocalDb _db;

  Future<TaskPrioritySuggestion?> getSuggestion(String key) async {
    final database = await _db.database;
    final rows = await database.query(
      'ai_priority_cache',
      where: 'cacheKey = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final row = rows.first;
    final priorityIndex = row['priority'] as int;
    final reason = row['reason'] as String;
    final sourceName = row['source'] as String;

    return TaskPrioritySuggestion(
      priority: TaskPriority.values[priorityIndex],
      reason: reason,
      source: SuggestionSource.values.byName(sourceName),
    );
  }

  Future<void> saveSuggestion(
    String key,
    TaskPrioritySuggestion suggestion,
  ) async {
    final database = await _db.database;
    await database.insert(
      'ai_priority_cache',
      {
        'cacheKey': key,
        'priority': suggestion.priority.index,
        'reason': suggestion.reason,
        'source': suggestion.source.name,
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

