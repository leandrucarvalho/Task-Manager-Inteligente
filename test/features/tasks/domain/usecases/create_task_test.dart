import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_manager_inteligente/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager_inteligente/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_manager_inteligente/features/tasks/domain/usecases/create_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late CreateTask usecase;

  setUp(() {
    repository = MockTaskRepository();
    usecase = CreateTask(repository);
  });

  test('deve criar uma tarefa', () async {
    final task = TaskEntity(
      id: '1',
      title: 'Task 1',
      description: 'Desc',
      priority: TaskPriority.high,
      status: TaskStatus.todo,
      createdAt: DateTime(2024, 1, 1),
    );

    when(() => repository.createTask(task)).thenAnswer((_) async => task);

    final result = await usecase(task);

    expect(result, task);
    verify(() => repository.createTask(task)).called(1);
  });
}

