import 'package:flutter/material.dart';
import '../model/task.dart';

class TodoCard extends StatelessWidget {
  final Task tasks;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final title = tasks.title ?? 'No Title'; // Accessing title from Task object

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task: $title", // Displaying the title
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
