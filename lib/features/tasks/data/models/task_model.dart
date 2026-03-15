import '../../domain/entities/task_entity.dart';

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: TaskPriority.values.byName(json['priority'] as String),
      status: TaskStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  factory TaskModel.fromDb(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: TaskPriority.values[map['priority'] as int],
      status: TaskStatus.values[map['status'] as int],
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      createdAt: createdAt,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}

