import 'dart:async';
import 'dart:io';

import 'package:np_time/models/logged_time.dart';
import 'package:np_time/models/subtask.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  final String tableTask = 'Task';
  final String taskId = 'id';
  final String taskTitle = 'title';
  final String taskDeleted = 'deleted';
  final String taskDescription = 'description';
  final String taskDueDate = 'dueDate';
  final String taskRRule = 'rRule';
  final String taskNotification = 'notification';

  final String tableSubtask = 'Subtask';
  final String subtaskId = 'id';
  final String subtaskTaskId = 'taskId';
  final String subtaskName = 'name';
  final String subtaskEstimatedTime = 'estimatedTime';
  final String subtaskLoggedTimes = 'loggedTimes';

  final String tableLoggedtime = 'Loggedtime';
  final String loggedtimeId = 'id';
  final String loggedtimeTaskId = 'taskId';
  final String loggedtimeSubtaskId = 'subtaskId';
  final String loggedtimeDate = 'date';
  final String loggedtimeTimeSpan = 'timespan';

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  deleteDB() async {
    if (_database != null) {
      _database.close();
    }
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'NpTime.db');
    await deleteDatabase(path);
    _database = null;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'NpTime.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tableTask (
            $taskId INTEGER PRIMARY KEY,
            $taskTitle TEXT,
            $taskDeleted BIT,
            $taskDescription TEXT,
            $taskDueDate TEXT,
            $taskRRule TEXT,
            $taskNotification TEXT
          );
          ''');
      await db.execute('''
          CREATE TABLE $tableSubtask (
            $subtaskId INTEGER,
            $subtaskTaskId INTEGER,
            $subtaskName TEXT,
            $subtaskEstimatedTime INTEGER,
            PRIMARY KEY ($subtaskId, $subtaskTaskId),
            FOREIGN KEY ($subtaskTaskId) REFERENCES $tableTask($taskId) ON UPDATE CASCADE ON DELETE CASCADE
          );
          ''');
      await db.execute('''
          CREATE TABLE $tableLoggedtime (
            $loggedtimeId INTEGER,
            $loggedtimeSubtaskId INTEGER,
            $loggedtimeTaskId INTEGER,
            $loggedtimeDate TEXT,
            $loggedtimeTimeSpan INTEGER,
            PRIMARY KEY ($loggedtimeId, $loggedtimeSubtaskId, $loggedtimeTaskId),
            FOREIGN KEY ($loggedtimeTaskId, $loggedtimeSubtaskId) REFERENCES $tableSubtask($subtaskTaskId, $subtaskId) ON UPDATE CASCADE ON DELETE CASCADE
          );
          ''');
    });
  }

//=======================================================================================
//                                       Tasks
//=======================================================================================

  Future<int> insertTask(Task insertTask) async {
    final db = await database;
    Map<String, dynamic> newTask = insertTask.toMap();
    newTask.remove('subtasks');
    List<Subtask> subtasks = insertTask.subtasks;
    var newTaskId = await db.rawQuery("SELECT MAX($taskId)+1 as $taskId FROM $tableTask");
    int id = newTaskId.first["id"];
    newTask['id'] = id;
    int res = await db.insert('$tableTask', newTask);

    int i = 0;
    for (Subtask subtask in subtasks) {
      Map<String, dynamic> subtaskMap = subtask.toMap();
      subtaskMap['id'] = i++;
      subtaskMap['taskId'] = id;
      subtaskMap.remove('loggedTimes');
      List<LoggedTime> loggedTimes = subtask.loggedTimes;
      res += await db.insert('$tableSubtask', subtaskMap);

      int j = 0;
      for (LoggedTime loggedTime in loggedTimes) {
        Map<String, dynamic> loggedTimeMap = loggedTime.toMap();
        loggedTimeMap['id'] = j++;
        loggedTimeMap['subtaskId'] = i;
        loggedTimeMap['taskId'] = id;
        res += await db.insert('$tableLoggedtime', loggedTimeMap);
      }
    }

    return res;
  }

  Future<List<Map<String, dynamic>>> _fetchTaskComponenets(int id) async {
    final db = await database;
    var resSubtasks = await db.query(
      '$tableSubtask',
      where: '$subtaskTaskId = ?',
      whereArgs: [id],
    );
    List<Map<String, dynamic>> subtasks = <Map<String, dynamic>>[];
    for (Map<String, dynamic> lockedSubtask in resSubtasks) {
      Map<String, dynamic> subtask = Map<String, dynamic>.from(lockedSubtask);
      var resLoggedTime = await db.query(
        '$tableLoggedtime',
        where: '$loggedtimeTaskId = ? AND $loggedtimeSubtaskId = ?',
        whereArgs: [id, subtask['id']],
      );
      subtask['loggedTimes'] =
          List<Map<String, dynamic>>.from(resLoggedTime.map((loggedTime) => loggedTime));
      subtasks.add(subtask);
    }
    return subtasks;
  }

  Future<Task> getTask(int id) async {
    final db = await database;
    var res = await db.query(
      '$tableTask',
      where: '$taskId = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      Map<String, dynamic> taskMap = res.first;
      taskMap['subtasks'] = await _fetchTaskComponenets(id);
      return Task.fromMap(taskMap);
    }
    return null;
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    var res = await db.query('$tableTask');

    if (res.isNotEmpty) {
      List<Task> list = [];
      for (Map<String, dynamic> task in res) {
        var taskTemp = Map<String, dynamic>.from(task);
        taskTemp['subtasks'] = await _fetchTaskComponenets(task['id']);
        list.add(Task.fromMap(taskTemp));
      }
      return list;
    } else {
      return <Task>[];
    }
  }

  //todo. how to chain differences? e.g subtask deleted? subtask added?
  /*
  Future<int> updateTask(Task updatedTask) async {
    final db = await database;
    Map<String, dynamic> updatedTaskMap = updatedTask.toMap();
    List<Subtask> updatedOrNewSubtasks = updatedTaskMap.remove('subtasks');

    var res = await db.update(
      '$tableTask',
      updatedTaskMap,
      where: '$taskId = ?',
      whereArgs: [updatedTask.id],
    );
    return res;
  }
  */

  Future close() async => db.close();
}
