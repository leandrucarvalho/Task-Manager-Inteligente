import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import '../providers/task_filter_provider.dart';

class StatusFilterBar extends ConsumerWidget {
  const StatusFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(taskStatusFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            context,
            label: 'Todas',
            isSelected: selected == null,
            onSelected: () =>
                ref.read(taskStatusFilterProvider.notifier).state = null,
          ),
          _buildChip(
            context,
            label: 'A fazer',
            isSelected: selected == TaskStatus.todo,
            onSelected: () => ref
                .read(taskStatusFilterProvider.notifier)
                .state = TaskStatus.todo,
          ),
          _buildChip(
            context,
            label: 'Em progresso',
            isSelected: selected == TaskStatus.inProgress,
            onSelected: () => ref
                .read(taskStatusFilterProvider.notifier)
                .state = TaskStatus.inProgress,
          ),
          _buildChip(
            context,
            label: 'Concluídas',
            isSelected: selected == TaskStatus.done,
            onSelected: () => ref
                .read(taskStatusFilterProvider.notifier)
                .state = TaskStatus.done,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
