import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahil_assignment/bloc/tasks/tasks_event.dart';
import 'package:sahil_assignment/bloc/tasks/tasks_state.dart';
import '../../model/task.dart';
import '../../repositories/task_repository.dart';
import '../../widgets/dialogs.dart';

class TasksBloc extends Bloc<TaskEvent, TasksState> {
  final TaskRepository _taskRepository;

  TasksBloc(this._taskRepository) : super(TasksLoaded(tasks: [])) {
    on<LoadTask>(_onLoadTask);
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadTask(LoadTask event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    try {
      final tasks = await _taskRepository.getTasks();
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    if (state is TasksLoaded) {
      emit(TasksLoaded(tasks: List.from(state.tasks)..add(event.task)));
    }
  }

  // void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
  //   emit(TasksLoading());
  //   final state = this.state;
  //   if (state is TasksLoaded) {
  //     List<Task> tasks = state.tasks.where((task) {
  //       return task.id != event.taskId;
  //     }).toList();
  //     emit(TasksLoaded(tasks: tasks));
  //   }
  // }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    try {
      print("Attempting to delete task with ID: ${event.taskId}");
      await _taskRepository.deleteTask(event.taskId as int); // event.taskId as String

      print("Task deleted, updating state...");

      if (state is TasksLoaded) {
        print("Current state is TasksLoaded, filtering tasks...");
        List<Task> updatedTasks = (state as TasksLoaded).tasks
            .where((task) => task.id != event.taskId) // Ensure id matches type
            .toList();

        emit(TasksLoaded(tasks: updatedTasks));
        print("Tasks updated, state emitted");
      }
    } catch (e) {
      print("Error occurred: $e");
      emit(TasksError(e.toString()));
    }
  }





  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    if (state is TasksLoaded) {
      List<Task> tasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      emit(TasksLoaded(tasks: tasks));
    }
  }
}
