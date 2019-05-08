import 'package:flutter/material.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/theme.dart';
import 'package:intl/intl.dart';

class TaskMutation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskMutationState();
  }
}

class _TaskMutationState extends State<TaskMutation> {
  final Task _task = Task.template;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: _buildTitleField(context),
        actions: _buildAppBarActions(context),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          margin: EdgeInsets.only(
            left: 52,
            bottom: 10,
          ),
          child: TextFormField(
            initialValue: _task.title ?? 'Enter Title',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w300,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ));
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return <Widget>[
      Container(
        width: 65,
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 16, top: 11),
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
            //todo
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
      ],
    );
  }

  Widget _buildDescriptionRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(Icons.details),
          ),
          Expanded(
            child: TextFormField(
              initialValue: _task.description ?? 'Add Description',
              style: _buildTextStyle(context),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(Icons.calendar_view_day),
          ),
          Expanded(
            child: GestureDetector(
              child: Text(
                _task.dueDate != null
                    ? DateFormat('EEE, d MMM yyyy').format(_task.dueDate.toLocal())
                    : 'Set due date',
                style: _buildTextStyle(context),
              ),
              onTap: () => _selectDate(context),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _buildTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 19,
      fontFamily: 'RobotoCondensed',
      fontWeight: FontWeight.w300,
      color: CustomTheme.textPrimary,
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
}
