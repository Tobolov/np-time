import 'package:flutter/material.dart';
import 'package:np_time/models/task.dart';
import '../../theme.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  TaskWidget(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          _buildPercentDisplay(context),
          _buildInformativeInformation(context),
          _buildAlertSector(context),
        ],
      ),
    );
  }

  Widget _buildPercentDisplay(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(16),
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
          Text(
            '%',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'TitilliumWeb',
              fontWeight: FontWeight.w200,
              color: CustomTheme.textDisabled,
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
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              task.title,
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w400,
                color: CustomTheme.textPrimary,
              ),
            ),
            Text(
              '2 days remaining',
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
      margin: EdgeInsets.all(16),
      child: Icon(
        Icons.warning,
        color: CustomTheme.accent,
      ),
    );
  }
}
