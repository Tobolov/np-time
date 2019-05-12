import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_time/pages/task_timer/task_timer_bloc.dart';

import '../../theme.dart';

class TaskTimerCounter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskTimerCounterState();
  }
}

class _TaskTimerCounterState extends State<StatefulWidget> {
  int millisecondsElapsed;
  StreamSubscription<int> millisecondsElapsedSubscription;

  @override
  void initState() {
    super.initState();
    millisecondsElapsed = 0;

    millisecondsElapsedSubscription =
        taskTimerBloc.durationNewlyLogged.listen((duration) {
      setState(() => millisecondsElapsed = duration);
    });
  }

  @override
  void dispose() {
    millisecondsElapsedSubscription.cancel();    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalMilliSeconds = millisecondsElapsed;

    String milliSeconds = ((totalMilliSeconds % 1000) ~/ 10).toString().padLeft(2, '0');
    totalMilliSeconds = totalMilliSeconds ~/ 1000;

    String seconds = (totalMilliSeconds % 60).toString().padLeft(2, '0');
    totalMilliSeconds = totalMilliSeconds ~/ 60;

    String minutes = (totalMilliSeconds).toString().padLeft(2, '0');

    String timerLabel = '$minutes:$seconds.$milliSeconds';

    return Text(timerLabel,
        style: CustomTheme.buildTextStyle(size: 45, weight: FontWeight.w400));
  }
}
