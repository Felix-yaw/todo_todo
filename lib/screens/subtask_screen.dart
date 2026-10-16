import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_todo/models/subtask.dart';
import 'package:todo_todo/models/task.dart';
import 'package:todo_todo/providers/task_providers.dart';
import 'package:todo_todo/widgets/subtask_tile.dart';

/// Detail screen for a task: its subtasks plus a completion summary bar.
class SubtaskScreen extends StatelessWidget {
  const SubtaskScreen({
    super.key,
    required this.taskIndex,
    required this.task,
  });

  final int taskIndex;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          task.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<TaskProviders>(
              builder: (context, taskData, child) {
                final Task currentTask = taskData.tasks[taskIndex];
                if (currentTask.subtasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No subtasks yet. Add one to break down this task!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: currentTask.subtasks.length,
                  itemBuilder: (context, index) {
                    final Subtask subtask = currentTask.subtasks[index];
                    return SubtaskTile(
                      subtask: subtask,
                      onToggle: () => context
                          .read<TaskProviders>()
                          .toggleSubtask(taskIndex, index),
                      onLongPress: () {
                        if (subtask.isDone) return;
                        _showSubtaskOptions(context, index);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Consumer<TaskProviders>(
            builder: (context, taskData, child) {
              final stats = taskData.getSubtaskStats(taskIndex);
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _StatColumn(
                      label: 'Total',
                      value: stats.total.toString(),
                      color: Colors.grey,
                    ),
                    _StatColumn(
                      label: 'Done',
                      value: stats.completed.toString(),
                      color: Colors.green,
                    ),
                    _StatColumn(
                      label: 'Undone',
                      value: stats.remaining.toString(),
                      color: Colors.orange,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSubtaskDialog(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddSubtaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter subtask name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<TaskProviders>().addSubtask(
                      taskIndex,
                      controller.text.trim(),
                    );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditSubtaskDialog(BuildContext context, int subtaskIndex) {
    final TaskProviders taskData = context.read<TaskProviders>();
    final Subtask subtask = taskData.tasks[taskIndex].subtasks[subtaskIndex];
    final TextEditingController controller =
        TextEditingController(text: subtask.name);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter subtask name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<TaskProviders>().updateSubtask(
                      taskIndex,
                      subtaskIndex,
                      controller.text.trim(),
                    );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteSubtaskConfirmation(BuildContext context, int subtaskIndex) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subtask'),
        content: const Text('Are you sure you want to delete this subtask?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<TaskProviders>()
                  .removeSubtask(taskIndex, subtaskIndex);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSubtaskOptions(BuildContext context, int subtaskIndex) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Subtask'),
              onTap: () {
                Navigator.pop(context);
                _showEditSubtaskDialog(context, subtaskIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Subtask'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteSubtaskConfirmation(context, subtaskIndex);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A single value/label pair in the bottom summary bar.
class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
