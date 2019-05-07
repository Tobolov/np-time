import 'package:rxdart/rxdart.dart';

import '../../db/database.dart';
import '../../models/task.dart';

class TasksBloc {
  final _tasks = BehaviorSubject<List<Task>>();
  Observable<List<Task>> get tasks => _tasks.stream;

  TasksBloc() {
    getTasks();
  }

  getTasks() async {
    _tasks.sink.add(await DBProvider.db.getAllTasks());
  }

  add(Task task) {
    DBProvider.db.insertTask(task);
    getTasks();
  }

  dispose() {
    _tasks.close();
  }
}

final tasksBloc = TasksBloc();