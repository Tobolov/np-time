import 'package:flutter/material.dart';
import 'package:np_time/models/task.dart';
import '../../theme.dart';

class TaskWidget extends StatelessWidget {
  final Task _task;

  TaskWidget(this._task);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Row(
          children: <Widget>[
            _buildPercentDisplay(context),
            _buildInformativeInformation(context),
            _buildAlertSector(context),
          ],
        ),
      ),
      onTap: () {
        final snackBar = SnackBar(
          content: Text('Not yet implemented.'),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: 'DISMISS',
            onPressed: () {},
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
  }

  Widget _buildPercentDisplay(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Text(
            '35',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w300,
              color: CustomTheme.textPrimary,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              '%',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'TitilliumWeb',
                fontWeight: FontWeight.w200,
                color: CustomTheme.textDisabled,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInformativeInformation(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _task.title,
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w400,
                color: CustomTheme.textPrimary,
              ),
            ),
            Text(
              _task.dueDateString,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w300,
                color: CustomTheme.textSecondary,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAlertSector(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Icon(
        Icons.warning,
        color: CustomTheme.accent,
      ),
    );
  }
}
