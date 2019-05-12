import 'package:flutter/material.dart';
import 'package:np_time/pages/tasks/task_list_widget.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TasksList(
      noData: 'No archived tasks!',
      showDeleted: true,
      snuffAlerts: true,
    );
  }
}
