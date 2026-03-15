class AppConfig {
  static const openRouterApiKey = String.fromEnvironment('OPENROUTER_API_KEY');
  static const openRouterModel = String.fromEnvironment(
    'OPENROUTER_MODEL',
    defaultValue: 'openai/gpt-4',
  );
  static const openRouterBaseUrl = String.fromEnvironment(
    'OPENROUTER_BASE_URL',
    defaultValue: 'https://openrouter.ai/api/v1',
  );
  static const openRouterReferer = String.fromEnvironment(
    'OPENROUTER_REFERER',
    defaultValue: '',
  );
  static const openRouterTitle = String.fromEnvironment(
    'OPENROUTER_TITLE',
    defaultValue: 'Task Manager Inteligente',
  );

  static bool get hasOpenRouterKey => openRouterApiKey.isNotEmpty;
}

