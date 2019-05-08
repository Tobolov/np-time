import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:np_time/pages/task_mutation/task_mutation.dart';

import './pages/home/home.dart';
import './db/database.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DBProvider.db.deleteDB(); //todo REMOVE THIS
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: const Color(0xFF00838F),
          primaryColor: const Color(0xFF00838F),
          backgroundColor: const Color(0xFF00838F),
          scaffoldBackgroundColor: const Color(0xFF27272F),
        ),
        routes: {
          '/': (BuildContext context) => HomeWrapper(),
          '/create': (BuildContext context) => TaskMutation()
        });
  }
}
