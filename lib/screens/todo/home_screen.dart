import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/tasks/tasks_bloc.dart';
import '../../bloc/tasks/tasks_event.dart';
import '../../bloc/tasks/tasks_state.dart';
import '../../model/task.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/widgets.dart';
import 'add_todo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Center(child: Text("Todo List")),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TasksLoaded) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TodoCard(
                    tasks: task,
                    onDelete: () => _deleteTask(context, task),
                    onEdit: () => _navigateToEditPage(context, task),
                  );
                },
              ),
            );
          } else if (state is TasksError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No tasks available.'));
          }
        },
      ),
      floatingActionButton: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksLoaded && state.tasks.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Task Updated!'),
            ));
          }
        },
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFf8bd47),
          foregroundColor: const Color(0xFF322a1d),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodoPage(),
              ),
            );
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context, Task task) async {
    bool? confirmDelete = await showDeleteConfirmationDialog(context);
    // if (confirmDelete == true) {
    //   context.read<TasksBloc>().add(DeleteTask(taskId: task.id));
    // }
  }

  void _navigateToEditPage(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoPage(),
      ),
    );
  }
}
