import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import '../models/todo_task.dart';

class DatabaseService {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoTaskSchema],
      directory: dir.path,
    );
  }

  static Future<void> saveTask(TodoTask task) async {
    // 1. Save to Local Isar Database
    await isar.writeTxn(() async {
      await isar.todoTasks.put(task);
    });

    // 2. Schedule or Cancel Notification
    if (task.dueDate != null && task.dueDate!.isAfter(DateTime.now()) && !task.isCompleted) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: task.id,
          channelKey: 'task_reminders',
          title: 'Task Due: ${task.title}',
          body: task.description?.isNotEmpty == true ? task.description : 'Don\'t forget to complete your task!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: task.dueDate!,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
    } else {
      AwesomeNotifications().cancel(task.id);
    }

    // 3. Sync to Firebase Firestore
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(task.id.toString())
            .set({
          'title': task.title,
          'description': task.description,
          'isCompleted': task.isCompleted,
          'category': task.category,
          'dueDate': task.dueDate?.toIso8601String(),
          'orderIndex': task.orderIndex,
        });
        debugPrint('☁️ BACKEND LOG: Task "${task.title}" successfully synced to Firebase Cloud!');
      }
    } catch (e) {
      // Fails silently for offline-first architecture
      debugPrint('Firebase Sync Error: $e');
    }
  }

  static Stream<List<TodoTask>> listenToTasks() {
    return isar.todoTasks.where().sortByOrderIndex().watch(fireImmediately: true);
  }

  static Future<void> deleteTask(Id id) async {
    // 1. Delete from Local DB
    await isar.writeTxn(() async {
      await isar.todoTasks.delete(id);
    });
    
    // 2. Cancel Notification
    AwesomeNotifications().cancel(id);

    // 3. Delete from Firebase
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(id.toString())
            .delete();
        debugPrint('☁️ BACKEND LOG: Task successfully DELETED from Firebase Cloud!');
      }
    } catch (e) {
      debugPrint('Firebase Delete Error: $e');
    }
  }

  static Future<void> reorderTasks(int oldIndex, int newIndex, List<TodoTask> currentTasks) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final TodoTask item = currentTasks.removeAt(oldIndex);
    currentTasks.insert(newIndex, item);

    // 1. Update order locally
    await isar.writeTxn(() async {
      for (int i = 0; i < currentTasks.length; i++) {
        currentTasks[i].orderIndex = i;
        await isar.todoTasks.put(currentTasks[i]);
      }
    });

    // 2. Batch update Firebase
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final batch = FirebaseFirestore.instance.batch();
        for (int i = 0; i < currentTasks.length; i++) {
          final docRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('tasks')
              .doc(currentTasks[i].id.toString());
          batch.update(docRef, {'orderIndex': i});
        }
        await batch.commit();
        debugPrint('☁️ BACKEND LOG: New Task order successfully SYNCED to Firebase Cloud!');
      }
    } catch (e) {
      debugPrint('Firebase Error: $e');
    }
  }
}
