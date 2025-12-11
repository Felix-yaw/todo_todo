import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_todo/models/task.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  final String taskTable = "tasks";
  final String subtaskTable = "subtasks";

  Future<Database> getDatabase() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, "master_db.db");

    final database = await openDatabase(
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

    return database;
  }

  Future<void> insertTask(Task task) async {
    final db = await getDatabase();

    await db.insert(taskTable, {
      'id': task.id,
      'name': task.name,
    });

    for (var s in task.subtasks) {
      await db.insert(subtaskTable, {
        'id': s.id,
        'task_id': task.id,
        'name': s.name,
        'status': s.isDone ? 1 : 0,
      });
    }
  }

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

  Future<void> insertSubtask( Subtask subtask, String taskId) async {
    final db = await getDatabase();
    await db.insert('subtask', 
    {
      'id': subtask.id,
      'task_id': taskId,
      'name': subtask.name,
      'status': subtask.isDone? 1:0,
    },
    conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void>deleteSubtask(String subtaskId) async {
    final db = await getDatabase();
    await db.delete(
      'subtasks',
      where: 'id = ?',
      whereArgs: [subtaskId],  
    );
  }
}
