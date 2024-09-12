// import 'package:flutter/foundation.dart';
// import 'package:task_tracker/model/task_model.dart';
// import 'package:task_tracker/services/database_helper.dart';

// class TaskProvider with ChangeNotifier {
//   List<Task> _tasks = [];

//   List<Task> get tasks => _tasks;

//   // Load tasks from database
//   Future<void> loadTasks() async {
//     _tasks = await DatabaseHelper.fetchTasks();
//     notifyListeners();
//   }

//   // Add a new task
//   Future<void> addTask(Task task) async {
//     await DatabaseHelper.insertTask(task);
//     await loadTasks();  // Refresh the task list after adding
//   }

//   // Edit a task
//   Future<void> updateTask(Task task) async {
//     await DatabaseHelper.updateTask(task);
//     await loadTasks();
//   }

//   // Delete a task
//   Future<void> deleteTask(int id) async {
//     await DatabaseHelper.deleteTask(id);
//     _tasks.removeWhere((task) => task.id == id); 
//     // await loadTasks();
//      notifyListeners();
//   }

//   Task getTaskById(int? id) {
//     return _tasks.firstWhere((task) => task.id == id);
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:task_tracker/model/task_model.dart';
import 'package:task_tracker/services/database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Load tasks from database
  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.fetchTasks();
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    await DatabaseHelper.insertTask(task);
    await loadTasks();  // Refresh the task list after adding
  }

  // Edit a task
  Future<void> updateTask(Task task) async {
    await DatabaseHelper.updateTask(task);
    await loadTasks();  // Refresh the task list after updating
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await DatabaseHelper.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id); 
    // Notify listeners after deleting
    notifyListeners();
  }

  // Get a task by its ID
  Task getTaskById(int? id) {
    return _tasks.firstWhere((task) => task.id == id);
  }
}
