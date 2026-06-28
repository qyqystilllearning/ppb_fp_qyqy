import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_task.dart';

class TaskTile extends StatelessWidget {
  final TodoTask task;
  final ValueChanged<bool?> onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Checkbox / Icon
                GestureDetector(
                  onTap: () => onToggleComplete(!task.isCompleted),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: task.isCompleted 
                          ? Theme.of(context).primaryColor 
                          : Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      task.isCompleted ? Icons.check : Icons.circle_outlined,
                      color: task.isCompleted ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: task.isCompleted ? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (task.dueDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM, hh:mm a').format(task.dueDate!),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Category or Trailing Action
                if (task.category != null && task.category!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.category!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
