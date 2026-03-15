import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  UpdateTask(this._repository);

  final TaskRepository _repository;

  Future<TaskEntity> call(TaskEntity task) {
    return _repository.updateTask(task);
  }
}

