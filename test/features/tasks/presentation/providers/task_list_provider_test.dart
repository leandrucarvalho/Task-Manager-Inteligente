import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager_inteligente/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager_inteligente/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_manager_inteligente/features/tasks/domain/usecases/get_tasks.dart';
import 'package:task_manager_inteligente/features/tasks/presentation/providers/task_dependencies.dart';
import 'package:task_manager_inteligente/features/tasks/presentation/providers/task_list_provider.dart';

class _FakeRepo implements TaskRepository {
  @override
  Future<TaskEntity> createTask(TaskEntity task) => throw UnimplementedError();

  @override
  Future<void> deleteTask(String id) => throw UnimplementedError();

  @override
  Future<List<TaskEntity>> getTasks() => throw UnimplementedError();

  @override
  Future<TaskEntity> updateTask(TaskEntity task) => throw UnimplementedError();
}

class FakeGetTasks extends GetTasks {
  FakeGetTasks(this.result) : super(_FakeRepo());

  final List<TaskEntity> result;

  @override
  Future<List<TaskEntity>> call() async => result;
}

void main() {
  test('taskListProvider carrega tarefas', () async {
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

    final container = ProviderContainer(
      overrides: [
        getTasksProvider.overrideWithValue(FakeGetTasks(tasks)),
      ],
    );

    addTearDown(container.dispose);

    await container.read(taskListProvider.notifier).load();
    final state = container.read(taskListProvider);

    expect(state.hasValue, true);
    expect(state.value, tasks);
  });
}

