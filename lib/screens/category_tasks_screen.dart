import 'package:flutter/material.dart';
import '../models/todo_task.dart';
import '../services/database_service.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_screen.dart';

class CategoryTasksScreen extends StatelessWidget {
  final String categoryName;

  const CategoryTasksScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Tasks'),
      ),
      body: StreamBuilder<List<TodoTask>>(
        stream: DatabaseService.listenToTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var tasks = snapshot.data ?? [];
          // Filter tasks matching this category (or "General" if empty)
          tasks = tasks.where((t) {
            final cat = (t.category != null && t.category!.isNotEmpty) ? t.category! : 'General';
            return cat == categoryName;
          }).toList();

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found in this category.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, top: 16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(
                key: ValueKey(task.id),
                task: task,
                onToggleComplete: (val) {
                  task.isCompleted = val ?? false;
                  DatabaseService.saveTask(task);
                },
                onDelete: () {
                  DatabaseService.deleteTask(task.id);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
