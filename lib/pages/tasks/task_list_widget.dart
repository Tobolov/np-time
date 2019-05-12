import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_time/db/database.dart';

import 'package:np_time/bloc/tasks_bloc.dart';
import './task_widget.dart';
import 'package:np_time/theme.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/logged_time.dart';

class TasksList extends StatefulWidget {
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
  State<StatefulWidget> createState() {
    return _TasksListState();
  }
}

class _TasksListState extends State<TasksList> {
  SortBy sortBy;
  SortOrder orderBy;
  StreamSubscription<SortBy> streamSubscriptionSortBy;
  StreamSubscription<SortOrder> streamSubscriptionOrderBy;

  @override
  void initState() {
    super.initState();
    sortBy = tasksBloc.lastSortBy;
    orderBy = tasksBloc.lastSortOrder;

    streamSubscriptionSortBy =
        tasksBloc.sortBy.listen((newSortBy) => setState(() => sortBy = newSortBy));
    streamSubscriptionOrderBy =
        tasksBloc.sortOrder.listen((newOrderBy) => setState(() => orderBy = newOrderBy));
  }

  @override
  void dispose() {
    streamSubscriptionSortBy.cancel();
    streamSubscriptionOrderBy.cancel();
    super.dispose();
  }

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
                  widget.noData,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              List<Task> tasks = snapshot.data;

              // remove deleted tasks
              tasks.removeWhere((task) => task.deleted);

              // filter tasks
              if (widget.searchFilter != null) {
                tasks = tasks
                    .where((task) => task.title
                        .toLowerCase()
                        .contains(widget.searchFilter.toLowerCase()))
                    .toList();
              }

              // sort tasks
              if (widget.sortingFunction != null) {
                tasks.sort(widget.sortingFunction);
              } else {
                tasks.sort(_sortMethodFromSortBy(sortBy));
              }

              // reverse tasks
              if (orderBy == SortOrder.Descending) {
                tasks = tasks.reversed.toList();
              }

              // limit displayed tasks
              if (widget.maxDisplayedTasks != null) {
                int maxTasks = widget.maxDisplayedTasks > tasks.length
                    ? tasks.length
                    : widget.maxDisplayedTasks;
                tasks = tasks.sublist(0, maxTasks);
              }

              if (widget.scrollable) {
                return Container(
                  margin: EdgeInsets.only(top: 6),
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 70),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      Task task = tasks[index];
                      return TaskWidget(task, widget.snuffAlerts);
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
                        widgets.add(TaskWidget(tasks[i], widget.snuffAlerts));

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

  Function(Task, Task) _sortMethodFromSortBy(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.Title:
        return (Task task1, Task task2) => task1.title.compareTo(task2.title);
      case SortBy.DueDate:
        return (Task task1, Task task2) => task1.dueDate.compareTo(task2.dueDate);
      case SortBy.PercentComplete:
        return (Task task1, Task task2) =>
            task1.percentComplete.compareTo(task2.percentComplete);
      case SortBy.EstimatedDuration:
        return (Task task1, Task task2) =>
            task1.estimatedDuration.compareTo(task2.estimatedDuration);
    }
    return null;
  }
}
