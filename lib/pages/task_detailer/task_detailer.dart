import 'package:flutter/material.dart';
import 'package:grec_minimal/grec_minimal.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/presentation/custom_icons_icons.dart';
import 'package:np_time/theme.dart';
import 'package:intl/intl.dart';
import 'package:np_time/widgets/dial_selector.dart';

class TaskDetailer extends StatelessWidget {
  final Task _task;

  TaskDetailer(this._task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _buildAppBarActions(context),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.timer),
        onPressed: () {
          //todo timer
        },
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.pushNamed(context, '/task/create', arguments: _task);
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          tasksBloc.delete(_task);
          Navigator.pop(context);
        },
      ),
    ];
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildTaskHeader(),
        _buildDivider(context),
        ...() {
          // add description field if not null
          if (_task.description.isEmpty) {
            return <Widget>[];
          }
          return <Widget>[
            _buildDescriptionRow(context),
            _buildDivider(context),
            _buildEstimatedTimeRow(context),
            _buildDivider(context),
          ];
        }(),
        ...() {
          // show subtask list if not simple
          if (_task.isSimple) {
            return <Widget>[];
          }
          return <Widget>[
            _buildSubtasksRow(context),
            //_buildDivider(context),
          ];
        }(),
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

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: CustomTheme.textDisabled,
      ),
    );
  }

  Widget _buildVerticalPercentBar(double percentComplete) {
    int percent = percentComplete.toInt();
    percent = percent < 5 ? 5 : percent; // always show some of inner bar
    int emptyFlex = 100 - percent;
    int filledFlex = percent;

    double outerWidth = 4;
    double innerWidth = 2.5;
    double edgeDiff = (outerWidth - innerWidth) / 2;
    return Container(
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
            flex: filledFlex,
            child: Container(
              width: innerWidth,
              color: CustomTheme.backgroundColor,
            ),
          )
        ],
      ),
    );
  }

//=======================================================================================
//                                    Task Header
//=======================================================================================

  Widget _buildTaskHeader() {
    double percentComplete = _task.percentComplete;
    String percentCompelteLabel = percentComplete.toInt().toString();
    String dateDueLabel = DateFormat('d MMM yyyy').format(_task.dueDate.toLocal());
    String timeRemainingLabel = '${_task.dueDateString} ($dateDueLabel)';

    return Container(
      margin: EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ...() {
              if (_task.isSimple) {
                return <Widget>[
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
                    child: _buildVerticalPercentBar(percentComplete),
                  )
                ];
              }
              return <Widget>[];
            }(),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _task.title,
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
      ),
    );
  }

//=======================================================================================
//                                    Task Description
//=======================================================================================

  Widget _buildDescriptionRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(Icons.subject),
          ),
          Expanded(
            child: Text(
              _task.description,
              style: _buildTextStyle(context),
              maxLines: 6,
            ),
          ),
        ],
      ),
    );
  }

  //=======================================================================================
//                                  Estimated Time
//=======================================================================================
  Widget _buildEstimatedTimeRow(BuildContext context) {
    String estimatedDurationLabel = _task.estimatedDurationString();
    Color estimatedDurationLabelColor = CustomTheme.textPrimary;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
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
                style: _buildTextStyle(context, color: estimatedDurationLabelColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

//=======================================================================================
//                                    Subtasks
//=======================================================================================

  Widget _buildSubtasksRow(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: () {
          List<Widget> subtaskWidgets = [
            Container(
              margin: EdgeInsets.only(top: 16, left: 16),
              child: Text(
                'Subtasks',
                style: _buildTextStyle(context, color: CustomTheme.textSecondary),
              ),
            )
          ];
          int i = 0;
          for (Subtask subtask in _task.subtasks) {
            subtaskWidgets.add(_buildSubtaskWidget(context, subtask, i));
            i++;
          }
          return subtaskWidgets;
        }(),
      ),
    );
  }

  Widget _buildSubtaskWidget(BuildContext context, Subtask subtask, int index) {
    double percentComplete = subtask.percentComplete;
    String percentCompeleteLabel = percentComplete.toInt().toString();

    return Container(
      margin: EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 16),
              child: Text(
                percentCompeleteLabel,
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                  color: CustomTheme.textPrimary,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                child: _buildVerticalPercentBar(percentComplete)),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subtask.name,
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w300,
                        fontSize: 19,
                        color: CustomTheme.textPrimary,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 16),
                          child:
                              Icon(CustomIcons.target, color: CustomTheme.textSecondary),
                        ),
                        Expanded(
                          child: Text(
                            _task.estimatedDurationString(subtaskIndex: index),
                            style: _buildTextStyle(context,
                                color: CustomTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
