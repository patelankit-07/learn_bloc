import 'dart:convert';
import '../model/task.dart';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String _baseUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((task) => Task.fromJson(task))
          .toList();
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  Future<void> addTask(Task task) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(Task task) async {
    final url = '$_baseUrl/${task.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = '$_baseUrl/$taskId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
