import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/widgets/success_snackbar.dart';
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
    final themeMode = ref.watch(themeModeProvider);

    final switchKey = tasksAsync.when(
      data: (_) => 'data',
      loading: () => 'loading',
      error: (_, __) => 'error',
    );

    final content = tasksAsync.when(
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
              key: ValueKey(task.id),
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
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.brightness_6_outlined),
            tooltip: 'Tema',
            onSelected: (mode) => ref.read(themeModeProvider.notifier).setMode(mode),
            itemBuilder: (context) => [
              _themeItem('Sistema', ThemeMode.system, themeMode),
              _themeItem('Claro', ThemeMode.light, themeMode),
              _themeItem('Escuro', ThemeMode.dark, themeMode),
            ],
          ),
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey(switchKey),
                  child: content,
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

  PopupMenuItem<ThemeMode> _themeItem(
    String label,
    ThemeMode mode,
    ThemeMode selected,
  ) {
    return PopupMenuItem(
      value: mode,
      child: Row(
        children: [
          Icon(
            selected == mode ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _openCreate(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const TaskCreatePage()),
    );

    if (!context.mounted) return;

    if (result == 'created') {
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackBar(context, 'Tarefa criada com sucesso.'),
      );
    }
  }

  Future<void> _openDetails(BuildContext context, TaskEntity task) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
    );

    if (!context.mounted) return;

    if (result == 'deleted') {
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackBar(context, 'Tarefa excluída com sucesso.'),
      );
    }
  }
}
