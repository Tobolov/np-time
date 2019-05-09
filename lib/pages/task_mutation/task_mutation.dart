import 'package:flutter/material.dart';
import 'package:grec_minimal/grec_minimal.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/presentation/custom_icons_icons.dart';
import 'package:np_time/theme.dart';
import 'package:intl/intl.dart';
import 'package:np_time/widgets/dial_selector.dart';

class TaskMutation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskMutationState();
  }
}

class _TaskMutationState extends State<TaskMutation> {
  final Task _task = Task.simple;
  var scaffold = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _titleKey = GlobalKey<FormFieldState>();

  static final weekdayMap = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
    null: '???',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        bottom: _buildTitleField(context),
        actions: _buildAppBarActions(context),
      ),
      body: Form(key: _formKey, child: _buildBody(context)),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: Container(
          margin: EdgeInsets.only(
            left: 52,
            bottom: 15,
          ),
          child: TextFormField(
            key: _titleKey,
            initialValue: _task.title ?? '',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w300,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter title',
              contentPadding: EdgeInsets.zero,
            ),
            onSaved: (value) {
              setState(() {
                _task.title = value;
              });
            },
          ),
        ));
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return <Widget>[
      Container(
        width: 65,
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
        child: RaisedButton(
          color: CustomTheme.secondaryLight,
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _titleKey.currentState.save();
              if (_task.title.isEmpty) {
                final snackBar = SnackBar(
                  content: Text('Please enter a title.'),
                  duration: Duration(seconds: 4),
                  action: SnackBarAction(
                    label: 'DISMISS',
                    onPressed: () {},
                  ),
                );
                scaffold.currentState.showSnackBar(snackBar);
                return;
              }

              if (_task.dueDate == null) {
                final snackBar = SnackBar(
                  content: Text('Please set a due date.'),
                  duration: Duration(seconds: 4),
                  action: SnackBarAction(
                    label: 'DISMISS',
                    onPressed: () {},
                  ),
                );
                scaffold.currentState.showSnackBar(snackBar);
                return;
              }

              tasksBloc.add(_task);
              Navigator.pop(context);
            }
          },
        ),
      )
    ];
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildDescriptionRow(context),
        _buildDivider(context),
        _buildDueDateRow(context),
        _buildDivider(context),
        _buildNotificationRow(context),
        _buildDivider(context),
        _buildRepeatRow(context),
        _buildDivider(context),
        _buildEstimatedTimeRow(context),
        _buildDivider(context),
      ],
    );
  }

//=======================================================================================
//                                    Shared
//=======================================================================================

  TextStyle _buildTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 19,
      fontFamily: 'RobotoCondensed',
      fontWeight: FontWeight.w300,
      color: CustomTheme.textPrimary,
    );
  }

  TextStyle _buildErrorTextStyle() {
    return TextStyle(
      fontSize: 12,
      fontFamily: 'RobotoCondensed',
      fontWeight: FontWeight.w300,
      color: CustomTheme.errorColor,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: CustomTheme.textDisabled,
      ),
    );
  }

//=======================================================================================
//                                    Description
//=======================================================================================

  Widget _buildDescriptionRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 6, right: 16),
            child: Icon(Icons.subject),
          ),
          Expanded(
            child: TextFormField(
              initialValue: _task.description ?? '',
              style: _buildTextStyle(context),
              minLines: 1,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Add description',
                border: InputBorder.none,
                helperStyle: _buildErrorTextStyle(),
                errorStyle: _buildErrorTextStyle(),
                contentPadding: EdgeInsets.symmetric(vertical: 6),
              ),
              onSaved: (value) {
                setState(() {
                  _task.description = value ?? '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

//=======================================================================================
//                                    Due Date
//=======================================================================================

  Widget _buildDueDateRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(Icons.calendar_today),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  _task.dueDate != null
                      ? DateFormat('EEE, d MMM yyyy').format(_task.dueDate.toLocal())
                      : 'Set due date',
                  style: _buildTextStyle(context),
                ),
              ),
              onTap: () => _selectDate(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _task.dueDate ?? DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _task.dueDate) {
      setState(() {
        _task.dueDate = picked;
      });
    }
  }

//=======================================================================================
//                                    Notification
//=======================================================================================

  Widget _buildNotificationRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildNotificationList(context),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: Text(
                    _task.notification.length == 0
                        ? 'Add a notification'
                        : 'Add another notification',
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w300,
                      color: _task.notification.length == 0
                          ? CustomTheme.textPrimary
                          : CustomTheme.textSecondary,
                    ),
                  ),
                ),
                onTap: () => _selectNotification(context),
              ),
            ],
          )),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationList(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    _task.notification.asMap().forEach((index, notification) {
      widgets.add(
        Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${notification.inDays} Days',
                  style: _buildTextStyle(context),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.close),
                ),
                onTap: () {
                  setState(() {
                    _task.notification.removeAt(index);
                  });
                },
              )
            ],
          ),
        ),
      );
    });
    return widgets;
  }

  Future<void> _selectNotification(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          children: <Widget>[
            _buildNotificationOption(
              title: '1 day before',
              onPressed: () {
                setState(() {
                  _task.notification.add(Duration(days: 1));
                });
              },
            ),
            _buildNotificationOption(
              title: '3 days before',
              onPressed: () {
                setState(() {
                  _task.notification.add(Duration(days: 3));
                });
              },
            ),
            _buildNotificationOption(
              title: '1 week before',
              onPressed: () {
                setState(() {
                  _task.notification.add(Duration(days: 7));
                });
              },
            ),
            _buildNotificationOption(
              title: 'Custom',
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) => DialSelector(
                        title: 'Notification',
                        initalDialValues: <int>[0, 0],
                        onSelected: (List<int> dialValues) {
                          setState(() {
                            _task.notification.add(
                              Duration(days: dialValues[0] * 7 + dialValues[1]),
                            );
                          });
                        },
                        dialMaxs: <int>[10, 7],
                        dialTitles: <String>['Weeks', 'Days'],
                      ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationOption(
      {@required String title, @required Function onPressed}) {
    return SimpleDialogOption(
      onPressed: () {
        onPressed();
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w300,
            color: CustomTheme.textPrimary,
          ),
        ),
      ),
    );
  }

//=======================================================================================
//                                    Repeat
//=======================================================================================

  Widget _buildRepeatRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5, right: 16),
            child: Icon(Icons.repeat),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  _task.rRule != null ? _verbaliseRRule(_task.rRule) : 'Does not repeat',
                  style: _buildTextStyle(context),
                ),
              ),
              onTap: () => _selectRepeat(context),
            ),
          ),
        ],
      ),
    );
  }

  String _verbaliseRRule(RecurrenceRule rRule) {
    String frequency = {
      Frequency.DAILY: 'day',
      Frequency.MONTHLY: 'month',
      Frequency.WEEKLY: 'week',
      Frequency.YEARLY: 'year',
      null: ''
    }[rRule.getFrequency()];

    String repeatDay = weekdayMap[rRule.getByday()?.getWeekday()?.elementAt(0)?.index];

    switch (rRule.getFrequency()) {
      case Frequency.WEEKLY:
        if (rRule.getInterval() == 1) {
          return 'Repeats every week on $repeatDay';
        } else {
          return 'Repeats every ${_stringifyNumber(rRule.getInterval())} week on $repeatDay';
        }
        break;
      case Frequency.MONTHLY:
        String frequency =
            rRule.getInterval() == 1 ? '' : _stringifyNumber(rRule.getInterval());
        if (rRule.getByday() != null) {
          String weekday = weekdayMap[rRule.getByday().getWeekday()[0].index];
          String weekdayNth = _stringifyNumber(rRule.getByday().getNth());
          return 'Repeats every $frequency month on the $weekdayNth $weekday';
        } else {
          return 'Repeats every $frequency month on the ${_stringifyNumber(_task.dueDate.day)}';
        }
        break;

      default:
        if (rRule.getInterval() == 1) {
          return 'Repeats every $frequency';
        } else {
          return 'Repeats every ${_stringifyNumber(rRule.getInterval())} $frequency';
        }
        break;
    }
  }

  String _stringifyNumber(int number) {
    String postfix;
    switch (number % 10) {
      case 1:
        postfix = 'st';
        break;
      case 2:
        postfix = 'nd';
        break;
      case 3:
        postfix = 'rd';
        break;
      default:
        postfix = 'th';
        break;
    }
    return '$number$postfix';
  }

  Future<void> _selectRepeat(BuildContext context) async {
    if (_task.dueDate == null) {
      final snackBar = SnackBar(
        content: Text('Due date must be set before assigning repeat schedule.'),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'SET DUE DATE',
          onPressed: () => _selectDate(context),
        ),
      );
      scaffold.currentState.showSnackBar(snackBar);
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          children: <Widget>[
            _buildRepeatOption(
              title: 'Every day',
              targetRule: RecurrenceRule(Frequency.DAILY, 365 * 100, null, 1, null),
            ),
            _buildRepeatOption(
              title: 'Every week on ${weekdayMap[_task.dueDate.weekday - 1]}',
              targetRule: RecurrenceRule(Frequency.WEEKLY, 365 * 100, null, 1,
                  Byday(<Weekday>[Weekday.values[_task.dueDate.weekday - 1]], null)),
            ),
            _buildRepeatOption(
              title:
                  'Every month on the ${_stringifyNumber((_task.dueDate.day - 1) ~/ 7)} ${weekdayMap[_task.dueDate.weekday - 1]}',
              targetRule: RecurrenceRule(
                Frequency.MONTHLY,
                365 * 100,
                null,
                1,
                Byday(<Weekday>[Weekday.values[_task.dueDate.weekday - 1]],
                    (_task.dueDate.day - 1) ~/ 7),
              ),
            ),
            _buildRepeatOption(
              title: 'Every month on the ${_stringifyNumber(_task.dueDate.day)}',
              targetRule: RecurrenceRule(Frequency.MONTHLY, 365 * 100, null, 1, null),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRepeatOption(
      {@required String title, @required RecurrenceRule targetRule}) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _task.rRule = targetRule;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w300,
            color: CustomTheme.textPrimary,
          ),
        ),
      ),
    );
  }

//=======================================================================================
//                                  Estimated Time
//=======================================================================================
  Widget _buildEstimatedTimeRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(CustomIcons.target),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  _task.durationString,
                  style: _buildTextStyle(context),
                ),
              ),
              onTap: () => _selectSimpleEstimatedTime(context),
            ),
          ),
        ],
      ),
    );
  }

  void _selectSimpleEstimatedTime(BuildContext context) async {
    if (_task.subtasks[0].name != '__simple__') {
      final snackBar = SnackBar(
        content:
            Text('You can\'t set the estimated time of a task while subtasks exist.'),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'DISMISS',
          onPressed: () {},
        ),
      );
      scaffold.currentState.showSnackBar(snackBar);
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => DialSelector(
            title: 'Estimated Time',
            initalDialValues: <int>[
              _task.duration.inMinutes ~/ 60,
              _task.duration.inMinutes % 60,
            ],
            onSelected: (List<int> dialValues) {
              setState(() {
                _task.subtasks[0].estimatedTime = Duration(
                  hours: dialValues[0],
                  minutes: dialValues[1],
                );
              });
            },
            dialTitles: <String>['Hours', 'Minutes'],
            dialMaxs: <int>[100, 60],
          ),
    );
  }
}
