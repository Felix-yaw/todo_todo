import 'package:flutter/material.dart';
import 'package:todo_todo/providers/task_providers.dart';
import 'package:todo_todo/screens/taskscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => TaskProviders(),
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskScreen(total1: 0),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
