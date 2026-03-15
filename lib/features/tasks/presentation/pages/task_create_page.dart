import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/success_snackbar.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_priority_suggestion.dart';
import '../providers/task_ai_provider.dart';
import '../providers/task_create_provider.dart';
import 'package:task_manager_inteligente/features/tasks/presentation/widgets/priority_suggestion_badge.dart';

class TaskCreatePage extends ConsumerStatefulWidget {
  const TaskCreatePage({super.key});

  @override
  ConsumerState<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends ConsumerState<TaskCreatePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late final AnimationController _enterController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.todo;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    final curved = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    );
    _fade = curved;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(curved);
    _enterController.forward();
  }

  @override
  void dispose() {
    _enterController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final task = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      status: _status,
      createdAt: DateTime.now(),
    );

    await ref.read(taskCreateProvider.notifier).create(task);

    if (context.mounted) {
      Navigator.of(context).pop('created');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(taskCreateProvider, (previous, next) {
      if (next.hasError && next != previous) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar tarefa: ${next.error}')),
        );
      }
    });

    ref.listen<AsyncValue<TaskPrioritySuggestion?>>(
        taskPrioritySuggestionProvider, (previous, next) {
      if (next.hasError && next != previous) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao sugerir prioridade: ${next.error}')),
        );
      }
      final suggestion = next.value;
      if (suggestion != null && suggestion != previous?.value) {
        setState(() => _priority = suggestion.priority);
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar(context, 'Prioridade sugerida automaticamente.'),
        );
      }
    });

    final createState = ref.watch(taskCreateProvider);
    final suggestionState = ref.watch(taskPrioritySuggestionProvider);
    final suggestion = suggestionState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova tarefa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o título';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe a descrição';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<TaskPriority>(
                            value: _priority,
                            decoration:
                                const InputDecoration(labelText: 'Prioridade'),
                            items: TaskPriority.values
                                .map(
                                  (priority) => DropdownMenuItem(
                                    value: priority,
                                    child: Text(_priorityLabel(priority)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _priority = value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: suggestionState.isLoading
                              ? null
                              : () => ref
                                  .read(taskPrioritySuggestionProvider.notifier)
                                  .suggest(
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                  ),
                          icon: suggestionState.isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.auto_awesome),
                          label: const Text('Sugerir'),
                        ),
                      ],
                    ),
                    if (suggestion != null) ...[
                      const SizedBox(height: 12),
                      PrioritySuggestionBadge(suggestion: suggestion),
                    ],
                    const SizedBox(height: 16),
                    DropdownButtonFormField<TaskStatus>(
                      value: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: TaskStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(_statusLabel(status)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: createState.isLoading ? null : _submit,
                        child: createState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Baixa';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'A fazer';
      case TaskStatus.inProgress:
        return 'Em progresso';
      case TaskStatus.done:
        return 'Concluída';
    }
  }
}
