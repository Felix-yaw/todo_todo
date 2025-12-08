import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/models/task.dart';
import 'package:todo_todo/providers/task_providers.dart';

class SubtaskScreen extends StatelessWidget {
  final int taskIndex;
  final Task task;

  const SubtaskScreen({
    super.key,
    required this.taskIndex,
    required this.task,
  });

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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<TaskProviders>(
              builder: (context, taskData, child) {
                final currentTask = taskData.tasks[taskIndex];
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
                    final subtask = currentTask.subtasks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: subtask.isDone,
                          onChanged: (value) {
                            taskData.toggleSubtask(taskIndex, index);
                          },
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Bottom Stats Bar
          Consumer<TaskProviders>(
            builder: (context, taskData, child) {
              final stats = taskData.getSubtaskStats(taskIndex);
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Total', stats.total.toString(), Colors.grey),
                    _buildStatColumn('Done', stats.completed.toString(), Colors.green),
                    _buildStatColumn('Undone', stats.remaining.toString(), Colors.orange),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSubtaskDialog(context);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showAddSubtaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
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
        actions: [
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
}

void _showAddSubtaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
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
        actions: [
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

  void _showSubtaskOptions(BuildContext context, int subtaskIndex) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

  void _showEditSubtaskDialog(BuildContext context, int subtaskIndex) {
    final taskData = context.read<TaskProviders>();
    final subtask = taskData.tasks[taskIndex].subtasks[subtaskIndex];
    final controller = TextEditingController(text: subtask.name);
    
    showDialog(
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
        actions: [
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
    final taskData = context.read<TaskProviders>();
    final subtask = taskData.tasks[taskIndex].subtasks[subtaskIndex];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subtask'),
        content: Text('Are you sure you want to delete "${subtask.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskProviders>().removeSubtask(taskIndex, subtaskIndex);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

