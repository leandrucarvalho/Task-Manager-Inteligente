import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import 'task_dependencies.dart';

class TaskListNotifier extends StateNotifier<AsyncValue<List<TaskEntity>>> {
  TaskListNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _ref.read(getTasksProvider).call();
      state = AsyncValue.data(tasks);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final taskListProvider = StateNotifierProvider<TaskListNotifier, AsyncValue<List<TaskEntity>>>(
  (ref) => TaskListNotifier(ref),
);

