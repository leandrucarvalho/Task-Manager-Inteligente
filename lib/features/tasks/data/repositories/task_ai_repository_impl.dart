import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_priority_suggestion.dart';
import '../../domain/repositories/task_ai_repository.dart';
import '../datasources/task_ai_cache_datasource.dart';
import '../datasources/task_ai_service.dart';

class TaskAiRepositoryImpl implements TaskAiRepository {
  TaskAiRepositoryImpl({
    required TaskAiService service,
    required TaskAiCacheDataSource cache,
  })  : _service = service,
        _cache = cache;

  final TaskAiService _service;
  final TaskAiCacheDataSource _cache;

  @override
  Future<TaskPrioritySuggestion> suggestPriority({
    required String title,
    required String description,
  }) async {
    final key = _cacheKey(title, description);
    final cached = await _cache.getSuggestion(key);
    if (cached != null) {
      return cached.copyWith(source: SuggestionSource.cache);
    }

    final heuristic = _heuristicSuggestion(title, description);

    try {
      final priority =
          await _service.suggestPriority(title: title, description: description);
      final reason = _aiReason(
        title: title,
        description: description,
        aiPriority: priority,
        heuristic: heuristic,
      );
      final suggestion = TaskPrioritySuggestion(
        priority: priority,
        reason: reason,
        source: SuggestionSource.ai,
      );
      await _cache.saveSuggestion(key, suggestion);
      return suggestion;
    } catch (_) {
      final fallback = heuristic.copyWith(source: SuggestionSource.heuristic);
      await _cache.saveSuggestion(key, fallback);
      return fallback;
    }
  }

  String _cacheKey(String title, String description) {
    final normalizedTitle = title.trim().toLowerCase();
    final normalizedDescription = description.trim().toLowerCase();
    return '$normalizedTitle||$normalizedDescription';
  }

  TaskPrioritySuggestion _heuristicSuggestion(
    String title,
    String description,
  ) {
    final text = '${title.trim()} ${description.trim()}'.toLowerCase();

    final highKeywords = [
      'urgente',
      'hoje',
      'agora',
      'prazo',
      'deadline',
      'crítico',
      'critico',
      'bloqueado',
      'imediato',
      'importante',
      'produção',
      'producao',
    ];

    final lowKeywords = [
      'quando der',
      'opcional',
      'talvez',
      'someday',
      'futuro',
      'backlog',
      'nice to have',
      'baixa prioridade',
    ];

    final highMatches = highKeywords.where(text.contains).toList();
    if (highMatches.isNotEmpty) {
      return TaskPrioritySuggestion(
        priority: TaskPriority.high,
        reason:
            'Sinais de urgência detectados: ${_formatMatches(highMatches)}.',
        source: SuggestionSource.heuristic,
      );
    }

    final lowMatches = lowKeywords.where(text.contains).toList();
    if (lowMatches.isNotEmpty) {
      return TaskPrioritySuggestion(
        priority: TaskPriority.low,
        reason:
            'Sinais de baixa prioridade detectados: ${_formatMatches(lowMatches)}.',
        source: SuggestionSource.heuristic,
      );
    }

    return const TaskPrioritySuggestion(
      priority: TaskPriority.medium,
      reason: 'Sem sinais fortes de urgência; prioridade média sugerida.',
      source: SuggestionSource.heuristic,
    );
  }

  String _aiReason({
    required String title,
    required String description,
    required TaskPriority aiPriority,
    required TaskPrioritySuggestion heuristic,
  }) {
    if (heuristic.priority == aiPriority &&
        heuristic.reason.isNotEmpty &&
        heuristic.reason !=
            'Sem sinais fortes de urgência; prioridade média sugerida.') {
      return 'IA confirmou a prioridade com base em: ${heuristic.reason}';
    }

    if (heuristic.priority == aiPriority) {
      return 'IA sugeriu prioridade com base no contexto da tarefa.';
    }

    return 'IA sugeriu prioridade com base no contexto da tarefa.';
  }

  String _formatMatches(List<String> matches) {
    final unique = matches.toSet().toList();
    unique.sort();
    if (unique.length > 3) {
      return unique.take(3).join(', ') + '...';
    }
    return unique.join(', ');
  }
}

