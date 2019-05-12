// To parse this JSON data, do
//
//     final loggedTime = loggedTimeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

LoggedTime loggedTimeFromJson(String str) => LoggedTime.fromMap(json.decode(str));

String loggedTimeToJson(LoggedTime data) => json.encode(data.toMap());

class LoggedTime {
    int id;
    int taskId;
    int subtaskId;
    DateTime date;
    Duration timespan;

    LoggedTime({
        this.id,
        this.taskId,
        this.subtaskId,
        @required this.date,
        @required this.timespan,
    });

    factory LoggedTime.fromMap(Map<String, dynamic> json) => new LoggedTime(
        id: json['id'],
        taskId: json['taskId'],
        subtaskId: json['subtaskId'],
        date: DateTime.parse(json['date']),
        timespan: Duration(seconds: json['timespan']),
    );

    Map<String, dynamic> toMap() => {
        'id': id,
        'taskId': taskId,
        'subtaskId': subtaskId,
        'date': date.toIso8601String(),
        'timespan': timespan.inSeconds,
    };
}
