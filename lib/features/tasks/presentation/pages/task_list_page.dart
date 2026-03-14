import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import '../providers/task_filter_provider.dart';
import '../providers/task_list_provider.dart';
import '../widgets/status_filter_bar.dart';
import '../widgets/task_card.dart';
import '../widgets/task_search_field.dart';
import 'task_create_page.dart';
import 'task_detail_page.dart';

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(filteredTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
          IconButton(
            onPressed: () => ref.read(taskListProvider.notifier).load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: TaskSearchField(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StatusFilterBar(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma tarefa encontrada.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () => _openDetails(context, task),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text('Erro ao carregar tarefas: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreate(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TaskCreatePage()),
    );
  }

  void _openDetails(BuildContext context, TaskEntity task) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
    );
  }
}
