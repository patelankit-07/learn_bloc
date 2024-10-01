// lib/blocs/tasks/tasks_state.dart

import 'package:equatable/equatable.dart';
import '../../model/task.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;

  const TasksLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TasksError extends TasksState {
  final String message;

  TasksError(this.message);

  @override
  List<Object> get props => [message];
}
