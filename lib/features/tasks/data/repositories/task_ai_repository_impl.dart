import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_ai_repository.dart';
import '../datasources/task_ai_service.dart';

class TaskAiRepositoryImpl implements TaskAiRepository {
  TaskAiRepositoryImpl({required TaskAiService service}) : _service = service;

  final TaskAiService _service;

  @override
  Future<TaskPriority> suggestPriority({
    required String title,
    required String description,
  }) {
    return _service.suggestPriority(title: title, description: description);
  }
}
