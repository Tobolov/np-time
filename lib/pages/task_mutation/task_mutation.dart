import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grec_minimal/grec_minimal.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/presentation/custom_icons_icons.dart';
import 'package:np_time/theme.dart';
import 'package:intl/intl.dart';
import 'package:np_time/widgets/dial_selector.dart';

class TaskMutation extends StatefulWidget {
  final Task taskToEdit;

  TaskMutation({this.taskToEdit});

  @override
  State<StatefulWidget> createState() {
    return _TaskMutationState();
  }
}

class _TaskMutationState extends State<TaskMutation> {
  Task _task;
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
  void initState() {
    super.initState();
    _task = widget.taskToEdit ?? Task.simple;
  }

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
          onPressed: () => _onSave(),
        ),
      )
    ];
  }

  void _onSave() {
// validate all TextFormFields (subtask names)
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _titleKey.currentState.save();

    if (_task.title.isEmpty) {
      _displaySnackbar(label: 'Please set a title.');
      return;
    }

    if (_task.dueDate == null) {
      _displaySnackbar(label: 'Please set a due date.');
      return;
    }

    if (_task.estimatedDuration == null) {
      _displaySnackbar(label: 'Please set an estimated duration.');
      return;
    }

    if (_task.estimatedDuration == Duration.zero) {
      _displaySnackbar(label: 'Estimated duration can\'t be zero.');
      return;
    }

    if (widget.taskToEdit == null) {
      tasksBloc.add(_task);
    } else {
      tasksBloc.edit(_task);
    }
    Navigator.pop(context);
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
        _buildSubtasksRow(context),
      ],
    );
  }

//=======================================================================================
//                                    Shared
//=======================================================================================

  TextStyle _buildTextStyle(BuildContext context, {Color color}) {
    return TextStyle(
      fontSize: 19,
      fontFamily: 'RobotoCondensed',
      fontWeight: FontWeight.w300,
      color: color ?? CustomTheme.textPrimary,
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

  void _displaySnackbar(
      {@required String label,
      String actionButtonLabel = 'DISMISS',
      Function onPressed}) {
    final snackBar = SnackBar(
      content: Text(label),
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: actionButtonLabel,
        onPressed: onPressed ?? () {},
      ),
    );
    scaffold.currentState.showSnackBar(snackBar);
  }

  void _displayEstimatedTimeDialog(BuildContext context,
      {@required Function(Duration) onSelected,
      Duration initalDuration = Duration.zero}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => DialSelector(
            title: 'Estimated Time',
            initalDialValues: <int>[
              initalDuration.inMinutes ~/ 60,
              initalDuration.inMinutes % 60,
            ],
            onSelected: (List<int> dialValues) => onSelected(
                  Duration(
                    hours: dialValues[0],
                    minutes: dialValues[1],
                  ),
                ),
            dialTitles: <String>['Hours', 'Minutes'],
            dialMaxs: <int>[100, 60],
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
      String notificaitonLabel;
      if (notification.inDays == 0) {
        notificaitonLabel = 'On due date';
      } else if (notification.inDays == 1) {
        notificaitonLabel = '1 day before due date';
      } else {
        notificaitonLabel = '${notification.inDays} days before due date';
      }

      widgets.add(
        Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  notificaitonLabel,
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
      builder: (BuildContext context1) {
        return SimpleDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          children: <Widget>[
            _buildNotificationOption(
              title: 'On date due',
              onPressed: () {
                setState(() {
                  _taskAddNotification(Duration(days: 0));
                });
              },
            ),
            _buildNotificationOption(
              title: '1 day before',
              onPressed: () {
                setState(() {
                  _taskAddNotification(Duration(days: 1));
                });
              },
            ),
            _buildNotificationOption(
              title: '3 days before',
              onPressed: () {
                setState(() {
                  _taskAddNotification(Duration(days: 3));
                });
              },
            ),
            _buildNotificationOption(
              title: '1 week before',
              onPressed: () {
                setState(() {
                  _taskAddNotification(Duration(days: 7));
                });
              },
            ),
            _buildNotificationOption(
              title: 'Custom',
              onPressed: () async {
                //Navigator.pop(context);
                Future(
                  () => showDialog<void>(
                        context: context1,
                        builder: (BuildContext context2) => DialSelector(
                              title: 'Notifications for due date',
                              initalDialValues: <int>[0, 0],
                              onSelected: (List<int> dialValues) {
                                setState(() {
                                  _taskAddNotification(
                                    Duration(days: dialValues[0] * 7 + dialValues[1]),
                                  );
                                });
                              },
                              dialMaxs: <int>[10, 7],
                              dialTitles: <String>['Weeks', 'Days'],
                            ),
                      ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _taskAddNotification(Duration notificiation) {
    for (Duration duration in _task.notification) {
      if (notificiation.compareTo(duration) == 0) {
        _displaySnackbar(label: 'This notification already exists.');
        return;
      }
    }
    _task.notification.add(notificiation);
    _task.notification.sort();
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
      _displaySnackbar(
        label: 'Due date must be set before assigning repeat schedule.',
        actionButtonLabel: 'SET DUE DATE',
        onPressed: () => _selectDate(context),
      );
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
    String estimatedDurationLabel;
    Color estimatedDurationLabelColor = CustomTheme.textPrimary;

    // display estimated duration directly if not simple task
    if (!_task.isSimple) {
      estimatedDurationLabel = _task.estimatedDurationString();
      estimatedDurationLabelColor = CustomTheme.textDisabled;
    } else {
      // if task estimated duration not set
      if (_task.estimatedDuration == Duration.zero) {
        estimatedDurationLabel = 'Set estimated time';
      } else {
        estimatedDurationLabel = _task.estimatedDurationString();
      }
    }

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
                  estimatedDurationLabel,
                  style: _buildTextStyle(context, color: estimatedDurationLabelColor),
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
    if (!_task.isSimple) {
      _displaySnackbar(
        label: 'You can\'t set the estimated time of a task while subtasks exist.',
      );
      return;
    }
    _displayEstimatedTimeDialog(context, onSelected: (Duration duration) {
      setState(() => _task.subtasks[0].estimatedDuration = duration);
    }, initalDuration: _task.estimatedDuration);
  }

//=======================================================================================
//                                    Subtasks
//=======================================================================================

  Widget _buildSubtasksRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(CustomIcons.subdirectory_arrow_right),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildSubtasksList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubtasksList() {
    List<Widget> widgets = [];

    if (!_task.isSimple) {
      // add the subtasks
      for (int index = 0; index < _task.subtasks.length; index++) {
        widgets.add(
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    width: 1.5,
                    color: CustomTheme.textDisabled,
                  ),
                  Expanded(child: _buildSubtaskCenterContent(index)),
                  GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.close),
                      ),
                      onTap: () => setState(() => _task.removeSubtaskAt(index)))
                ],
              ),
            ),
          ),
        );
      }
    }

    // add the 'Add subtask' button
    widgets.add(
      GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Text(
            _task.isSimple ? 'Add a subtask' : 'Add another subtask',
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w300,
              color:
                  _task.isSimple ? CustomTheme.textPrimary : CustomTheme.textSecondary,
            ),
          ),
        ),
        onTap: () => setState(() => _task.addEmptySubtask()),
      ),
    );

    return widgets;
  }

  Widget _buildSubtaskCenterContent(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 6),
          child: TextFormField(
            initialValue: _task.subtasks[index].name ?? '',
            style: _buildTextStyle(context),
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Subtitle name',
              border: InputBorder.none,
              helperStyle: _buildErrorTextStyle(),
              errorStyle: _buildErrorTextStyle(),
              contentPadding: EdgeInsets.only(top: 6),
            ),
            onSaved: (value) {
              setState(() {
                _task.subtasks[index].name = value ?? '';
              });
            },
            validator: (value) => value.isEmpty ? 'Subtask name can\'t be empty' : null,
          ),
        ),
        _buildSubtaskEstimatedTime(context, index),
      ],
    );
  }

  Widget _buildSubtaskEstimatedTime(BuildContext context, int index) {
    String estimatedDurationLabel;

    if (_task.subtasks[index].estimatedDuration == Duration.zero) {
      estimatedDurationLabel = 'Set estimated time';
    } else {
      estimatedDurationLabel = _task.estimatedDurationString(subtaskIndex: index);
    }

    return GestureDetector(
      onTap: () {
        _displayEstimatedTimeDialog(context, onSelected: (Duration duration) {
          setState(() => _task.subtasks[index].estimatedDuration = duration);
        });
      },
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(CustomIcons.target),
          ),
          Expanded(
            child: Text(
              estimatedDurationLabel,
              style: _buildTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}
