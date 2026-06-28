import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/todo_task.dart';

class DatabaseService {
  static late Isar isar;

  // Initialize Isar
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoTaskSchema],
      directory: dir.path,
    );
  }

  // Create or Update a Task
  static Future<void> saveTask(TodoTask task) async {
    await isar.writeTxn(() async {
      await isar.todoTasks.put(task);
    });
    // Note: Firebase Sync will be triggered from here in Phase 5!
  }

  // Read all tasks (Stream for real-time UI updates)
  static Stream<List<TodoTask>> listenToTasks() {
    return isar.todoTasks.where().sortByOrderIndex().watch(fireImmediately: true);
  }

  // Delete a Task
  static Future<void> deleteTask(Id id) async {
    await isar.writeTxn(() async {
      await isar.todoTasks.delete(id);
    });
  }

  // Reorder Tasks (Drag and Drop functionality)
  static Future<void> reorderTasks(int oldIndex, int newIndex, List<TodoTask> currentTasks) async {
    if (oldIndex < newIndex) {
      newIndex -= 1; // Adjust because item is removed before insertion
    }

    final TodoTask item = currentTasks.removeAt(oldIndex);
    currentTasks.insert(newIndex, item);

    // Update all order indexes
    await isar.writeTxn(() async {
      for (int i = 0; i < currentTasks.length; i++) {
        currentTasks[i].orderIndex = i;
        await isar.todoTasks.put(currentTasks[i]);
      }
    });
  }
}
