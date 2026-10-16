/// A single checklist item belonging to a [Task].
class Subtask {
  Subtask({
    required this.name,
    required this.taskId,
    String? id,
    this.isDone = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  final String id;

  /// Id of the parent task.
  final String taskId;
  String name;
  bool isDone;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task_id': taskId,
      'name': name,
      'status': isDone ? 1 : 0,
    };
  }

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
