import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                onRefresh: fetchData,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index] as Map;
                    final id = item['id']?.toString() ?? '';
                    return TodoCard(
                      item: item,
                      onDelete: () => deleteById(id),
                      onEdit: () => navigateToEditPage(item),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://jsonplaceholder.typicode.com/todos';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        items = json;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load data');
    }
  }

  void navigateToEditPage(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(
        existingTodo: item,
      ),
    );
    Navigator.push(context, route);
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    if (id.isEmpty) {
      showFailedMessage('Invalid ID');
      return;
    }

    // Show confirmation dialog
    bool? confirmDelete = await showDeleteConfirmationDialog();

    if (confirmDelete == true) {
      final url = 'https://jsonplaceholder.typicode.com/posts/$id';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        final filtered =
            items.where((element) => element['id']?.toString() != id).toList();
        setState(() {
          items = filtered;
        });
        showSucessMessage('Deleted successfully');
      } else {
        showFailedMessage('Delete failed');
      }
    }
  }

  Future<bool?> showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSucessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailedMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class TodoCard extends StatelessWidget {
  final Map item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final title = item['title'] ?? 'No Title';

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
              "Task: $title",
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
