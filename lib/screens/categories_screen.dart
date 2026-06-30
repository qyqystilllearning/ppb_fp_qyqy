import 'package:flutter/material.dart';
import '../models/todo_task.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'category_tasks_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: StreamBuilder<List<TodoTask>>(
        stream: DatabaseService.listenToTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data ?? [];
          // Group tasks by category
          final Map<String, int> categoryCounts = {};
          for (var task in tasks) {
            final cat = (task.category != null && task.category!.isNotEmpty) ? task.category! : 'General';
            categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
          }

          final categories = categoryCounts.keys.toList();
          categories.sort(); // Alphabetical order

          if (categories.isEmpty) {
            return const Center(child: Text('No categories yet.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final count = categoryCounts[cat]!;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryTasksScreen(categoryName: cat),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.cardGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder_open, color: Colors.white, size: 36),
                      const Spacer(),
                      Text(
                        cat,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count Task${count == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
