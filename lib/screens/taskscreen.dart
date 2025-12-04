import 'package:flutter/material.dart';
import 'package:todo_todo/providers/task_providers.dart';
import 'package:todo_todo/screens/addtask.dart';
import 'package:todo_todo/widgets/tasktile.dart';
import 'package:provider/provider.dart';
class TaskScreen extends StatelessWidget {

  final TextEditingController taskController =TextEditingController();

  final int total1;
   TaskScreen({super.key, required this.total1});
  
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
        body: Consumer<TaskProviders>(
          builder:(context, taskData, child){
            return ListView.builder(itemCount: taskData.tasks.length, itemBuilder: (context, index){
              final task = taskData.tasks[index];
              return TaskTile(index: index, task: task, );
            },);
          }
        ) ,
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // ignore: unused_local_variable
        final String newTasktitle = await showModalBottomSheet(context: context, builder: (context) => AddTask(controller: taskController));
        if(newTasktitle != null && newTasktitle.isNotEmpty){
          context.read<TaskProviders>().addTask(newTasktitle);
          taskController.clear();
        }

      }, 
      backgroundColor: Colors.black,
      child: Icon(Icons.add, color: Colors.white)
      
      ),

     //

    
    );
  }
}