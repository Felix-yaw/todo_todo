import 'package:flutter/material.dart';
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        final  newTasktitle = showModalBottomSheet(context: context, builder: (context) => AddTask());

      }, 
      backgroundColor: Colors.black,
      child: Icon(Icons.add, color: Colors.white)
      
      ),
      body: Column(children: [
        ListView(children: [
          TaskTile(),
        ],
    
        )
        
      ],)

    
    );
  }
}