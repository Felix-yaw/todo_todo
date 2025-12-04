import 'package:flutter/material.dart';
import 'package:todo_todo/models/task.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/providers/task_providers.dart';
import 'package:todo_todo/screens/addtask.dart';

class TaskTile extends StatelessWidget {
  final TextEditingController controller;
 final Task task;
 final int index;
  const TaskTile({super.key, required this.task, required this.index, required this.controller
   //required this.newTasktitle
   });


  @override
  Widget build(BuildContext context) {
    return  ListTile( 
        leading: Text(task.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize:20)), 
        trailing:
        Checkbox(
          value: task.isDone,
          onChanged: (value){
            Provider.of<TaskProviders>(context, listen: false).toggleTask(index);
          },
          
          ),
          onTap: () {
            Navigator.push(context:context, builder: (context) => AddTask(controller: controller));

          },
    );
  }
}
