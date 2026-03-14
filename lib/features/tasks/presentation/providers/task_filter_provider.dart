import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import 'task_list_provider.dart';

final taskSearchQueryProvider = StateProvider<String>((ref) => '');
final taskStatusFilterProvider = StateProvider<TaskStatus?>((ref) => null);

final filteredTasksProvider = Provider<AsyncValue<List<TaskEntity>>>((ref) {
  final listAsync = ref.watch(taskListProvider);
  final query = ref.watch(taskSearchQueryProvider).trim().toLowerCase();
  final status = ref.watch(taskStatusFilterProvider);

  return listAsync.whenData((tasks) {
    Iterable<TaskEntity> filtered = tasks;

    if (query.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      });
    }

    if (status != null) {
      filtered = filtered.where((task) => task.status == status);
    }

    final result = filtered.toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  });
});
