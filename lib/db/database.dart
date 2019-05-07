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
  final String taskRepeatStartDate = 'repeatStartDate';
  final String taskRepeatCycle = 'repeatCycle';
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

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'NpTime.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tableTask (
            $taskId INTEGER PRIMARY KEY AUTOINCREMENT,
            $taskTitle TEXT,
            $taskDeleted BIT,
            $taskDescription TEXT,
            $taskDueDate TEXT,
            $taskRepeatStartDate TEXT,
            $taskRepeatCycle TEXT,
            $taskNotification TEXT' //list of string delemited by 
          );
          CREATE TABLE $tableSubtask (
            $subtaskId INTEGER AUTOINCREMENT,
            $subtaskTaskId INTEGER
            $subtaskName TEXT,
            $subtaskEstimatedTime INTEGER,
            PRIMARY KEY ($subtaskId, $subtaskTaskId),
            FOREIGN KEY ($subtaskTaskId) REFERENCES $tableTask($taskId) ON UPDATE CASCADE ON DELETE CASCADE
          );
          CREATE TABLE $tableLoggedtime (
            $loggedtimeId INTEGER AUTOINCREMENT,
            $loggedtimeSubtaskId INTEGER
            $loggedtimeTaskId INTEGER
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
    List<Subtask> subtasks = newTask.remove('subtasks');
    int res = await db.insert('$tableTask', newTask);

    for (Subtask subtask in subtasks) {
      Map<String, dynamic> subtaskMap = subtask.toMap();
      List<LoggedTime> loggedTimes = subtaskMap.remove('loggedTimes');
      res += await db.insert('$tableSubtask', subtaskMap);

      for (LoggedTime loggedTime in loggedTimes) {
        Map<String, dynamic> loggedTimeMap = loggedTime.toMap();
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
    return List<Map<String, dynamic>>.from(resSubtasks.map((subtask) async {
      var resLoggedTime = await db.query(
        '$tableLoggedtime',
        where: '$loggedtimeTaskId = ? AND $loggedtimeSubtaskId = ?',
        whereArgs: [id, subtask['id']],
      );
      subtask['loggedTimes'] =
          List<Map<String, dynamic>>.from(resLoggedTime.map((loggedTime) => loggedTime));
      return subtask;
    }));
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
      taskMap['subtasks'] = _fetchTaskComponenets(id);
      return Task.fromMap(taskMap);
    }
    return null;
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    var res = await db.query('$tableTask');
    List<Task> list = res.isNotEmpty
        ? res.map((task) {
            task['subtasks'] = _fetchTaskComponenets(task['id']);
            Task.fromMap(task);
          }).toList()
        : [];
    return list;
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
