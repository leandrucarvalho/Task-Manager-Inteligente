import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_delete_provider.dart';
import '../widgets/priority_indicator.dart';
import 'task_edit_page.dart';

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({super.key, required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(taskDeleteProvider, (previous, next) {
      if (next.hasError && next != previous) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir tarefa: ${next.error}')),
        );
      }
    });

    final deleteState = ref.watch(taskDeleteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da tarefa'),
        actions: [
          IconButton(
            onPressed:
                deleteState.isLoading ? null : () => _deleteTask(context, ref),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                PriorityIndicator(priority: task.priority),
                const SizedBox(width: 12),
                _StatusChip(status: task.status),
              ],
            ),
            const SizedBox(height: 16),
            Text(task.description),
            const SizedBox(height: 16),
            Text(
              'Criada em: ${DateFormatter.format(task.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _openEdit(context),
                icon: const Icon(Icons.edit),
                label: const Text('Editar tarefa'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskEditPage(task: task)),
    );
  }

  Future<void> _deleteTask(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: const Text('Essa a��o n�o pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await ref.read(taskDeleteProvider.notifier).delete(task.id);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final TaskStatus status;

  String _label() {
    switch (status) {
      case TaskStatus.todo:
        return 'A fazer';
      case TaskStatus.inProgress:
        return 'Em progresso';
      case TaskStatus.done:
        return 'Concluída';
    }
  }

  Color _color() {
    switch (status) {
      case TaskStatus.todo:
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
