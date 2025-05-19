import 'package:equatable/equatable.dart';
import 'package:exam04/models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final TaskModel task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskModel task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletion extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  const ToggleTaskCompletion(this.taskId, this.isCompleted);

  @override
  List<Object?> get props => [taskId, isCompleted];
} 