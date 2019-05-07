import 'package:flutter/material.dart';
import 'package:np_time/theme.dart';

class TaskMutation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: _buildTitleField(context),
          actions: _buildAppBarActions(context),
        ),
        body: _buildBody(context),
      ),
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
            autofocus: true,
            initialValue: 'Enter Title',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w300,
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
    return Container();
  }
}
