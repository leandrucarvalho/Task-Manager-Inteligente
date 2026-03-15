import 'package:flutter/material.dart';

import '../../domain/entities/task_priority_suggestion.dart';

class PrioritySuggestionBadge extends StatelessWidget {
  const PrioritySuggestionBadge({super.key, required this.suggestion});

  final TaskPrioritySuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _colorForSource(scheme, suggestion.source);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sourceLabel(suggestion.source),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion.reason,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForSource(ColorScheme scheme, SuggestionSource source) {
    switch (source) {
      case SuggestionSource.ai:
        return scheme.secondary;
      case SuggestionSource.cache:
        return scheme.tertiary;
      case SuggestionSource.heuristic:
        return scheme.primary;
    }
  }

  String _sourceLabel(SuggestionSource source) {
    switch (source) {
      case SuggestionSource.ai:
        return 'Sugerido pela IA';
      case SuggestionSource.cache:
        return 'Sugerido via cache local';
      case SuggestionSource.heuristic:
        return 'Sugerido por heurística local';
    }
  }
}

