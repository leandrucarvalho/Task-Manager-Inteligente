import 'package:dio/dio.dart';

import '../../domain/entities/task_entity.dart';
import '../../../../core/config/app_config.dart';

class TaskAiService {
  TaskAiService({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<TaskPriority> suggestPriority({
    required String title,
    required String description,
  }) async {
    if (!AppConfig.hasOpenRouterKey) {
      throw StateError('OpenRouter API key nï¿½o configurada.');
    }

    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': AppConfig.openRouterModel,
        'temperature': 0.2,
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a task triage assistant. Respond with exactly one word: low, medium, or high. No punctuation.',
          },
          {
            'role': 'user',
            'content': 'Title: $title\nDescription: $description',
          },
        ],
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${AppConfig.openRouterApiKey}',
          if (AppConfig.openRouterReferer.isNotEmpty)
            'HTTP-Referer': AppConfig.openRouterReferer,
          if (AppConfig.openRouterTitle.isNotEmpty)
            'X-Title': AppConfig.openRouterTitle,
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    final message = choices?.isNotEmpty == true
        ? choices!.first['message'] as Map<String, dynamic>?
        : null;
    final content = (message?['content'] as String?)?.trim() ?? '';

    return _parsePriority(content);
  }

  TaskPriority _parsePriority(String content) {
    final lower = content.toLowerCase();
    if (lower.contains('high') || lower.contains('alta')) {
      return TaskPriority.high;
    }
    if (lower.contains('low') || lower.contains('baixa')) {
      return TaskPriority.low;
    }
    if (lower.contains('medium') ||
        lower.contains('média') ||
        lower.contains('media')) {
      return TaskPriority.medium;
    }
    return TaskPriority.medium;
  }
}
