import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_task.dart';
import '../services/database_service.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_screen.dart';

enum TaskFilter { all, incomplete, complete }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: StreamBuilder<List<TodoTask>>(
              stream: DatabaseService.listenToTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                var tasks = snapshot.data ?? [];
                
                // Apply Filter
                if (_currentFilter == TaskFilter.incomplete) {
                  tasks = tasks.where((t) => !t.isCompleted).toList();
                } else if (_currentFilter == TaskFilter.complete) {
                  tasks = tasks.where((t) => t.isCompleted).toList();
                }

                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 80, color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('No tasks found!', style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                }

                return ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 80, top: 8),
                  itemCount: tasks.length,
                  // ignore: deprecated_member_use
                  onReorder: (oldIndex, newIndex) {
                    DatabaseService.reorderTasks(oldIndex, newIndex, List.from(tasks));
                  },
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      key: ValueKey(task.id), // CRITICAL for ReorderableListView
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
                          MaterialPageRoute(
                            builder: (_) => AddEditTaskScreen(task: task),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTaskScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _filterChip('All', TaskFilter.all),
          _filterChip('Incomplete', TaskFilter.incomplete),
          _filterChip('Complete', TaskFilter.complete),
        ],
      ),
    );
  }

  Widget _filterChip(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _currentFilter = filter);
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
