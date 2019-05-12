import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/pages/task_timer/task_timer_bloc.dart';

import '../../theme.dart';

class TaskTimerCompletion extends StatefulWidget {
  final Task _task;
  final int _subtaskindex;

  TaskTimerCompletion(this._task, this._subtaskindex);

  @override
  State<StatefulWidget> createState() {
    return _TaskTimerCompletion();
  }
}

class _TaskTimerCompletion extends State<TaskTimerCompletion> {
  int millisecondsElapsed;
  int taskTotalRemainingSeconds;
  double percentExistinglyComplete;
  Timer triggerUpdate;

  @override
  void initState() {
    super.initState();
    millisecondsElapsed = 0;

    triggerUpdate = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        millisecondsElapsed = taskTimerBloc.getTimerTick();
      });
    });

    // these calculations can be taxing, cache the result
    percentExistinglyComplete = widget._task.subtasks[widget._subtaskindex].percentComplete;
    if (percentExistinglyComplete < 0.1) {
      taskTotalRemainingSeconds = widget._task.subtasks[widget._subtaskindex].estimatedDuration.inSeconds;
    } else {
      taskTotalRemainingSeconds =
          (widget._task.subtasks[widget._subtaskindex].estimatedDuration.inSeconds * (1 - percentExistinglyComplete / 100))
              .toInt();
    }
  }

  @override
  void dispose() {
    triggerUpdate.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    int secondsTimerElapsed = millisecondsElapsed ~/ (1000);
    double taskNewlyCompleteRatio = secondsTimerElapsed / taskTotalRemainingSeconds;
    if (taskNewlyCompleteRatio.isNaN || taskNewlyCompleteRatio > 1) {
      taskNewlyCompleteRatio = 1;
    }
    double taskNewlyCompletePercent = (100 - percentExistinglyComplete) * taskNewlyCompleteRatio;

    double totalPercentComplete = percentExistinglyComplete + taskNewlyCompletePercent;
    String percentCompelteLabel = totalPercentComplete.toInt().toString();

    int emptyFlex = 100 - percentExistinglyComplete.toInt() - taskNewlyCompletePercent.toInt();
    int filledFlex = percentExistinglyComplete.toInt();
    int changedFlex = taskNewlyCompletePercent.toInt();

    double outerWidth = 4;
    double innerWidth = 2.5;
    double edgeDiff = (outerWidth - innerWidth) / 2;
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(
            percentCompelteLabel,
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w300,
              fontSize: 35,
              color: CustomTheme.textPrimary,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 0),
          child: Container(
            width: outerWidth,
            color: CustomTheme.textPrimary,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(vertical: edgeDiff),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: emptyFlex,
                  child: Container(),
                ),
                Expanded(
                  flex: changedFlex,
                  child: Container(
                    width: innerWidth,
                    color: CustomTheme.secondaryLight,
                  ),
                ),
                Expanded(
                  flex: filledFlex,
                  child: Container(
                    width: innerWidth,
                    color: CustomTheme.backgroundColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
