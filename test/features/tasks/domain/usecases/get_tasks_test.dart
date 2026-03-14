import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_manager_inteligente/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager_inteligente/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_manager_inteligente/features/tasks/domain/usecases/get_tasks.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late GetTasks usecase;

  setUp(() {
    repository = MockTaskRepository();
    usecase = GetTasks(repository);
  });

  test('deve retornar lista de tarefas', () async {
    final tasks = [
      TaskEntity(
        id: '1',
        title: 'Task 1',
        description: 'Desc',
        priority: TaskPriority.low,
        status: TaskStatus.todo,
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

    when(() => repository.getTasks()).thenAnswer((_) async => tasks);

    final result = await usecase();

    expect(result, tasks);
    verify(() => repository.getTasks()).called(1);
  });
}
