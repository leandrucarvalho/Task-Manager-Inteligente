import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import 'task_dependencies.dart';
import 'task_list_provider.dart';

class TaskCreateNotifier extends StateNotifier<AsyncValue<void>> {
  TaskCreateNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> create(TaskEntity task) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(createTaskProvider).call(task);
      state = const AsyncValue.data(null);
      await _ref.read(taskListProvider.notifier).load();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final taskCreateProvider = StateNotifierProvider<TaskCreateNotifier, AsyncValue<void>>(
  (ref) => TaskCreateNotifier(ref),
);

