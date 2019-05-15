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
  final Color _weightColorZero = CustomTheme.primaryColor;
  final Color _weightColorMax = CustomTheme.secondaryColor;
  final double _gapGridHorizontal = 10;
  final double _gapGridVertical = 14;
  final double _gridLabelFontSize = 14;
  final double _maxMinutesInDayTile = 4 * 60.0;

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Activity Log',
              style: CustomTheme.buildTextStyle(size: 19),
            ),
          ),
          SizedBox(height: 10),
          ..._buildDataGrid(),
          SizedBox(height: 10),
          _buildLessMoreIndicator(),
          SizedBox(height: 100),
        ],
      ),
    );
  }

//=======================================================================================
//                                       Shared
//=======================================================================================
  Color _generateWeightedColor(double weight) {
    assert(weight >= 0 && weight <= 1);
    return Color.lerp(_weightColorZero, _weightColorMax, weight);
  }

  bool _isSameDay(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

//=======================================================================================
//                               Data Grid View [UI ASPECT]
//=======================================================================================
  List<Widget> _buildDataGrid() {
    List<Widget> dataGridRow = [];

    // add the headers
    List<Widget> headerRow = [Expanded(child: SizedBox())];
    for (String header in weekdayLabels) {
      headerRow.add(Expanded(
        child: Transform.rotate(
          //alignment: Alignment.centerRight,
          angle: -math.pi / 4,
          child: Text(
            header,
            textAlign: TextAlign.center,
            style: CustomTheme.buildTextStyle(
              color: CustomTheme.textSecondary,
              size: _gridLabelFontSize,
            ),
          ),
        ),
      ));
    }
    dataGridRow.add(Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(children: headerRow),
    ));

    // calculate rows
    DateTime creationDateTime = widget._task.creationDateTruncated;
    DateTime currentDateTime = widget._task.creationDateTruncated;
    DateTime dueDateTime = widget._task.dueDateTruncated;

    // set drawn due date to today (truncated without time) if overdue
    DateTime dateTimeNow = DateTime.now();
    if (dueDateTime.isBefore(dateTimeNow)) {
      dueDateTime = DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);
    }

    while (true) {
      var result = _buildDataRow(creationDateTime, currentDateTime, dueDateTime);
      dataGridRow.add(result[0] as Widget);
      currentDateTime = result[1] as DateTime;

      if (result[2] as bool) break;
    }

    return dataGridRow;
  }

  /*
    incoming DateTime's must not container dateframes < day
  */
  List<dynamic> _buildDataRow(
      DateTime creationDate, DateTime startDate, DateTime endGridDate) {
    // calculate endDate
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
      startDate.millisecondsSinceEpoch,
    );
    String monthHeader = '';
    bool generationComplete = false;
    while (true) {
      if (_isSameDay(creationDate, endDate)) monthHeader = monthLabels[endDate.month - 1];
      if (endDate.day == 1) monthHeader = monthLabels[endDate.month - 1];
      if (_isSameDay(endDate, endGridDate)) {
        generationComplete = true;
        break;
      }
      if (endDate.weekday == DateTime.sunday) break;

      endDate = endDate.add(Duration(days: 1));
    }

    // calculate fromDrawDate and endDrawDate
    DateTime startWeekDate = startDate.subtract(Duration(days: startDate.weekday - 1));
    // add 1 more to make for loop later work
    DateTime endWeekDate = endDate.add(Duration(days: 7 - endDate.weekday + 1));

    // create row Widget and add month label
    List<Widget> rowWidgets = [];
    rowWidgets.add(Expanded(
      child: Text(
        monthHeader,
        style: CustomTheme.buildTextStyle(
          color: CustomTheme.textSecondary,
          size: _gridLabelFontSize,
        ),
      ),
    ));

    // add month Tiles
    for (DateTime date = startWeekDate;
        !_isSameDay(date, endWeekDate);
        date = date.add(Duration(days: 1))) {
      bool isOutOfTaskBound =
          date.isBefore(creationDate) || date.isAfter(endDate);
      rowWidgets.add(_buildDateCube(date, isOutOfTaskBound));
    }

    // create row with widgets
    Widget builtWidget = Row(
      children: rowWidgets,
    );

    return [builtWidget, endWeekDate, generationComplete];
  }

  double lerpDouble(num a, num b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }

  Widget _buildDateCube(DateTime dateTime, bool outOfScope) {
    double weight = lerpDouble(
      0,
      1,
      math.min(
        _maxMinutesInDayTile,
        widget._task.calculateTotalLoggedTimeOnDate(dateTime).inMinutes.toDouble(),
      ) / _maxMinutesInDayTile,
    );

    DateTime today = DateTime.now();
    bool isSameDay = _isSameDay(dateTime, today);
    double borderRadius = isSameDay ? 150 : 0;

    // do not display cube
    if (outOfScope) {
      return Expanded(child: SizedBox());
    }

    return Expanded(
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          alignment: Alignment.center,
          height: constraints.minWidth - _gapGridHorizontal,
          margin: EdgeInsets.symmetric(
              horizontal: _gapGridHorizontal / 2, vertical: _gapGridVertical / 2),
          child: Text(
            dateTime.day.toString(),
            style: CustomTheme.buildTextStyle(size: 18),
          ),
          decoration: BoxDecoration(
            color: _generateWeightedColor(weight),
            borderRadius: new BorderRadius.all(Radius.circular(borderRadius)),
          ),
        );
      }),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _buildLessMoreLabel('Less'),
          SizedBox(width: 6),
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
    return Text(label,
        style: CustomTheme.buildTextStyle(
            color: CustomTheme.textSecondary, size: _gridLabelFontSize));
  }

  Widget _buildLessMoreBox(double weight) {
    return Container(
      margin: EdgeInsets.only(right: 6),
      width: 16,
      height: 16,
      color: _generateWeightedColor(weight),
    );
  }
}
