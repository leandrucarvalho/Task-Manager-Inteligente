import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import 'task_dependencies.dart';

class TaskPrioritySuggestionNotifier
    extends StateNotifier<AsyncValue<TaskPriority?>> {
  TaskPrioritySuggestionNotifier(this._ref)
      : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> suggest({
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty && description.trim().isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final result = await _ref.read(suggestTaskPriorityProvider).call(
            title: title,
            description: description,
          );
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final taskPrioritySuggestionProvider = StateNotifierProvider.autoDispose<
    TaskPrioritySuggestionNotifier, AsyncValue<TaskPriority?>>(
  (ref) => TaskPrioritySuggestionNotifier(ref),
);
