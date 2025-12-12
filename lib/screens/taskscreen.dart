
import 'package:flutter/material.dart';
import 'package:todo_todo/providers/task_providers.dart';
import 'package:todo_todo/widgets/tasktile.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProviders>(
      builder: (context, taskData, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                const Text(
                  'My Tasks',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 200),
                Text(
                  "${taskData.tasks.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          body: taskData.tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks yet. Add one to get started!',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: taskData.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskData.tasks[index];
                    return TaskTile(
                      index: index,
                      task: task,
                    );
                  },
                ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddTaskDialog(context);
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: ()async {
              if (controller.text.trim().isNotEmpty) {
                await context.read<TaskProviders>().addTask(controller.text.trim());
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
