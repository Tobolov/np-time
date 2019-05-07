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
    int name;
    Duration estimatedTime;
    List<LoggedTime> loggedTimes;

    Subtask({
        this.id,
        @required this.taskId,
        @required this.name,
        @required this.estimatedTime,
        this.loggedTimes = const <LoggedTime>[],
    });

    factory Subtask.fromMap(Map<String, dynamic> json) => new Subtask(
        id: json['id'],
        taskId: json['taskId'],
        name: json['name'],
        estimatedTime: Duration(seconds: json['estimatedTime']),
        loggedTimes: new List<LoggedTime>.from(json['loggedTimes'].map((loggedTime) => LoggedTime.fromMap(loggedTime)))
    );

    Map<String, dynamic> toMap() => {
        'id': id,
        'taskId': taskId,
        'name': name,
        'estimatedTime': estimatedTime.inSeconds,
        'loggedTime': new List<dynamic>.from(loggedTimes.map((loggedTime) => loggedTime.toMap()))
    };
}