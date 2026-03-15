import '../entities/task_priority_suggestion.dart';
import '../repositories/task_ai_repository.dart';

class SuggestTaskPriority {
  SuggestTaskPriority(this._repository);

  final TaskAiRepository _repository;

  Future<TaskPrioritySuggestion> call({
    required String title,
    required String description,
  }) {
    return _repository.suggestPriority(title: title, description: description);
  }
}

