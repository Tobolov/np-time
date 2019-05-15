import 'package:flutter/material.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/logged_time.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/presentation/custom_icons_icons.dart';
import 'package:np_time/widgets/dial_selector.dart';
import 'package:np_time/widgets/modal_bottom_sheet.dart';

import '../../theme.dart';

void displayLogTimeDialogForUnkownSubtask(BuildContext context, Task task) {
  if (task.isSimple) {
    displayLogTimeDialog(context, 0, false, task);
    return;
  }
  showModalBottomSheetApp<void>(
    context: context,
    dismissOnTap: true,
    builder: (BuildContext context1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: () {
          List<Widget> widgets = [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: Text(
                'Select Subtask',
                style: CustomTheme.buildTextStyle(size: 25),
              ),
            ),
            Divider(),
          ];
          for (int index = 0; index < task.subtasks.length; index++) {
            widgets.add(
              ListTile(
                title: Text(task.subtasks[index].name, style: CustomTheme.buildTextStyle()),
                onTap: () {
                  Navigator.pop(context);
                  displayLogTimeDialog(context, index, true, task);
                },
              ),
            );
          }
          return widgets;
        }(),
      );
    },
  );
}

void displayLogTimeDialog(
    BuildContext context, int subtaskIndex, bool isSubtask, Task task,
    {Function onSelected}) {
  showModalBottomSheetApp<void>(
    context: context,
    dismissOnTap: true,
    builder: (BuildContext context1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLogTimeItem(Icons.timer, 'Start timer', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/task/timer', arguments: [task, subtaskIndex]);
          }),
          _buildLogTimeItem(CustomIcons.wrench, 'Log time manually', () {
            Navigator.pop(context);
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) => DialSelector(
                    title: 'Time to log',
                    initalDialValues: <int>[0, 0],
                    onSelected: (List<int> dialValues) async {
                      Subtask subtask = task.subtasks[subtaskIndex];
                      subtask.loggedTimes.add(LoggedTime(
                        date: DateTime.now(),
                        timespan: Duration(
                          hours: dialValues[0],
                          minutes: dialValues[1],
                        ),
                      ));
                      await tasksBloc.logTime(subtask);
                      if (onSelected != null) onSelected();
                    },
                    dialTitles: <String>['Hours', 'Minutes'],
                    dialMaxs: <int>[100, 60],
                  ),
            );
          }),
          _buildLogTimeItem(
            Icons.done,
            'Mark ${isSubtask ? 'sub' : ''}task as complete',
            () async {
              Subtask subtask = task.subtasks[subtaskIndex];
              int secondsRemaining =
                  subtask.estimatedDuration.inSeconds - subtask.totalLoggedTime.inSeconds;
              subtask.loggedTimes.add(LoggedTime(
                date: DateTime.now(),
                timespan: Duration(seconds: secondsRemaining),
              ));
              await tasksBloc.logTime(subtask);
              if (onSelected != null) onSelected();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Widget _buildLogTimeItem(IconData icon, String title, Function onTap) {
  return ListTile(
    leading: Icon(icon, color: CustomTheme.textPrimary),
    title: Text(title, style: CustomTheme.buildTextStyle()),
    onTap: onTap,
  );
}
