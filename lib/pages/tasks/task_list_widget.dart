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
  final Function(Task, Task) sortingFunction;
  final int maxDisplayedTasks;
  final bool snuffAlerts;
  final bool scrollable;

  TasksList(
      {@required this.noData,
      this.searchFilter,
      this.sortingFunction,
      this.maxDisplayedTasks,
      this.snuffAlerts = false,
      this.scrollable = true});

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

              //remove deleted tasks
              tasks.removeWhere((task) => task.deleted);

              //filter tasks
              if (searchFilter != null) {
                tasks = tasks
                    .where((task) =>
                        task.title.toLowerCase().contains(searchFilter.toLowerCase()))
                    .toList();
              }

              //sort tasks
              if (sortingFunction != null) {
                tasks.sort(sortingFunction);
              } else {
                tasks.sort(sortMethodFromSortBy(tasksBloc.sortBy));
              }

              //limit displayed tasks
              if (maxDisplayedTasks != null) {
                int maxTasks =
                    maxDisplayedTasks > tasks.length ? tasks.length : maxDisplayedTasks;
                tasks = tasks.sublist(0, maxTasks);
              }

              if (scrollable) {
                return Container(
                  margin: EdgeInsets.only(top: 6),
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 70),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      Task task = tasks[index];
                      return TaskWidget(task, snuffAlerts);
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(color: CustomTheme.textDisabled),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(top: 6),
                  child: Column(
                    children: () {
                      List<Widget> widgets = [];

                      for (int i = 0; i < tasks.length; i++) {
                        widgets.add(TaskWidget(tasks[i], snuffAlerts));
                        
                        // add divider if not last element
                        if (i != tasks.length - 1) {
                          widgets.add(Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(color: CustomTheme.textDisabled),
                          ));
                        }
                      }
                      return widgets;
                    }(),
                  ),
                );
              }
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
