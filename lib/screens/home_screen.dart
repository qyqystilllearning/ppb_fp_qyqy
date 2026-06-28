import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_task.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildSummaryCard(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Your Tasks'),
            _buildFilterChips(),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTaskScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'User';
    final name = email.split('@').first;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello,', style: Theme.of(context).textTheme.bodyLarge),
              Text(
                '${name[0].toUpperCase()}${name.substring(1)}!',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).cardTheme.color,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => FirebaseAuth.instance.signOut(),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).cardTheme.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Summary',
                style: TextStyle(color: AppTheme.textPrimaryLight, fontSize: 14),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<TodoTask>>(
                stream: DatabaseService.listenToTasks(),
                builder: (context, snapshot) {
                  final tasks = snapshot.data ?? [];
                  final pending = tasks.where((t) => !t.isCompleted).length;
                  return Text(
                    '$pending Pending',
                    style: const TextStyle(
                      color: AppTheme.textPrimaryLight,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.insights, color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 18),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('See all', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          _filterChip('All', TaskFilter.all),
          const SizedBox(width: 8),
          _filterChip('Incomplete', TaskFilter.incomplete),
          const SizedBox(width: 8),
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
      selectedColor: AppTheme.primaryColor,
      backgroundColor: Theme.of(context).cardTheme.color,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildTaskList() {
    return StreamBuilder<List<TodoTask>>(
      stream: DatabaseService.listenToTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        var tasks = snapshot.data ?? [];
        
        if (_currentFilter == TaskFilter.incomplete) {
          tasks = tasks.where((t) => !t.isCompleted).toList();
        } else if (_currentFilter == TaskFilter.complete) {
          tasks = tasks.where((t) => t.isCompleted).toList();
        }

        if (tasks.isEmpty) {
          return const Center(child: Text('No tasks found in this category.'));
        }

        return ReorderableListView.builder(
          padding: const EdgeInsets.only(bottom: 40, top: 8),
          itemCount: tasks.length,
          // ignore: deprecated_member_use
          onReorder: (oldIndex, newIndex) {
            DatabaseService.reorderTasks(oldIndex, newIndex, List.from(tasks));
          },
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
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Theme.of(context).cardTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home_filled, color: AppTheme.primaryColor), onPressed: () {}),
          IconButton(icon: const Icon(Icons.pie_chart_outline, color: Colors.grey), onPressed: () {}),
          const SizedBox(width: 48), // Space for FAB
          IconButton(icon: const Icon(Icons.bar_chart, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.grey), onPressed: () {}),
        ],
      ),
    );
  }
}
