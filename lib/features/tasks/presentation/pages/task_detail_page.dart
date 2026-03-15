import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/success_snackbar.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_delete_provider.dart';
import '../widgets/priority_indicator.dart';
import 'task_edit_page.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  const TaskDetailPage({super.key, required this.task});

  final TaskEntity task;

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  late TaskEntity _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
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
                deleteState.isLoading ? null : () => _deleteTask(context),
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
              _task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                PriorityIndicator(priority: _task.priority),
                const SizedBox(width: 12),
                _StatusChip(status: _task.status),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _task.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Criada em: ${DateFormatter.format(_task.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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

  Future<void> _openEdit(BuildContext context) async {
    final result = await Navigator.of(context).push<TaskEntity>(
      MaterialPageRoute(builder: (_) => TaskEditPage(task: _task)),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() => _task = result);
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackBar(context, 'Tarefa atualizada com sucesso.'),
      );
    }
  }

  Future<void> _deleteTask(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: const Text('Essa ação não pode ser desfeita.'),
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

    await ref.read(taskDeleteProvider.notifier).delete(_task.id);

    if (context.mounted) {
      Navigator.of(context).pop('deleted');
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

  Color _color(ColorScheme scheme) {
    switch (status) {
      case TaskStatus.todo:
        return scheme.tertiary;
      case TaskStatus.inProgress:
        return scheme.secondary;
      case TaskStatus.done:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _color(scheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
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
