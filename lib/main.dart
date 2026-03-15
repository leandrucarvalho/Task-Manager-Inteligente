import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'features/tasks/presentation/pages/login_page.dart';
import 'features/tasks/presentation/pages/task_list_page.dart';

void main() {
  runApp(const ProviderScope(child: TaskManagerApp()));
}

class TaskManagerApp extends ConsumerWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Task Manager Inteligente',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.tasks: (_) => const TaskListPage(),
      },
    );
  }
}

