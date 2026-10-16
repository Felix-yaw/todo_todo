import 'subtask.dart';

/// A task that owns an ordered list of [Subtask]s.
class Task {
  Task({
    required this.name,
    String? id,
    List<Subtask>? subtasks,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        subtasks = subtasks ?? [];

  final String id;
  String name;
  final List<Subtask> subtasks;

  /// Completion ratio (0.0–1.0) across this task's subtasks.
  double get progress {
    if (subtasks.isEmpty) return 0.0;
    final int completed = subtasks.where((Subtask st) => st.isDone).length;
    return completed / subtasks.length;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, List<Subtask> subtasks) {
    return Task(
      id: map['id'] as String,
      name: map['name'] as String,
      subtasks: subtasks,
    );
  }
}
