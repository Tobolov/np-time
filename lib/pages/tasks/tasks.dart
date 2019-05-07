import 'package:flutter/material.dart';
import 'package:np_time/db/database.dart';

import './tasks_bloc.dart';
import './task_widget.dart';
import '../../theme.dart';
import '../../models/task.dart';
import '../../models/subtask.dart';
import '../../models/logged_time.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<Task>>(
        stream: tasksBloc.tasks,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'It\'s lonely here. \nHow about creating a new task!',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Task task = snapshot.data[index];
                  return TaskWidget(task);
                },
                separatorBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: CustomTheme.textDisabled),
                    );
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
