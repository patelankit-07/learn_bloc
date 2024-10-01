import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? existingTodo;

  const AddTodoPage({super.key, this.existingTodo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingTodo != null) {
      titleController.text = widget.existingTodo!['title'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: const Center(
            child: Text('To Do List', style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.9,
              height: height * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Task',
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            SizedBox(
              width: width * 0.8,
              height: height * 0.05,
              child: ElevatedButton(
                onPressed:
                    widget.existingTodo == null ? submitData : updateData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  widget.existingTodo == null ? 'SUBMIT' : 'UPDATE',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Title cannot be empty")));
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/todos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'title': title}),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to add todo")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("An error occurred")));
    }
  }

  Future<void> updateData() async {
    if (widget.existingTodo == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Todo not found for update")));
      return;
    }

    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Title cannot be empty")));
      return;
    }

    final todoId = widget.existingTodo!['id'];
    if (todoId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid todo ID")));
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('https://your-api-url.com/todos/$todoId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'title': title}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Successfully updated")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to update todo")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("An error occurred")));
    }
  }
}
