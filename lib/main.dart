import 'package:flutter/material.dart';

import './pages/home/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: const Color(0xFF00838F),
          primaryColor: const Color(0xFF00838F),
          backgroundColor: const Color(0xFF27272F),
        ),
        routes: {
          '/': (BuildContext context) => HomeWrapper()
        });
  }
}
