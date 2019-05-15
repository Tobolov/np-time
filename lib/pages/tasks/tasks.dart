import 'package:flutter/material.dart';

import 'package:np_time/pages/tasks/task_list_widget.dart';
import 'package:np_time/pages/tasks/task_widget.dart';


class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TasksList(
      noData: 'It\'s lonely here. \nHow about creating a new task!',
      swipeBehaviour: TaskWidgetSwipeBehaviour.ArchiveLog,
    );
  }
}
