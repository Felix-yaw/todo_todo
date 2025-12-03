import 'package:flutter/material.dart';
import 'package:todo_todo/models/task.dart';


class TaskProviders extends ChangeNotifier{
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String name){
    _tasks.add(Task(name:name));
    notifyListeners();
  }

  void removeTask(int index){
    _tasks.removeAt(index);
    notifyListeners();
  }

  void  toggleTask(int index){
        _tasks[index].toggleTask();
  }




}