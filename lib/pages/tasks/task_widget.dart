import 'package:flutter/material.dart';
import 'package:np_time/models/logged_time.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';
import '../../theme.dart';

class TaskWidget extends StatelessWidget {
  final Task _task;

  TaskWidget(this._task);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Row(
          children: <Widget>[
            _buildPercentDisplay(context),
            _buildInformativeInformation(context),
            _buildAlertSector(context),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/task/view', arguments: _task);
      },
    );
  }

  Widget _buildPercentDisplay(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Text(
            _task.percentComplete.toInt().toString(),
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w300,
              color: CustomTheme.textPrimary,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              '%',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'TitilliumWeb',
                fontWeight: FontWeight.w200,
                color: CustomTheme.textDisabled,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInformativeInformation(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _task.title,
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w400,
                color: CustomTheme.textPrimary,
              ),
            ),
            Text(
              _task.dueDateString,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w300,
                color: CustomTheme.textSecondary,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAlertSector(BuildContext context) {
    //todo set onTap handlers

    // task is overdue
    if (_task.dueDate.compareTo(DateTime.now()) < 0) {
      return _buildAlertButton(icon: Icons.error, color: CustomTheme.errorColor, onTap: () {});
    }

    // task due in 3 days
    if (_task.dueDate.compareTo(DateTime.now().add(Duration(days: 3))) < 0) {
      return _buildAlertButton(icon: Icons.warning, color: CustomTheme.accent, onTap: () {});
    }

    //todo task stale
    if (_task.subtasks.length >= 1) {
      DateTime lastLoggedTime = DateTime.fromMillisecondsSinceEpoch(0);
      for (Subtask subtask in _task.subtasks) {
        for (LoggedTime loggedTime in subtask.loggedTimes) {
          if (lastLoggedTime.compareTo(loggedTime.date) > 0)
            lastLoggedTime = loggedTime.date;
        }
      }
      if (lastLoggedTime.difference(DateTime.now()) > Duration(days: 3)) {
        // task has not been worked on for 3 days.
        return _buildAlertButton(icon: Icons.warning, color: CustomTheme.accent, onTap: () {});
      }
    }
    return Container();
  }

  Widget _buildAlertButton(
      {@required IconData icon, @required Color color, @required Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
