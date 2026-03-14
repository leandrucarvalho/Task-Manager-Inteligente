import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_api_service.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required TaskApiService apiService}) : _apiService = apiService;

  final TaskApiService _apiService;

  @override
  Future<List<TaskEntity>> getTasks() async {
    final models = await _apiService.getTasks();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    final created = await _apiService.createTask(model);
    return created.toEntity();
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    final updated = await _apiService.updateTask(model);
    return updated.toEntity();
  }

  @override
  Future<void> deleteTask(String id) {
    return _apiService.deleteTask(id);
  }
}
