import 'package:flutter/material.dart';
import 'package:todo_todo/models/task.dart';

class TaskProviders extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String name) {
    _tasks.add(Task(name: name));
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTask(int index, String newName) {
  final oldTask = _tasks[index];

  _tasks[index] = Task(
    name: newName,
    subtasks: oldTask.subtasks,
  );

  notifyListeners();
}


  void addSubtask(int taskIndex, String subtaskName) {
    _tasks[taskIndex].subtasks.add(Subtask(name: subtaskName));
    notifyListeners();
  }

  void toggleSubtask(int taskIndex, int subtaskIndex) {
  _tasks[taskIndex].subtasks[subtaskIndex].isDone =
      !_tasks[taskIndex].subtasks[subtaskIndex].isDone;
  notifyListeners();
}

  void removeSubtask(int taskIndex, int subtaskIndex) {
    _tasks[taskIndex].subtasks.removeAt(subtaskIndex);
    notifyListeners();
  }
  void updateSubtask(int taskIndex, int subtaskIndex, String newName){
    final subtask = _tasks[taskIndex].subtasks[subtaskIndex];
    _tasks[taskIndex].subtasks[subtaskIndex] = Subtask(
      name: newName,
      isDone: subtask.isDone,
    );
    notifyListeners();

  }

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