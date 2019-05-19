import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/pages/task_detailer/task_detailer.dart';
import 'package:np_time/pages/task_mutation/task_mutation.dart';
import 'package:np_time/pages/task_timer/task_timer.dart';
import 'package:np_time/theme.dart';

import './pages/home/home.dart';
import './db/database.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: CustomTheme.secondaryColor,
        primaryColor: CustomTheme.secondaryColor,
        backgroundColor: CustomTheme.secondaryColor,
        scaffoldBackgroundColor: CustomTheme.backgroundColor,

        // dialogs
        dialogBackgroundColor: CustomTheme.primaryColor,
        cardColor: CustomTheme.primaryColor,
        canvasColor: CustomTheme.primaryColor,
      ),
      routes: {
        '/': (BuildContext context) => HomeWrapper(),
      },
      onGenerateRoute: (RouteSettings route) {
        switch (route.name) {
          case '/task/create':
            Task task = route.arguments as Task;
            return MaterialPageRoute(
              builder: (context) => TaskMutation(
                    taskToEdit: task,
                  ),
            );

          case '/task/view':
            Task task = route.arguments as Task;
            return MaterialPageRoute(builder: (context) => TaskDetailer(task));

          case '/task/timer':
            List<dynamic> vars = route.arguments as List<dynamic>;
            Task task = vars[0] as Task;
            int subtaskIndex = vars[1] as int;
            return MaterialPageRoute(builder: (context) => TaskTimer(task, subtaskIndex));
        }
      },
    );
  }
  
  // todo make notifications work
  // todo make task repeating work
  // todo add fully customisable repeat dialog
  // todo replace all dividers + text styles with CustomTheme
}
