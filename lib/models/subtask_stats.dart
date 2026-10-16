/// Aggregate completion counts for a task's subtasks.
class SubtaskStats {
  const SubtaskStats({
    required this.total,
    required this.completed,
    required this.remaining,
  });

  final int total;
  final int completed;
  final int remaining;
}
