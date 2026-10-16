import 'package:flutter/material.dart';

import 'package:todo_todo/models/subtask.dart';
import 'package:todo_todo/models/subtask_stats.dart';
import 'package:todo_todo/models/task.dart';
import 'package:todo_todo/services/database_service.dart';

/// Owns the list of tasks and keeps the database in sync.
class TaskProviders extends ChangeNotifier {
  final List<Task> _tasks = <Task>[];
  final DatabaseService dbService = DatabaseService.instance;

  TaskProviders() {
    loadTasks();
  }

  List<Task> get tasks => List<Task>.unmodifiable(_tasks);

  Future<void> loadTasks() async {
    _tasks.clear();
    final List<Task> loadedTasks = await dbService.getTasks();
    _tasks.addAll(loadedTasks);
    notifyListeners();
  }

  Future<void> addTask(String name) async {
    final Task task = Task(name: name);
    await dbService.insertTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    final Task task = _tasks[index];
    await dbService.deleteTask(task.id);
    _tasks.removeAt(index);
    notifyListeners();
  }

  Future<void> updateTask(int index, String newName) async {
    final Task task = _tasks[index];
    task.name = newName;
    await dbService.updateTaskName(task.id, newName);
    notifyListeners();
  }

  Future<void> addSubtask(int taskIndex, String subtaskName) async {
    final Task task = _tasks[taskIndex];
    final Subtask subtask = Subtask(name: subtaskName, taskId: task.id);
    await dbService.insertSubtask(subtask, task.id);
    task.subtasks.add(subtask);
    notifyListeners();
  }

  Future<void> removeSubtask(int taskIndex, int subtaskIndex) async {
    final Task task = _tasks[taskIndex];
    final Subtask subtask = task.subtasks[subtaskIndex];
    await dbService.deleteSubtask(subtask.id);
    task.subtasks.removeAt(subtaskIndex);
    notifyListeners();
  }

  Future<void> toggleSubtask(int taskIndex, int subtaskIndex) async {
    final Subtask subtask = _tasks[taskIndex].subtasks[subtaskIndex];
    subtask.toggle();
    await dbService.updateSubtask(subtask);
    notifyListeners();
  }

  Future<void> updateSubtask(
    int taskIndex,
    int subtaskIndex,
    String newName,
  ) async {
    final Subtask subtask = _tasks[taskIndex].subtasks[subtaskIndex];
    subtask.name = newName;
    await dbService.updateSubtask(subtask);
    notifyListeners();
  }

  SubtaskStats getSubtaskStats(int taskIndex) {
    final Task task = _tasks[taskIndex];
    final int total = task.subtasks.length;
    final int completed = task.subtasks
        .where((Subtask st) => st.isDone)
        .length;

    return SubtaskStats(
      total: total,
      completed: completed,
      remaining: total - completed,
    );
  }
}
