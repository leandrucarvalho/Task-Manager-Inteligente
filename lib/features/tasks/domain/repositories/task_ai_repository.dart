import '../entities/task_priority_suggestion.dart';

abstract class TaskAiRepository {
  Future<TaskPrioritySuggestion> suggestPriority({
    required String title,
    required String description,
  });
}

