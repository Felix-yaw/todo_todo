import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(children: [
        Text('Add a new Task', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        SizedBox(height:20),
        TextField(controller: TextEditingController(),)
      ],)
    );
  }
}