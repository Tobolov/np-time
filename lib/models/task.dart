// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';

import './subtask.dart';

Task taskFromJson(String str) => Task.fromMap(json.decode(str));

String taskToJson(Task data) => json.encode(data.toMap());

class Task {
  int id;
  String title;
  bool deleted;
  String description;
  DateTime dueDate;
  DateTime repeatStartDate;
  String repeatCycle;
  List<String> notification;
  List<Subtask> subtasks;

  Task({
    this.id,
    @required this.title,
    this.deleted = false,
    @required this.description,
    @required this.dueDate,
    @required this.repeatStartDate,
    @required this.repeatCycle,
    @required this.notification,
    this.subtasks = const <Subtask>[],
  });

  static Task get template => Task(
        description: null,
        dueDate: null,
        notification: null,
        repeatCycle: null,
        repeatStartDate: null,
        title: null,
        deleted: false,
        subtasks: <Subtask>[],
      );

  factory Task.fromMap(Map<String, dynamic> json) => new Task(
        id: json['id'],
        title: json['title'],
        deleted: json['deleted'] != 0,
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        repeatStartDate: DateTime.parse(json['repeatStartDate']),
        repeatCycle: json['repeatCycle'],
        notification: json['notification'].toString().split(','),
        subtasks: new List<Subtask>.from(
            (json['subtasks'] ?? <Subtask>[]).map((subtask) => Subtask.fromMap(subtask))),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'deleted': deleted,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'repeatStartDate': repeatStartDate.toIso8601String(),
        'repeatCycle': repeatCycle,
        'notification': notification.join(','),
        'subtasks': new List<dynamic>.from(subtasks.map((subtask) => subtask.toMap())),
      };
}
