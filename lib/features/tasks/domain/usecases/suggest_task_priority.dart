import '../entities/task_entity.dart';
import '../repositories/task_ai_repository.dart';

class SuggestTaskPriority {
  SuggestTaskPriority(this._repository);

  final TaskAiRepository _repository;

  Future<TaskPriority> call({
    required String title,
    required String description,
  }) {
    return _repository.suggestPriority(title: title, description: description);
  }
}
