import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
 // final String newTasktitle;
  const TaskTile({super.key,
   //required this.newTasktitle
   });


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Row(children: [
        Text('Buy a house', ), 
        Spacer(),
        Checkbox(value: false, onChanged: null)
      ],)
    );
  }
}
