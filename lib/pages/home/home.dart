import 'package:flutter/material.dart';
import 'package:np_time/pages/home/home_bloc.dart';

import '../summary/summary.dart';
import '../tasks/tasks.dart';
import '../history/history.dart';
import './home_search_delegate.dart';
import './home_fab.dart';
import '../tasks/tasks_bloc.dart';
import '../../models/task.dart';
import '../../models/subtask.dart';
import '../../models/logged_time.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Npolynomial Time"),
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
        floatingActionButton: HomeFloatingActionButton(),
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
      onTap: (int tabNum) {
        switch (tabNum) {
          case 0:
          case 2:
            homeBloc.updateFab(ApplicationFab.none);
            break;

          case 1:
            homeBloc.updateFab(ApplicationFab(
              icon: Icons.add,
              onPressed: () {
                //todo Fab interaction
                print("-- todo create task --");

                /*tasksBloc.add(
                  Task(
                    title: 'test',
                    description: 'UwU',
                    dueDate: DateTime.now(),
                    notification: <String>['1m', '5m'],
                    repeatCycle: '',
                    repeatStartDate: DateTime.now(),
                    deleted: false,
                    subtasks: <Subtask>[],
                  ),
                );*/

                Navigator.pushNamed(context, '/create');
              },
            ));
        }
      },
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
