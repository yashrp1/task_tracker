import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_tracker/model/task_model.dart';

class DatabaseHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'task_tracker.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT, description TEXT, dueDate TEXT, isComplete INTEGER, category TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertTask(Task task) async {
    final db = await database();
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Task>> fetchTasks() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'dueDate');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  static Future<void> updateTask(Task task) async {
    final db = await database();
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<void> deleteTask(int id) async {
    final db = await database();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
