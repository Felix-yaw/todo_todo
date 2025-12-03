import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
   AddTask({super.key});
      final controller= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.only(left:20, right:20),
        child: Column(children: [
          SizedBox(height:20),
          Text('Add a new Task', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height:10),

          TextField(controller: controller, textAlign: TextAlign.center,),
          SizedBox(height:20),
          Container(
            padding: EdgeInsets.only(left: 60, right: 60),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20)),
              child: TextButton(onPressed: (){
                if(controller.text.trim().isNotEmpty){
                  Navigator.pop(context, controller.text.trim());
                }
            
            },
            child: Text('Add Task', style: TextStyle(color:Colors.white))
            ),
            
             ),
          
        ],
        ),
      )
    );
  }
}