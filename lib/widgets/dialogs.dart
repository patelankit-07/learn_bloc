import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/task.dart';

Future<Task?> showAddTaskDialog(BuildContext context, int lastId) {
  final titleController = TextEditingController();
  final userIdController = TextEditingController();

  return showDialog<Task>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0XFFfeddaa),
      title: TextField(
        controller: titleController,
        decoration: const InputDecoration(
          fillColor: Color(0XFF322a1d),
          hintText: 'Task Title',
          border: InputBorder.none,
        ),
      ),
      content: TextField(
        controller: userIdController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          hintText: 'User ID',
          border: InputBorder.none,
          filled: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty && userIdController.text.isNotEmpty) {
              Navigator.of(context).pop(Task(
                id: lastId + 1,
                userId: int.parse(userIdController.text),
                title: titleController.text,
              ));
            }
          },
          child: const Text(
            'Add',
            style: TextStyle(color: Color(0xFF322a1d)),
          ),
        ),
      ],
    ),
  );
}

Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
