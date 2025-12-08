class Task {
  final String id;
  final String name;
  final List<Subtask> subtasks;

  Task({
    required this.name,
    List<Subtask>? subtasks,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        subtasks = subtasks ?? [];

  double get progress {
    if (subtasks.isEmpty) return 0.0;
    final completed = subtasks.where((st) => st.isDone).length;
    return completed / subtasks.length;
  }
}

class Subtask {
  final String id;
  final String name;
  bool isDone;

  Subtask({
    required this.name,
    this.isDone = false,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  void toggle() {
    isDone = !isDone;
  }
}