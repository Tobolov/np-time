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
    _tasks.sink.add(await DBProvider.db.getAllTasks());
  }

  add(Task task) async {
    await DBProvider.db.insertTask(task);
    await getTasks();
  }

  dispose() {
    _tasks.close();
  }
}

final tasksBloc = TasksBloc();