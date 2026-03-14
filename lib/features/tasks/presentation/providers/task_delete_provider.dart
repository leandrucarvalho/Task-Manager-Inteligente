import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_dependencies.dart';
import 'task_list_provider.dart';

class TaskDeleteNotifier extends StateNotifier<AsyncValue<void>> {
  TaskDeleteNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(deleteTaskProvider).call(id);
      state = const AsyncValue.data(null);
      await _ref.read(taskListProvider.notifier).load();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final taskDeleteProvider = StateNotifierProvider<TaskDeleteNotifier, AsyncValue<void>>(
  (ref) => TaskDeleteNotifier(ref),
);
