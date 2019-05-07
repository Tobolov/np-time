import 'package:flutter/material.dart';

import '../summary/summary.dart';
import '../tasks/tasks.dart';
import '../history/history.dart';
import './home_search_delegate.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("NP Time"),
          bottom: _buildTabBar(context),
          actions: _buildAppBarActions(context),
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

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
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
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(),
          );
        },
      ),
    ];
  }
}
