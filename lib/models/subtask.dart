// To parse this JSON data, do
//
//     final subtask = subtaskFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import './logged_time.dart';

Subtask subtaskFromJson(String str) => Subtask.fromMap(json.decode(str));

String subtaskToJson(Subtask data) => json.encode(data.toMap());

class Subtask {
  int id;
  int taskId;
  String name;
  Duration estimatedDuration;
  List<LoggedTime> loggedTimes;

  Duration get totalLoggedTime => _calculateTotalLoggedTime();
  double get percentComplete => _calculatePercentComplete();
  static Subtask get empty => Subtask(
        estimatedDuration: Duration(seconds: 0),
        name: '',
      );

  Subtask({
    this.id,
    this.taskId,
    @required this.name,
    @required this.estimatedDuration,
    this.loggedTimes = const <LoggedTime>[],
  });

  factory Subtask.fromMap(Map<String, dynamic> json) => new Subtask(
      id: json['id'],
      taskId: json['taskId'],
      name: json['name'],
      estimatedDuration: Duration(seconds: json['estimatedTime']),
      loggedTimes: new List<LoggedTime>.from(
          json['loggedTimes'].map((loggedTime) => LoggedTime.fromMap(loggedTime))));

  Map<String, dynamic> toMap() => {
        'id': id,
        'taskId': taskId,
        'name': name,
        'estimatedTime': estimatedDuration.inSeconds,
        'loggedTimes':
            new List<dynamic>.from(loggedTimes.map((loggedTime) => loggedTime.toMap()))
      };

  Duration _calculateTotalLoggedTime() {
    Duration totalDuration = Duration.zero;
    for (LoggedTime loggedTime in loggedTimes) {
      totalDuration += loggedTime.timespan;
    }
    return totalDuration;
  }

  double _calculatePercentComplete() {
    Duration totalEstimatedDuration = estimatedDuration;
    Duration totalLoggedTime = _calculateTotalLoggedTime();

    double ratio = totalLoggedTime.inSeconds / totalEstimatedDuration.inSeconds;
    double percent = (ratio.isFinite ? ratio : 0) * 100.0;
    return percent > 100 ? 100 : percent;
  }
}
