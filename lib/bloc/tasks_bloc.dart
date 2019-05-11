import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import 'package:np_time/db/database.dart';
import 'package:np_time/models/task.dart';

class TasksBloc {
  final _tasks = BehaviorSubject<List<Task>>();
  final _sortBy = BehaviorSubject<SortBy>();
  final _sortOrder = BehaviorSubject<SortOrder>();

  Observable<List<Task>> get tasks => _tasks.stream;
  Observable<SortBy> get sortBy => _sortBy.stream;
  Observable<SortOrder> get sortOrder => _sortOrder.stream;

  SortBy get lastSortBy => _sortBy.value;
  SortOrder get lastSortOrder => _sortOrder.value;

  TasksBloc() {
    getTasks();
    _sortBy.sink.add(SortBy.DueDate);
    _sortOrder.sink.add(SortOrder.Ascending);
  }

  getTasks() async {
    var tasks = await DBProvider.db.getAllTasks();
    _tasks.sink.add(tasks);
  }

  add(Task task) async {
    await DBProvider.db.insertTask(task);
    await getTasks();
  }

  addBatch(List<Task> tasks) async {
    for (Task task in tasks) {
      await DBProvider.db.insertTask(task);
    }
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

  setSortBy(SortBy sortBy) {
    _sortBy.sink.add(sortBy);
  }

  setSortOrder(SortOrder sortOrder) {
    _sortOrder.sink.add(sortOrder);
  }

  dispose() {
    _tasks.close();
    _sortBy.close();
    _sortOrder.close();
  }
}

enum SortBy {
  Title,
  DueDate,
  PercentComplete,
  EstimatedDuration,
}

enum SortOrder {
  Ascending,
  Descending,
}

final tasksBloc = TasksBloc();
