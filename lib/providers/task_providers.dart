import 'package:flutter/material.dart';
import 'package:todo_todo/models/task.dart';
import 'package:todo_todo/services/database_service.dart';

class TaskProviders extends ChangeNotifier {
  final List<Task> _tasks = [];
  final DatabaseService dbService = DatabaseService.instance;

  TaskProviders() {
    loadTasks();
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

  // Load all tasks from DB
  Future<void> loadTasks() async {
    _tasks.clear();
    final loadedTasks = await dbService.getTasks();
    _tasks.addAll(loadedTasks);
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(String name) async {
    final task = Task(name: name);
    await dbService.insertTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  // Remove a task
  Future<void> removeTask(int index) async {
    final task = _tasks[index];
    await dbService.deleteTask(task.id);
    _tasks.removeAt(index);
    notifyListeners();
  }

  // Update task name
  Future<void> updateTask(int index, String newName) async {
    final task = _tasks[index];
    task.name = newName; // update in memory
    await dbService.updateTaskName(task.id, newName);
    notifyListeners();
  }

  // Add a subtask
  Future<void> addSubtask(int taskIndex, String subtaskName) async {
    final task = _tasks[taskIndex];
    final subtask = Subtask(name: subtaskName, taskId: task.id);
    await dbService.insertSubtask(subtask, task.id);
    task.subtasks.add(subtask);
    notifyListeners();
  }

  // Remove a subtask
  Future<void> removeSubtask(int taskIndex, int subtaskIndex) async {
    final task = _tasks[taskIndex];
    final subtask = task.subtasks[subtaskIndex];
    await dbService.deleteSubtask(subtask.id);
    task.subtasks.removeAt(subtaskIndex);
    notifyListeners();
  }

  // Toggle subtask completion
  Future<void> toggleSubtask(int taskIndex, int subtaskIndex) async {
    final subtask = _tasks[taskIndex].subtasks[subtaskIndex];
    subtask.toggle(); // toggle in memory
    await dbService.updateSubtask(subtask);
    notifyListeners();
  }

  // Update subtask name
  Future<void> updateSubtask(int taskIndex, int subtaskIndex, String newName) async {
    final subtask = _tasks[taskIndex].subtasks[subtaskIndex];
    subtask.name = newName; // update in memory
    await dbService.updateSubtask(subtask);
    notifyListeners();
  }

  // Get stats for a task's subtasks
  SubtaskStats getSubtaskStats(int taskIndex) {
    final task = _tasks[taskIndex];
    final total = task.subtasks.length;
    final completed = task.subtasks.where((st) => st.isDone).length;
    final remaining = total - completed;

    return SubtaskStats(
      total: total,
      completed: completed,
      remaining: remaining,
    );
  }
}

class SubtaskStats {
  final int total;
  final int completed;
  final int remaining;

  SubtaskStats({
    required this.total,
    required this.completed,
    required this.remaining,
  });
}
