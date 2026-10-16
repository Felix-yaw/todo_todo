import 'package:flutter/material.dart';

/// Simple "add a task" form that pops the entered name back to its caller.
///
/// Currently unused by [TaskScreen] (which uses an inline dialog) but kept as
/// a reusable form.
class AddTask extends StatelessWidget {
  const AddTask({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            'Add a new Task',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            onSubmitted: (value) => Navigator.pop(context, value.trim()),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(left: 60, right: 60),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: const Text('Add Task', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
