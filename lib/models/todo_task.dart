import 'package:isar/isar.dart';

part 'todo_task.g.dart';

@collection
class TodoTask {
  Id id = Isar.autoIncrement;

  // Optional Firestore ID to keep track of the document when syncing to the cloud
  String? firestoreId;

  late String title;
  
  String? description;

  bool isCompleted = false;

  // Category or Tag (e.g., 'Work', 'Personal')
  String? category;

  // When the task is due. This will be used to trigger awesome_notifications!
  DateTime? dueDate;

  // Used for Drag-and-Drop ordering!
  int orderIndex = 0;
}
