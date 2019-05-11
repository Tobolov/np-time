import 'package:flutter/material.dart';
import 'package:np_time/db/database.dart';

import 'package:np_time/bloc/tasks_bloc.dart';
import './task_widget.dart';
import 'package:np_time/theme.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/logged_time.dart';

class TasksList extends StatelessWidget {
  final String noData;
  final String searchFilter;

  TasksList({@required this.noData, this.searchFilter});

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
                  noData,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              List<Task> tasks = snapshot.data;
              tasks.removeWhere((task) => task.deleted);
              if (searchFilter != null) {
                tasks = tasks.where((task) => task.title.toLowerCase().contains(searchFilter.toLowerCase())).toList();
              }
              return Container(
                margin: EdgeInsets.only(top: 6),
                child: ListView.separated(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    Task task = tasks[index];
                    return TaskWidget(task);
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(color: CustomTheme.textDisabled),
                    );
                  },
                ),
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
