class Task {
  final String id;
  final String name;
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

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name':name,
    };
  }
  factory Task.fromMap(Map<String , dynamic> map, List<Subtask> subtasks){
    return Task(
      id: map['id'],
    name: map['name'],
    subtasks: subtasks,);
  }
}



class Subtask {
  final String id;
  final String name;
  bool isDone;

  Subtask({
    required this.name,
    String? id,
    this.isDone = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap(String taskId){
    return {
      'id' : id,
      'taskId': taskId,
      'name': name,
      'isDone': isDone ? 1:0
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map){
    return Subtask(name: map['name'], id: map['id'], isDone:(map['status']) == 1);
  }

  void toggle() {
    isDone = !isDone;
  }
}