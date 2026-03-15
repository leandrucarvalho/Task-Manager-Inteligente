import '../repositories/task_repository.dart';

class DeleteTask {
  DeleteTask(this._repository);

  final TaskRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteTask(id);
  }
}

