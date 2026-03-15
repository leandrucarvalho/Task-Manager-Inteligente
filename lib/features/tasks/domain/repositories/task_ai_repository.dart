import '../entities/task_entity.dart';

abstract class TaskAiRepository {
  Future<TaskPriority> suggestPriority({
    required String title,
    required String description,
  });
}
