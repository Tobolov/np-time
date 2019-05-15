import 'package:flutter/material.dart';
import 'package:grec_minimal/grec_minimal.dart';
import 'package:np_time/db/database.dart';
import 'package:np_time/pages/home/fake_entries.dart';
import 'package:np_time/pages/home/home_bloc.dart';
import 'package:np_time/pages/home/sorting_bottom_sheet.dart';

import 'package:np_time/pages/summary/summary.dart';
import 'package:np_time/pages/tasks/tasks.dart';
import 'package:np_time/pages/history/history.dart';
import 'package:np_time/widgets/modal_bottom_sheet.dart';
import '../../theme.dart';
import './home_search_delegate.dart';
import './home_fab.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/logged_time.dart';

class HomeWrapper extends StatelessWidget {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    homeBloc.updateFab(
      ApplicationFab(
        icon: Icons.add,
        onPressed: () {
          Navigator.pushNamed(context, '/task/create');
        },
      ),
    );
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Npolynomial Time"),
          bottom: _buildTabBar(context),
          actions: _buildAppBarActions(context),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
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
          text: 'Archive',
          icon: Icon(Icons.archive),
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
                Navigator.pushNamed(context, '/task/create');
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
      PopupMenuButton<DropdownChoice>(
        onSelected: _dropdownOnSelected,
        itemBuilder: (BuildContext context) {
          return <PopupMenuItem<DropdownChoice>>[
            PopupMenuItem<DropdownChoice>(
              value: DropdownChoice.SortTasks,
              child: Text('Sort tasks'),
            ),
            PopupMenuItem<DropdownChoice>(
              value: DropdownChoice.CreateFakeDatabase,
              child: Text('Add fake entries'),
            ),
            PopupMenuItem<DropdownChoice>(
              value: DropdownChoice.DeleteDatabse,
              child: Text('Delete database'),
            ),
          ];
        },
      ),
    ];
  }

  void _dropdownOnSelected(DropdownChoice choice) {
    switch (choice) {
      case DropdownChoice.CreateFakeDatabase:
        FakeEntries.addEntries();
        break;

      case DropdownChoice.DeleteDatabse:
        tasksBloc.deleteDatabase();
        break;

      case DropdownChoice.SortTasks:
        _showSortingTasksBottomSheet();
        break;
    }
  }

  void _showSortingTasksBottomSheet() {
    showModalBottomSheetApp<void>(
      context: _context,
      builder: (BuildContext context) {
        return SortingBottomSheet();
      },
    );
  }
}

enum DropdownChoice {
  CreateFakeDatabase,
  DeleteDatabse,
  SortTasks,
}
