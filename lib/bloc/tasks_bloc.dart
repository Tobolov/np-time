import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import 'package:np_time/db/database.dart';
import 'package:np_time/models/task.dart';

class TasksBloc {
  final _tasks = BehaviorSubject<List<Task>>();
  SortBy sortBy = SortBy.Title;
  SortOrder sortOrder = SortOrder.Ascending;

  Observable<List<Task>> get tasks => _tasks.stream;

  TasksBloc() {
    getTasks();
  }

  getTasks() async {
    var tasks = await DBProvider.db.getAllTasks();
    _tasks.sink.add(tasks);
  }

  add(Task task) async {
    await DBProvider.db.insertTask(task);
    await getTasks();
  }

  edit(Task task) async {
    await DBProvider.db.updateTask(task);
    await getTasks();
  }

  delete(Task task) async {
    task.deleted = true;
    await edit(task);
  }

  deleteDatabase() async {
    await DBProvider.db.deleteDB();
    await getTasks();
  }

  dispose() {
    _tasks.close();
  }
}

enum SortBy {
  Title,
  DueDate,
  PercentComplete,
  EstimatedDuration,
}

Function(Task, Task) sortMethodFromSortBy(SortBy sortBy) {
  switch (sortBy) {
    case SortBy.Title:
      return (Task task1, Task task2) => task1.title.compareTo(task2.title);
    case SortBy.DueDate:
      return (Task task1, Task task2) => task1.dueDate.compareTo(task2.dueDate);
    case SortBy.PercentComplete:
      return (Task task1, Task task2) => task1.percentComplete.compareTo(task2.percentComplete);
    case SortBy.EstimatedDuration:
      return (Task task1, Task task2) => task1.estimatedDuration.compareTo(task2.estimatedDuration);
  }
  return null;
}

enum SortOrder {
  Ascending,
  Descending,
}

final tasksBloc = TasksBloc();
