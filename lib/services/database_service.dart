// database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_todo/models/task.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  final String taskTable = "tasks";
  final String subtaskTable = "subtasks";

  // Get or create database
  Future<Database> getDatabase() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, "master_db.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $taskTable (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE $subtaskTable (
            id TEXT PRIMARY KEY,
            task_id TEXT NOT NULL,
            name TEXT NOT NULL,
            status INTEGER NOT NULL,
            FOREIGN KEY (task_id) REFERENCES $taskTable(id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }

  // Insert a task with its subtasks
  Future<void> insertTask(Task task) async {
    final db = await getDatabase();

    await db.insert(taskTable, {
      'id': task.id,
      'name': task.name,
    });

    //for (var s in task.subtasks) {
      //await insertSubtask(s, task.id);
    //}
  }

  // Get all tasks with their subtasks
  Future<List<Task>> getTasks() async {
    final db = await getDatabase();
    final taskRows = await db.query(taskTable);

    List<Task> tasks = [];

    for (var t in taskRows) {
      final subtaskRows = await db.query(
        subtaskTable,
        where: "task_id = ?",
        whereArgs: [t['id']],
      );

      List<Subtask> subtasks = [];
      for (var st in subtaskRows) {
        subtasks.add(Subtask(
          id: st['id'] as String,
          taskId: st['task_id'] as String,
          name: st['name'] as String,
          isDone: (st['status'] as int) == 1,
        ));
      }

      tasks.add(Task(
        id: t['id'] as String,
        name: t['name'] as String,
        subtasks: subtasks,
      ));
    }

    return tasks;
  }

  // Insert a single subtask for a task
  Future<void> insertSubtask(Subtask subtask, String taskId) async {
    final db = await getDatabase();

    //debugPrint('the task id is $taskId, the name is ${subtask.name}, the status ${subtask.isDone} ');

    await db.insert(
      subtaskTable,
      {
        'id': subtask.id,
        'task_id': taskId,
        'name': subtask.name,
        'status': subtask.isDone ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a subtask
  Future<void> deleteSubtask(String subtaskId) async {
    final db = await getDatabase();
    await db.delete(
      subtaskTable,
      where: 'id = ?',
      whereArgs: [subtaskId],
    );
  }

  // Update a subtask
  Future<void> updateSubtask(Subtask subtask) async {
    final db = await getDatabase();
    await db.update(
      subtaskTable,
      {
        'name': subtask.name,
        'status': subtask.isDone ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [subtask.id],
    );
  }

  // Update a task name
  Future<void> updateTaskName(String taskId, String newName) async {
    final db = await getDatabase();
    await db.update(
      taskTable,
      {'name': newName},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // Delete a task (subtasks cascade automatically)
  Future<void> deleteTask(String taskId) async {
    final db = await getDatabase();
    await db.delete(
      taskTable,
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
