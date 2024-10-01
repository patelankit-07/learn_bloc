// tasks_event.dart
import 'package:equatable/equatable.dart';

import '../../model/task.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTask extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;
  DeleteTask({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask({required this.task});

  @override
  List<Object> get props => [task];
}

class LoadMoreTasks extends TaskEvent {}
