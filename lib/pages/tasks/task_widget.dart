import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/logged_time.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/pages/task_detailer/log_time.dart';
import '../../theme.dart';

enum TaskWidgetSwipeBehaviour {
  None,
  ArchiveLog,
  Restore,
}

class TaskWidget extends StatelessWidget {
  final Task _task;
  final bool _snuffAlerts;
  final bool _deletedDate;
  final TaskWidgetSwipeBehaviour _swipeBehaviour;

  TaskWidget(this._task, this._snuffAlerts, this._deletedDate, this._swipeBehaviour);

  @override
  Widget build(BuildContext context) {
    if (_swipeBehaviour == TaskWidgetSwipeBehaviour.None) {
      return _buildTaskWidgetBody(context);
    }
    if (_swipeBehaviour == TaskWidgetSwipeBehaviour.ArchiveLog) {
      return Dismissible(
        key: Key(_task.id.toString()),
        child: _buildTaskWidgetBody(context),
        direction: DismissDirection.horizontal,
        background: _buildTaskDissmissableBackground(
            'Archive', CustomTheme.errorColor, Icons.archive, MainAxisAlignment.start),
        secondaryBackground: _buildTaskDissmissableBackground(
            'Log Time', CustomTheme.accent, Icons.timer, MainAxisAlignment.end),
        confirmDismiss: (direction) async {
          // only dissmiss if deleting
          if (direction == DismissDirection.startToEnd) {
            return true;
          }
          // log time to task
          if (direction == DismissDirection.endToStart) {
            displayLogTimeDialogForUnkownSubtask(context, _task);
            return false;
          }
          return false;
        },
        onDismissed: (direction) {
          // delete the task
          if (direction == DismissDirection.startToEnd) {
            tasksBloc.delete(_task);

            //todo replace with undo
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("item dismissed")));
          }
        },
      );
    }
    if (_swipeBehaviour == TaskWidgetSwipeBehaviour.Restore) {
      return Dismissible(
        key: Key(_task.id.toString()),
        child: _buildTaskWidgetBody(context),
        direction: DismissDirection.endToStart,
        background: _buildTaskDissmissableBackground(
            'Restore', CustomTheme.greenColor, Icons.restore, MainAxisAlignment.start),
        secondaryBackground: _buildTaskDissmissableBackground(
            'Restore', CustomTheme.greenColor, Icons.restore, MainAxisAlignment.end),
        onDismissed: (direction) {
          tasksBloc.restore(_task);
        },
      );
    }
  }

  Widget _buildTaskDissmissableBackground(
      String label, Color color, IconData icon, MainAxisAlignment mainAxisAlignment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: color,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: () {
          var widgets = <Widget>[
            Text(label, style: CustomTheme.buildTextStyle(weight: FontWeight.w400)),
            SizedBox(width: 16),
            Icon(icon),
          ];
          return mainAxisAlignment == MainAxisAlignment.end
              ? widgets
              : widgets.reversed.toList();
        }(),
      ),
    );
  }

  Widget _buildTaskWidgetBody(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Container(
                width: 77,
                alignment: Alignment.center,
                child: () {
                  if (_task.percentComplete == 100) {
                    return Icon(Icons.done, size: 33);
                  } else {
                    return _buildPercentDisplay(context);
                  }
                }()),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _task.percentComplete.toInt().toString(),
          style: TextStyle(
            fontSize: 28,
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
              fontSize: 28,
              fontFamily: 'TitilliumWeb',
              fontWeight: FontWeight.w200,
              color: CustomTheme.textDisabled,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildInformativeInformation(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _task.title,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w300,
                color: CustomTheme.textPrimary,
              ),
            ),
            Text(
              _deletedDate ? _task.dateDeletedString : _task.dueDateString,
              style: TextStyle(
                fontSize: 13,
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
    double minWidth = 16;

    // snuff if disabled
    if (_snuffAlerts) {
      return SizedBox(
        width: minWidth,
      );
    }

    // task is overdue
    if (_task.dueDate.compareTo(DateTime.now()) < 0) {
      int daysOverdue = _task.dueDate.difference(DateTime.now()).inDays;
      String overdueString;
      if (daysOverdue == 1) {
        overdueString = '1 day';
      } else {
        overdueString = '$daysOverdue days';
      }
      return _buildAlertButton(
        icon: Icons.error,
        color: CustomTheme.errorColor,
        onTap: () => _displaySnackbar(context, 'Task is overdue by $overdueString'),
      );
    }

    // task due in 3 days
    if (_task.dueDate.compareTo(DateTime.now().add(Duration(days: 3))) < 0) {
      int daysTillDue = _task.dueDate.difference(DateTime.now()).inDays;
      String dueInString;
      if (daysTillDue == 1) {
        dueInString = 'tommorow';
      } else {
        dueInString = 'in $daysTillDue days';
      }
      return _buildAlertButton(
        icon: Icons.warning,
        color: CustomTheme.accent,
        onTap: () => _displaySnackbar(context, 'Task is due $dueInString'),
      );
    }

    // task stale
    if (_task.subtasks.length >= 1) {
      DateTime lastLoggedTime = DateTime.fromMillisecondsSinceEpoch(0);
      for (Subtask subtask in _task.subtasks) {
        for (LoggedTime loggedTime in subtask.loggedTimes) {
          if (lastLoggedTime.compareTo(loggedTime.date) > 0)
            lastLoggedTime = loggedTime.date;
        }
      }
      if (lastLoggedTime.difference(DateTime.now()) > Duration(days: 3)) {
        // task has not been worked on for 3+ days.
        int daysStale = _task.dueDate.difference(DateTime.now()).inDays;
        return _buildAlertButton(
          icon: Icons.warning,
          color: CustomTheme.accent,
          onTap: () => _displaySnackbar(
              context, 'Task has not been worked on for $daysStale days'),
        );
      }
    }
    return SizedBox(
      width: minWidth,
    );
  }

  void _displaySnackbar(BuildContext context, String label) {
    final snackBar = SnackBar(
      content: Text(label),
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: 'DISMISS',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget _buildAlertButton(
      {@required IconData icon, @required Color color, @required Function onTap}) {
    return IconButton(
      padding: EdgeInsets.only(right: 16),
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: onTap,
    );
  }
}
