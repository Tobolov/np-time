import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/logged_time.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/pages/task_timer/task_timer_bloc.dart';
import 'package:np_time/pages/task_timer/task_timer_completion.dart';
import 'package:np_time/pages/task_timer/task_timer_counter.dart';
import 'package:np_time/presentation/custom_icons_icons.dart';

import '../../theme.dart';

class TaskTimer extends StatefulWidget {
  final Task _task;
  final int _subtaskIndex;

  TaskTimer(this._task, this._subtaskIndex);

  @override
  State<StatefulWidget> createState() {
    return _TaskTimerState();
  }
}

class _TaskTimerState extends State<TaskTimer> {
  Timer timerUiUpdate;
  Stopwatch stopwatch;

  _TaskTimerState() {
    stopwatch = Stopwatch();
    stopwatch.start();

    timerUiUpdate = Timer.periodic(new Duration(milliseconds: 70), (timer) {
      taskTimerBloc.nextTimerTick(stopwatch.elapsedMilliseconds);
    });
  }

  @override
  void dispose() {
    timerUiUpdate.cancel();
    stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTaskHeader(),
            CustomTheme.buildDivider(horizontalMargin: 0, verticalMargin: 16),
            _buildEstimatedTimeRow(),
            Expanded(child: Center(child: TaskTimerCounter())),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: () {
          Subtask subtask = widget._task.subtasks[widget._subtaskIndex];
          subtask.loggedTimes.add(LoggedTime(
            date: DateTime.now(),
            timespan: Duration(milliseconds: stopwatch.elapsedMilliseconds),
          ));
          tasksBloc.logTime(subtask);
          Navigator.pop(context);
        },
      ),
    );
  }

//=======================================================================================
//                                    Task Header
//=======================================================================================

  Widget _buildTaskHeader() {
    String timeRemainingLabel;

    if (widget._task.isSimple) {
      String dateDueString =
          DateFormat('d MMM yyyy').format(widget._task.dueDate.toLocal());
      timeRemainingLabel = '${widget._task.dueDateString} ($dateDueString)';
    } else {
      timeRemainingLabel = widget._task.subtasks[widget._subtaskIndex].name;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TaskTimerCompletion(widget._task, widget._subtaskIndex),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget._task.title,
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w300,
                      fontSize: 27,
                      color: CustomTheme.textPrimary,
                    ),
                  ),
                  Text(
                    timeRemainingLabel,
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: CustomTheme.textSecondary,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//=======================================================================================
//                                  Estimated Time
//=======================================================================================
  Widget _buildEstimatedTimeRow() {
    String estimatedDurationLabel = widget._task.estimatedDurationString(subtaskIndex: widget._subtaskIndex);
    Color estimatedDurationLabelColor = CustomTheme.textPrimary;

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 16),
          child: Icon(CustomIcons.target),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              estimatedDurationLabel,
              style: CustomTheme.buildTextStyle(color: estimatedDurationLabelColor),
            ),
          ),
        ),
      ],
    );
  }
}
