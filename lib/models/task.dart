// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grec_minimal/grec_minimal.dart';

import './subtask.dart';

Task taskFromJson(String str) => Task.fromMap(json.decode(str));

String taskToJson(Task data) => json.encode(data.toMap());

class Task {
  int id;
  String title;
  bool deleted;
  String description;
  DateTime dueDate;
  RecurrenceRule rRule;
  List<Duration> notification;
  List<Subtask> subtasks;

  Duration get estimatedDuration => _calculateEstimatedDuration();
  String get dueDateString => _dueDateString();
  Duration get totalLoggedTime => _calculateTotalLoggedTime();
  double get percentComplete => _calculatePercentComplete();
  bool get isSimple => subtasks[0].name == '__simple__';

  Task({
    this.id,
    @required this.title,
    this.deleted = false,
    @required this.description,
    @required this.dueDate,
    @required this.rRule,
    @required this.notification,
    this.subtasks = const <Subtask>[],
  });

  static Task get simple => Task(
        description: null,
        dueDate: null,
        notification: <Duration>[],
        rRule: null,
        title: null,
        deleted: false,
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(seconds: 0),
          )
        ],
      );

  factory Task.fromMap(Map<String, dynamic> json) => new Task(
        id: json['id'],
        title: json['title'],
        deleted: json['deleted'] != 0,
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        rRule: json['rRule'].toString().length == 0
            ? null
            : GrecMinimal.fromTexts((<String>[json['rRule']]))[0],
        notification: List<Duration>.from(
          json['notification']
              .toString()
              .split(',')
              .where((notification) => notification.isNotEmpty)
              .map((notification) => Duration(days: int.parse(notification))),
        ),
        subtasks: new List<Subtask>.from(
          (json['subtasks'] ?? <Subtask>[]).map((subtask) => Subtask.fromMap(subtask)),
        ),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'deleted': deleted,
        'description': description ?? '',
        'dueDate': dueDate.toIso8601String(),
        'rRule': rRule?.asRuleText() ?? '',
        'notification': List<String>.from(
          notification.map((duration) => duration.inDays.toString()),
        ).join(','),
        'subtasks': new List<Map<String, dynamic>>.from(
            subtasks.map((subtask) => subtask.toMap())),
      };

  Duration _calculateEstimatedDuration() {
    Duration totalDuration = Duration(seconds: 0);
    for (Subtask subtask in subtasks) {
      totalDuration += subtask.estimatedDuration;
    }
    return totalDuration;
  }

  Duration _calculateTotalLoggedTime() {
    Duration totalDuration = Duration(seconds: 0);
    for (Subtask subtask in subtasks) {
      totalDuration += subtask.totalLoggedTime;
    }
    return totalDuration;
  }

  String estimatedDurationString({int subtaskIndex}) {
    Duration totalEstimatedDuration;

    if (subtaskIndex == null) {
      totalEstimatedDuration = _calculateEstimatedDuration();
    } else {
      totalEstimatedDuration = subtasks[subtaskIndex].estimatedDuration;
    }
    return _generateEstimatedDurationString(totalEstimatedDuration);
  }

  String _dueDateString() {
    //todo make this a bit better
    int daysRemaining = dueDate.difference(DateTime.now()).inDays;
    if (daysRemaining == 0) {
      return 'Due today';
    } else if (daysRemaining == 1) {
      return 'Due tommorow';
    } else {
      return 'Due in $daysRemaining days';
    }
  }

  double _calculatePercentComplete() {
    Duration totalEstimatedDuration = _calculateEstimatedDuration();
    Duration totalLoggedTime = _calculateTotalLoggedTime();

    double ratio = totalLoggedTime.inSeconds / totalEstimatedDuration.inSeconds;
    double percent = (ratio.isFinite ? ratio : 0) * 100.0;
    double cappedPercent = percent > 100 ? 100 : percent;
    return cappedPercent;
  }

  String _generateEstimatedDurationString(Duration duration) {
    if (duration < Duration(hours: 1)) {
      return '${duration.inMinutes} minutes';
    }

    int totalMinutes = duration.inMinutes;
    int displayMinutes = totalMinutes % 60;
    int displayHours = totalMinutes ~/ 60;
    return '$displayHours hours and $displayMinutes minutes';
  }

  void addEmptySubtask() {
    if (this.isSimple) {
      // if simple task, convert to complex
      Duration duration = subtasks[0].estimatedDuration;
      subtasks.removeAt(0);
      subtasks.add(Subtask.empty);

      //retain previous estimated time
      subtasks[0].estimatedDuration = duration;
    } else {
      subtasks.add(Subtask.empty);
    }
  }

  void removeSubtaskAt(int index) {
    subtasks.removeAt(index);
    if (subtasks.length == 0) {
      subtasks.add(Subtask.empty);
      subtasks[0].name = '__simple__';
    }
  }
}
