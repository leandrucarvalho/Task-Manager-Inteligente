import 'dart:async';

import 'package:dio/dio.dart';

import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';

class TaskApiService {
  TaskApiService({
    required Dio dio,
    this.useMock = true,
  }) : _dio = dio {
    if (_tasks.isEmpty) {
      _seed();
    }
  }

  final Dio _dio;
  final bool useMock;

  final List<TaskModel> _tasks = [];

  Future<List<TaskModel>> getTasks() async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      return List<TaskModel>.from(_tasks);
    }

    final response = await _dio.get('/tasks');
    final data = response.data as List<dynamic>;
    return data.map((json) => TaskModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      _tasks.add(task);
      return task;
    }

    final response = await _dio.post('/tasks', data: task.toJson());
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      final index = _tasks.indexWhere((item) => item.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
      return task;
    }

    final response = await _dio.put('/tasks/${task.id}', data: task.toJson());
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteTask(String id) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 300));
      _tasks.removeWhere((item) => item.id == id);
      return;
    }

    await _dio.delete('/tasks/$id');
  }

  void _seed() {
    _tasks.addAll([
      TaskModel(
        id: '1',
        title: 'Planejar sprint',
        description: 'Definir backlog e prioridades da semana.',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: '2',
        title: 'Revisar PRs',
        description: 'Fazer code review das tasks do time.',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      TaskModel(
        id: '3',
        title: 'Atualizar documentação',
        description: 'Publicar novas regras de arquitetura.',
        priority: TaskPriority.low,
        status: TaskStatus.done,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }
}
