import 'package:flutter/material.dart';
import 'package:todo_todo/providers/task_providers.dart';
import 'package:todo_todo/screens/addtask.dart';
import 'package:todo_todo/widgets/tasktile.dart';

class TaskScreen extends StatelessWidget {

  final int total1;
  const TaskScreen({super.key, required this.total1});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title:Row(
            children: [
              Center(child: Text('Todo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Spacer(),
              Text('Total = $total1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

            ],
          )
        ),
        body: Builder(
          builder: (context) {
            final tasks = context.watch<TaskProviders>().tasks;
            return ListView(

            );
          }
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        // ignore: unused_local_variable
        final  newTasktitle = showModalBottomSheet(context: context, builder: (context) => AddTask());

      }, 
      backgroundColor: Colors.black,
      child: Icon(Icons.add, color: Colors.white)
      
      ),

     //

    
    );
  }
}