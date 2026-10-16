import 'package:flutter/material.dart';

import 'package:todo_todo/models/subtask.dart';

/// A single subtask row: a checkbox, a strike-through title and long-press
/// options.
class SubtaskTile extends StatelessWidget {
  const SubtaskTile({
    super.key,
    required this.subtask,
    required this.onToggle,
    required this.onLongPress,
  });

  final Subtask subtask;
  final VoidCallback onToggle;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: subtask.isDone,
          onChanged: (_) => onToggle(),
          activeColor: Colors.black,
        ),
        title: Text(
          subtask.name,
          style: TextStyle(
            decoration: subtask.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: subtask.isDone ? Colors.grey : Colors.black,
            fontSize: 16,
          ),
        ),
        onLongPress: onLongPress,
        onTap: onToggle,
      ),
    );
  }
}
