import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_filter_provider.dart';

class TaskSearchField extends ConsumerWidget {
  const TaskSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (value) => ref.read(taskSearchQueryProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Buscar tarefas...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

