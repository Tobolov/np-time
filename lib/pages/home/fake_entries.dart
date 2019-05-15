import 'package:grec_minimal/grec_minimal.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/logged_time.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';

class FakeEntries {
  static DateTime _ahead(int days) {
    return DateTime.now().add(Duration(days: days));
  }

  static DateTime _before(int days) {
    return DateTime.now().subtract(Duration(days: days));
  }

  static void addEntries() {
    tasksBloc.addBatch(<Task>[
      // 
      Task(
        title: 'Catchup on MATH1052 Lectures',
        description:
            'Catchup on the last 2 MATH1052 lectures.',
        dueDate: _before(3),
        notification: <Duration>[Duration(days: 1)],
        rRule: null,
        creationDate: _before(7),
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(hours: 3),
            loggedTimes: [
              LoggedTime(date: _before(2), timespan: Duration(hours: 1, minutes: 20)),
              LoggedTime(date: _before(4), timespan: Duration(hours: 1, minutes: 20)),
            ],
          ),
        ],
      ),

      // DECO2500 assignment
      Task(
        title: 'DECO2500 Assignment Report 3',
        description: 'Complete the design report which our team has been working on.',
        dueDate: _ahead(5),
        notification: <Duration>[Duration(days: 7), Duration(days: 3)],
        rRule: null,
        creationDate: _before(39),
        subtasks: <Subtask>[
          Subtask(
            name: 'Analyse data',
            estimatedDuration: Duration(hours: 7),
            loggedTimes: [
              LoggedTime(date: _before(35), timespan: Duration(hours: 1, minutes: 20)),
              LoggedTime(date: _before(33), timespan: Duration(hours: 4, minutes: 45)),
              LoggedTime(date: _before(32), timespan: Duration(hours: 0, minutes: 15)),
              LoggedTime(date: _before(31), timespan: Duration(hours: 0, minutes: 38)),
            ],
          ),
          Subtask(
            name: 'Create Hi-fi Prototype',
            estimatedDuration: Duration(hours: 35),
            loggedTimes: [
              LoggedTime(date: _before(30), timespan: Duration(hours: 2, minutes: 40)),
              LoggedTime(date: _before(29), timespan: Duration(hours: 3, minutes: 25)),
              LoggedTime(date: _before(29), timespan: Duration(hours: 4, minutes: 20)),
              LoggedTime(date: _before(26), timespan: Duration(hours: 8, minutes: 40)),
              LoggedTime(date: _before(27), timespan: Duration(hours: 3, minutes: 20)),
              LoggedTime(date: _before(28), timespan: Duration(hours: 1, minutes: 15)),
              LoggedTime(date: _before(24), timespan: Duration(hours: 7, minutes: 0)),
              LoggedTime(date: _before(23), timespan: Duration(hours: 9, minutes: 0)),
            ],
          ),
          Subtask(
            name: 'Evalutate Prototype',
            estimatedDuration: Duration(hours: 30),
            loggedTimes: [
              LoggedTime(date: _before(22), timespan: Duration(hours: 0, minutes: 40)),
              LoggedTime(date: _before(17), timespan: Duration(hours: 7, minutes: 20)),
              LoggedTime(date: _before(15), timespan: Duration(hours: 3, minutes: 35)),
              LoggedTime(date: _before(14), timespan: Duration(hours: 4, minutes: 8)),
              LoggedTime(date: _before(13), timespan: Duration(hours: 0, minutes: 17)),
              LoggedTime(date: _before(11), timespan: Duration(hours: 3, minutes: 0)),
              LoggedTime(date: _before(8), timespan: Duration(hours: 4, minutes: 0)),
            ],
          ),
          Subtask(
            name: 'Complete report',
            estimatedDuration: Duration(hours: 15),
            loggedTimes: [
              LoggedTime(date: _before(7), timespan: Duration(hours: 8, minutes: 0)),
              LoggedTime(date: _before(5), timespan: Duration(hours: 0, minutes: 30)),
              LoggedTime(date: _before(2), timespan: Duration(hours: 0, minutes: 10)),
            ],
          ),
        ],
      ),

      // Weekly CSSE2010 quiz due monday
      Task(
        title: 'Weekly CSSE2010 Quiz',
        description:
            'Week CSSE2010 Quiz due monday. Contains 4-6 questions of medium difficulty.',
        dueDate: _ahead(2),
        notification: <Duration>[Duration(days: 3), Duration(days: 1)],
        rRule: RecurrenceRule(Frequency.WEEKLY, null, null, 1,
            Byday([Weekday.values[_ahead(2).weekday - 1]], null)),
        creationDate: _before(7),
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(minutes: 20),
            loggedTimes: [],
          ),
        ],
      ),

      // MATH1052 Assignment
      Task(
        title: 'MATH1052 Assignment 4',
        description: null,
        dueDate: _ahead(8),
        notification: <Duration>[Duration(days: 7), Duration(days: 3)],
        rRule: null,
        creationDate: _before(7),
        subtasks: <Subtask>[
          Subtask(
            name: 'Question 1',
            estimatedDuration: Duration(hours: 1, minutes: 30),
            loggedTimes: [
              LoggedTime(date: _before(4), timespan: Duration(hours: 1, minutes: 0)),
              LoggedTime(date: _before(2), timespan: Duration(hours: 0, minutes: 32)),
            ],
          ),
          Subtask(
            name: 'Question 2',
            estimatedDuration: Duration(minutes: 45),
            loggedTimes: [
              LoggedTime(date: _before(1), timespan: Duration(hours: 1, minutes: 0)),
            ],
          ),
          Subtask(
            name: 'Question 3',
            estimatedDuration: Duration(hours: 2, minutes: 15),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Question 4',
            estimatedDuration: Duration(minutes: 15),
            loggedTimes: [],
          ),
        ],
      ),

      // CSSE2010 Project
      Task(
        title: 'CSSE2010 Project',
        description: 'A large project to be coded in C for the AVR ATmega324A.',
        dueDate: _ahead(13),
        notification: <Duration>[
          Duration(days: 14),
          Duration(days: 7),
          Duration(days: 3),
          Duration(days: 1)
        ],
        rRule: null,
        creationDate: _before(2),
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(hours: 20),
            loggedTimes: [
              LoggedTime(date: _before(0), timespan: Duration(hours: 3, minutes: 0)),
              LoggedTime(date: _before(1), timespan: Duration(hours: 0, minutes: 25)),
            ],
          ),
        ],
      ),

      // Monthly planning
      Task(
        title: 'Montly calendar Planning',
        description:
            'Go over and plan the next month in Google Calendar and Npolynomial Time.',
        dueDate: _ahead(4),
        notification: <Duration>[Duration(days: 0)],
        rRule: RecurrenceRule(Frequency.MONTHLY, null, null, 1,
            Byday([Weekday.values[_ahead(4).weekday - 1]], _ahead(4).day ~/ 7)),
        creationDate: _before(5),
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(minutes: 35),
            loggedTimes: [
              LoggedTime(date: _before(3), timespan: Duration(hours: 0, minutes: 36)),
            ],
          ),
        ],
      ),

      // Redesign the monitoring system
      Task(
        title: 'Redesign infrastructure monitoring system',
        description:
            'Redesign the infrastructure monitoring system in use at work to mitigate the number of false alarms.',
        dueDate: _ahead(11),
        notification: <Duration>[Duration(days: 0), Duration(days: 3)],
        rRule: null,
        creationDate: _before(5),
        subtasks: <Subtask>[
          Subtask(
            name: 'Research Datadog',
            estimatedDuration: Duration(hours: 3, minutes: 30),
            loggedTimes: [
              LoggedTime(date: _before(9), timespan: Duration(hours: 0, minutes: 30)),
              LoggedTime(date: _before(8), timespan: Duration(hours: 1, minutes: 35)),
              LoggedTime(date: _before(6), timespan: Duration(hours: 1, minutes: 30)),
            ],
          ),
          Subtask(
            name: 'Research Terraform',
            estimatedDuration: Duration(hours: 3, minutes: 30),
            loggedTimes: [
              LoggedTime(date: _before(4), timespan: Duration(hours: 2, minutes: 30)),
              LoggedTime(date: _before(3), timespan: Duration(hours: 1, minutes: 30)),
            ],
          ),
          Subtask(
            name: 'Design system architecture',
            estimatedDuration: Duration(hours: 16),
            loggedTimes: [
              LoggedTime(date: _before(1), timespan: Duration(hours: 7, minutes: 0)),
            ],
          ),
          Subtask(
            name: 'Review system architecture',
            estimatedDuration: Duration(hours: 1),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Implement system architecture',
            estimatedDuration: Duration(hours: 25),
            loggedTimes: [],
          ),
        ],
      ),

      Task(
        title: 'Weekly Chill Time',
        description:
            'Keep track of your cooldown time for the week.',
        dueDate: _ahead(6),
        notification: <Duration>[],
        rRule: RecurrenceRule(Frequency.WEEKLY, null, null, 1,
            Byday([Weekday.values[_ahead(6).weekday - 1]], null)),
        creationDate: _before(1),
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(hours: 6),
            loggedTimes: [],
          ),
        ],
      ),

      // [deleted] MATH1052 Assignment 2
      Task(
        deleted: _before(4),
        title: 'MATH1052 Assignment 2',
        description: null,
        dueDate: _before(2),
        notification: <Duration>[Duration(days: 1), Duration(days: 3)],
        rRule: null,
        creationDate: _before(15),
        subtasks: <Subtask>[
          Subtask(
            name: 'Question 1',
            estimatedDuration: Duration(minutes: 15),
            loggedTimes: [
              LoggedTime(date: _before(8), timespan: Duration(minutes: 16)),
            ],
          ),
          Subtask(
            name: 'Question 2',
            estimatedDuration: Duration(minutes: 45),
            loggedTimes: [
              LoggedTime(date: _before(8), timespan: Duration(minutes: 63)),
            ],
          ),
          Subtask(
            name: 'Question 3',
            estimatedDuration: Duration(hours: 1, minutes: 15),
            loggedTimes: [
              LoggedTime(date: _before(7), timespan: Duration(minutes: 30)),
              LoggedTime(date: _before(5), timespan: Duration(hours: 1)),
            ],
          ),
          Subtask(
            name: 'Question 4',
            estimatedDuration: Duration(minutes: 45),
            loggedTimes: [
              LoggedTime(date: _before(5), timespan: Duration(minutes: 45)),
            ],
          ),
        ],
      ),

      // [deleted] MATH1052 Assignment 1
      Task(
        deleted: _before(25),
        title: 'MATH1052 Assignment 1',
        description: null,
        dueDate: _before(23),
        notification: <Duration>[Duration(days: 1), Duration(days: 3)],
        rRule: null,
        creationDate: _before(33),
        subtasks: <Subtask>[
          Subtask(
            name: 'Question 1',
            estimatedDuration: Duration(minutes: 40),
            loggedTimes: [
              LoggedTime(date: _before(30), timespan: Duration(minutes: 40)),
            ],
          ),
          Subtask(
            name: 'Question 2',
            estimatedDuration: Duration(minutes: 85),
            loggedTimes: [
              LoggedTime(date: _before(30), timespan: Duration(minutes: 90)),
            ],
          ),
          Subtask(
            name: 'Question 3',
            estimatedDuration: Duration(hours: 3, minutes: 15),
            loggedTimes: [
              LoggedTime(date: _before(25), timespan: Duration(hours: 3, minutes: 15)),
            ],
          ),
        ],
      ),
    ]);
  }
}
