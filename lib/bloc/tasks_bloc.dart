import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import 'package:np_time/db/database.dart';
import 'package:np_time/models/task.dart';

class TasksBloc {
  final _tasks = BehaviorSubject<List<Task>>();
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
    edit(task);
  }

  dispose() {
    _tasks.close();
  }
}

final tasksBloc = TasksBloc();
