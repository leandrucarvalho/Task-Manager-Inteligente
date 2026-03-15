import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_api_service.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required TaskApiService apiService,
    required TaskLocalDataSource localDataSource,
    this.useLocalStorage = false,
  })  : _apiService = apiService,
        _localDataSource = localDataSource;

  final TaskApiService _apiService;
  final TaskLocalDataSource _localDataSource;
  final bool useLocalStorage;

  @override
  Future<List<TaskEntity>> getTasks() async {
    final models = useLocalStorage
        ? await _localDataSource.getTasks()
        : await _apiService.getTasks();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    final created = useLocalStorage
        ? await _localDataSource.createTask(model)
        : await _apiService.createTask(model);
    return created.toEntity();
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    final updated = useLocalStorage
        ? await _localDataSource.updateTask(model)
        : await _apiService.updateTask(model);
    return updated.toEntity();
  }

  @override
  Future<void> deleteTask(String id) {
    if (useLocalStorage) {
      return _localDataSource.deleteTask(id);
    }
    return _apiService.deleteTask(id);
  }
}
