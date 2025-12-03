import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
 // final String newTasktitle;
  const TaskTile({super.key,
   //required this.newTasktitle
   });


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListTile( 
        leading: Text('Buy a house', style: TextStyle(fontWeight: FontWeight.bold, fontSize:20)), 
        trailing:
        Checkbox(value: false, onChanged: null)
      ,)
    );
  }
}
