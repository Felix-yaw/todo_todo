
 
 import 'package:flutter/material.dart';
import 'package:todo_todo/models/task.dart';
import 'package:todo_todo/screens/subtask.dart';
import 'package:todo_todo/providers/task_providers.dart';
import 'package:provider/provider.dart';



class TaskTile extends StatelessWidget {
  final Task task;
  final int index;

  const TaskTile({
    super.key,
    required this.task,
    required this.index,
  });
void _showTaskOptions(BuildContext context) {
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
            title: const Text('Edit Task'),
            onTap: () {
              Navigator.pop(context); 
              _showEditTaskDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Task'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
    ),
  );
}


void _showDeleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Task'),
      content: Text('Are you sure you want to delete this task"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Use dialogContext to read provider safely inside dialog
            Provider.of<TaskProviders>(dialogContext, listen: false)
                .removeTask(index);

            // Close the dialog
            Navigator.of(dialogContext).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}


 
  void _showEditTaskDialog(BuildContext context) {
  final controller = TextEditingController(text: task.name);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter task name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newName = controller.text.trim();
            if (newName.isEmpty) return;

            try {
              
              Provider.of<TaskProviders>(dialogContext, listen: false)
                  .updateTask(index, newName);

              
              Navigator.of(dialogContext).pop();
            } catch (e, st) {
              
              debugPrint('updateTask error: $e\n$st');
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not update task')),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text('Update'),
        ),
      ],
    ),
  );
}


  
  
  @override
  Widget build(BuildContext context) {
    final progress = task.progress;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubtaskScreen(
                taskIndex: index,
                task: task,
              ),
            ),
          );
        },
        onLongPress: () {
          _showTaskOptions(context); 
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${task.subtasks.length} subtasks',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



