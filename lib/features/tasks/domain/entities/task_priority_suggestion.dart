import 'package:equatable/equatable.dart';

import 'task_entity.dart';

enum SuggestionSource { ai, cache, heuristic }

class TaskPrioritySuggestion extends Equatable {
  const TaskPrioritySuggestion({
    required this.priority,
    required this.reason,
    required this.source,
  });

  final TaskPriority priority;
  final String reason;
  final SuggestionSource source;

  TaskPrioritySuggestion copyWith({
    TaskPriority? priority,
    String? reason,
    SuggestionSource? source,
  }) {
    return TaskPrioritySuggestion(
      priority: priority ?? this.priority,
      reason: reason ?? this.reason,
      source: source ?? this.source,
    );
  }

  @override
  List<Object?> get props => [priority, reason, source];
}

