import 'package:flutter/material.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/logged_time.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/pages/tasks/task_list_widget.dart';

import '../../theme.dart';

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildStatisticsArea(),
        Container(
          margin: EdgeInsets.only(left: 16, top: 16),
          child: Text('Next 3 tasks due', style: CustomTheme.buildTextStyle()),
        ),
        TasksList(
          noData: 'No tasks exist.',
          sortingFunction: (task1, task2) => task1.dueDate.compareTo(task2.dueDate),
          maxDisplayedTasks: 3,
          snuffAlerts: true,
          scrollable: false,
        ),
      ],
    );
  }

//=======================================================================================
//                                    Shared
//=======================================================================================

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: CustomTheme.textDisabled,
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14),
      width: 1,
      color: CustomTheme.textDisabled,
    );
  }


//=======================================================================================
//                                    Statistics area
//=======================================================================================
  Widget _buildStatisticsArea() {
    return StreamBuilder(
      stream: tasksBloc.tasks,
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.hasData) {
          List<Task> tasks = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildStatistic(
                        'Hours remaining',
                        _calculateHoursRemaining(tasks).toStringAsFixed(1),
                        'hrs',
                      ),
                      _buildVerticalDivider(),
                      _buildStatistic(
                        'Past 7 days',
                        _calculateHoursPast7Days(tasks).toStringAsFixed(1),
                        'hrs',
                      ),
                    ],
                  ),
                ),
                _buildDivider(),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildStatistic(
                        'Task Streak',
                        _calculateTaskStreak(tasks).toString(),
                        'days',
                      ),
                      _buildVerticalDivider(),
                      _buildStatistic(
                        'Average Hours',
                        _calculateAverageHours(tasks).toStringAsFixed(1),
                        'hrs/day',
                      ),
                    ],
                  ),
                ),
                _buildDivider(),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildStatistic(String title, String value, String valueUnit) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: CustomTheme.buildTextStyle()),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text(value, style: CustomTheme.buildTextStyle(size: 30)),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    valueUnit,
                    style: CustomTheme.buildTextStyle(
                      size: 30,
                      color: CustomTheme.textDisabled,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

//=======================================================================================
//                                    Calculating Statistics
//=======================================================================================

  double _calculateHoursRemaining(List<Task> tasks) {
    Duration duration = Duration.zero;
    for (Task task in tasks) {
      if (task.deleted == null) continue;
      duration += task.estimatedDuration;
    }
    return duration.inMinutes / 60;
  }

  double _calculateHoursPast7Days(List<Task> tasks) {
    Duration duration = Duration.zero;
    for (Task task in tasks) {
      for (Subtask subtask in task.subtasks) {
        for (LoggedTime loggedTime in subtask.loggedTimes) {
          if (loggedTime.date.difference(DateTime.now()) < Duration(days: 7)) {
            duration += loggedTime.timespan;
          }
        }
      }
    }
    return duration.inHours / 60;
  }

  int _calculateTaskStreak(List<Task> tasks) {
    DateTime now = DateTime.now();
    DateTime nowDiff;
    int daysAgo = 0;
    while (true) {
      outerLoop:
      for (Task task in tasks) {
        nowDiff = now.subtract(Duration(days: daysAgo + 1));
        for (Subtask subtask in task.subtasks) {
          for (LoggedTime loggedTime in subtask.loggedTimes) {
            if (loggedTime.date.isAfter(nowDiff)) {
              daysAgo++;
              continue outerLoop;
            }
          }
        }
      }
      return daysAgo;
    }
  }

  double _calculateAverageHours(List<Task> tasks) {
    int averageDurationInDays = 7;

    Duration duration = Duration.zero;
    for (Task task in tasks) {
      for (Subtask subtask in task.subtasks) {
        for (LoggedTime loggedTime in subtask.loggedTimes) {
          if (loggedTime.date.difference(DateTime.now()) <
              Duration(days: averageDurationInDays)) {
            duration += loggedTime.timespan;
          }
        }
      }
    }
    return duration.inHours / averageDurationInDays;
  }
}
