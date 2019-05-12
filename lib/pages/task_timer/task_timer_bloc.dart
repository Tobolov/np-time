import 'package:rxdart/rxdart.dart';

import 'package:np_time/db/database.dart';
import 'package:np_time/models/task.dart';

class TaskTimerBloc {
  final _durationNewlyLogged = BehaviorSubject<int>();

  Observable<int> get durationNewlyLogged => _durationNewlyLogged.stream;

  TaskTimerBloc() {
    _durationNewlyLogged.sink.add(0);
  }

  void nextTimerTick(int duration) {
    _durationNewlyLogged.sink.add(duration);
  }

  int getTimerTick() {
    return _durationNewlyLogged.value;
  }

  dispose() {
    _durationNewlyLogged.close();
  }
}

TaskTimerBloc taskTimerBloc = TaskTimerBloc();