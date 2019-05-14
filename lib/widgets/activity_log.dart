import 'package:flutter/material.dart';
import 'package:np_time/models/task.dart';

import 'dart:math' as math;

import 'package:np_time/theme.dart';

class ActivityLog extends StatefulWidget {
  final Task _task;

  ActivityLog(this._task);

  @override
  State<StatefulWidget> createState() {
    return _ActivityLogState();
  }
}

class _ActivityLogState extends State<ActivityLog> {
  final _weightColorZero = CustomTheme.backgroundColor;
  final _weightColorMax = CustomTheme.secondary;

  // logical constants
  List<String> weekdayLabels = ['Mon', 'Tue', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Activity Log'),
        ..._buildDataGrid(),
        _buildLessMoreIndicator(),
      ],
    );
  }

//=======================================================================================
//                                       Shared
//=======================================================================================
  Color _generateWeightedColor(double weight) {
    assert(weight > 0 && weight < 1);
    return Color.lerp(_weightColorZero, _weightColorMax, weight);
  }

//=======================================================================================
//                               Data Grid View [UI ASPECT]
//=======================================================================================
  List<Widget> _buildDataGrid() {
    List<Widget> dataGridRow = [];

    // add the headers
    List<Widget> headerRow = [];
    for (String header in weekdayLabels) {
      headerRow.add(Transform.rotate(
        angle: -math.pi / 4,
        child: Text(
          header,
        ),
      ));
    }
    dataGridRow.add(Row(children: headerRow));

    // calculate rows
    DateTime currentDateTime = widget._task.creationDateTruncated;
    DateTime dueDateTime = widget._task.dueDateTruncated;
    while (true) {
      var result = _buildDataRow(currentDateTime, dueDateTime);
      dataGridRow.add(result[0] as Widget);
      currentDateTime = result[1] as DateTime;

      if (result[2] as bool) break;
    }

    return dataGridRow;
  }

  /*
    incoming DateTime's must not container dateframes < day
  */
  List<dynamic> _buildDataRow(DateTime startDate, DateTime endGridDate) {
    // calculate endDate
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
      startDate.millisecondsSinceEpoch,
    );
    String monthHeader = '';
    bool generationComplete = false;
    while (true) {
      if (endDate.day == 1) monthHeader = monthLabels[endDate.month];
      if (endDate.weekday == DateTime.sunday) break;
      if (endDate.isAtSameMomentAs(endGridDate)) {
        generationComplete = true;
        break;
      }

      endDate = endDate.add(Duration(days: 1));
    }

    // calculate fromDrawDate and endDrawDate
    DateTime startWeekDate = startDate.subtract(Duration(days: startDate.weekday));
    // add 1 more to make for loop later work
    DateTime endWeekDate = endDate.add(Duration(days: 6 - startDate.weekday + 1));

    // create row Widget and add month label
    List<Widget> rowWidgets = [];
    rowWidgets.add(Text(monthHeader));

    // add month Tiles
    for (DateTime date = startWeekDate;
        date != endWeekDate;
        date = date.add(Duration(days: 1))) {
      rowWidgets.add(_buildDateCube(date));
    }

    // create row with widgets
    Widget builtWidget = Row(
      children: rowWidgets,
    );

    return [builtWidget, endDate, generationComplete];
  }

  Widget _buildDateCube(DateTime dateTime) {
    double weight = 0; //todo

    DateTime today = DateTime.now();
    bool isSameDay = dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;

    return Container(
      width: 0, // todo make dynamic from ActivityLog widgets width / 7 etc + for hieght
      color: _generateWeightedColor(weight),
      child: Text(
        dateTime.day.toString(),
        style: CustomTheme.buildTextStyle(size: 18),
      ),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(CustomTheme.borderRadius),
          topRight: Radius.circular(CustomTheme.borderRadius),
        ),
      ),
    );
  }

//=======================================================================================
//                            Data Grid View [LOGICAL ASPECT]
//=======================================================================================

//=======================================================================================
//                                   More Less Indicator
//=======================================================================================
  Widget _buildLessMoreIndicator() {
    return Container(
      child: Row(
        children: <Widget>[
          _buildLessMoreLabel('Less'),
          _buildLessMoreBox(0 / 4),
          _buildLessMoreBox(1 / 4),
          _buildLessMoreBox(2 / 4),
          _buildLessMoreBox(3 / 4),
          _buildLessMoreBox(4 / 4),
          _buildLessMoreLabel('More'),
        ],
      ),
    );
  }

  Widget _buildLessMoreLabel(String label) {
    return Text(label, style: CustomTheme.buildTextStyle());
  }

  Widget _buildLessMoreBox(double weight) {
    return Container(
      width: 16,
      height: 16,
      color: _generateWeightedColor(weight),
    );
  }
}
