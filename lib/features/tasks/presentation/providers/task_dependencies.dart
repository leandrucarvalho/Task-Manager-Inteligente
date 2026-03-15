import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/task_ai_service.dart';
import '../../data/datasources/task_api_service.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/datasources/task_local_db.dart';
import '../../data/repositories/task_ai_repository_impl.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_ai_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/suggest_task_priority.dart';
import '../../domain/usecases/update_task.dart';

const bool useMockApi = true;
const bool useLocalStorage = true;

final dioProvider = Provider<Dio>((ref) {
  return createDio();
});

final openRouterDioProvider = Provider<Dio>((ref) {
  return createDio(baseUrl: AppConfig.openRouterBaseUrl);
});

final taskLocalDbProvider = Provider<TaskLocalDb>((ref) {
  return TaskLocalDb.instance;
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSource(db: ref.read(taskLocalDbProvider));
});

final taskApiServiceProvider = Provider<TaskApiService>((ref) {
  return TaskApiService(
    dio: ref.read(dioProvider),
    useMock: useMockApi,
  );
});

final taskAiServiceProvider = Provider<TaskAiService>((ref) {
  return TaskAiService(dio: ref.read(openRouterDioProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    apiService: ref.read(taskApiServiceProvider),
    localDataSource: ref.read(taskLocalDataSourceProvider),
    useLocalStorage: useLocalStorage,
  );
});

final taskAiRepositoryProvider = Provider<TaskAiRepository>((ref) {
  return TaskAiRepositoryImpl(service: ref.read(taskAiServiceProvider));
});

final getTasksProvider = Provider<GetTasks>((ref) {
  return GetTasks(ref.read(taskRepositoryProvider));
});

final createTaskProvider = Provider<CreateTask>((ref) {
  return CreateTask(ref.read(taskRepositoryProvider));
});

final updateTaskProvider = Provider<UpdateTask>((ref) {
  return UpdateTask(ref.read(taskRepositoryProvider));
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(ref.read(taskRepositoryProvider));
});

final suggestTaskPriorityProvider = Provider<SuggestTaskPriority>((ref) {
  return SuggestTaskPriority(ref.read(taskAiRepositoryProvider));
});
