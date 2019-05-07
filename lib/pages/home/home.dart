import 'package:flutter/material.dart';

import '../summary/summary.dart';
import '../tasks/tasks.dart';
import '../history/history.dart';



class HomeWrapperState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("NP Time"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Summary',
                icon: Icon(Icons.show_chart),
              ),
              Tab(
                text: 'Tasks',
                icon: Icon(Icons.list),
              ),
              Tab(
                text: 'History',
                icon: Icon(Icons.history),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SummaryPage(),
            TasksPage(),
            HistoryPage(),
          ],
        ),
      ),
    );
  }
}
