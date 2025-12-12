// task.dart
class Task {
  final String id;           // Use String for consistency with DB
  String name;
  final List<Subtask> subtasks;

  Task({
    required this.name,
    String? id,
    List<Subtask>? subtasks,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        subtasks = subtasks ?? [];

  double get progress {
    if (subtasks.isEmpty) return 0.0;
    final completed = subtasks.where((st) => st.isDone).length;
    return completed / subtasks.length;
  }

  // Convert Task to map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create Task object from DB map
  factory Task.fromMap(Map<String, dynamic> map, List<Subtask> subtasks) {
    return Task(
      id: map['id'] as String,
      name: map['name'] as String,
      subtasks: subtasks,
    );
  }
}

class Subtask {
  final String id;           // String ID to match DB
  final String taskId;       // link to parent Task
  String name;
  bool isDone;

  Subtask({
    required this.name,
    required this.taskId,
    String? id,
    this.isDone = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Convert Subtask to map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'name': name,
      'status': isDone ? 1 : 0,
    };
  }

  // Create Subtask object from DB map
  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'] as String,
      taskId: map['task_id'] as String,
      name: map['name'] as String,
      isDone: (map['status'] as int) == 1,
    );
  }

  void toggle() {
    isDone = !isDone;
  }
}
