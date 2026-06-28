import 'package:flutter/material.dart';
import '../models/todo_task.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TodoTask? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: const Center(
        child: Text('Add/Edit Form will go here in Phase 5!'),
      ),
    );
  }
}
