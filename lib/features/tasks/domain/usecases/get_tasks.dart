import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  GetTasks(this._repository);

  final TaskRepository _repository;

  Future<List<TaskEntity>> call() {
    return _repository.getTasks();
  }
}

