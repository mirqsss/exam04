import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime dueDate;
  final String userId;
  final int priority;
  final List<String> tags;
  final DateTime? completedAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.dueDate,
    required this.userId,
    required this.priority,
    required this.tags,
    this.completedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Конвертируем Timestamp в DateTime для completedAt
    if (json['completedAt'] != null) {
      if (json['completedAt'] is Timestamp) {
        json['completedAt'] = (json['completedAt'] as Timestamp).toDate().toIso8601String();
      }
    }
    return _$TaskModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    String? userId,
    int? priority,
    List<String>? tags,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      userId: userId ?? this.userId,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        createdAt,
        dueDate,
        userId,
        priority,
        tags,
        completedAt,
      ];
} 