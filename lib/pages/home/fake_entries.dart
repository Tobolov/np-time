import 'package:grec_minimal/grec_minimal.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/subtask.dart';
import 'package:np_time/models/task.dart';

class FakeEntries {
  static void addEntries() {
    tasksBloc.addBatch(<Task>[
      // DECO2500 assignment
      Task(
        title: 'DECO2500 Assignment Report 3',
        description: 'Complete the design report which our team has been working on.',
        dueDate: DateTime(2019, 6, 10),
        notification: <Duration>[Duration(days: 7), Duration(days: 3)],
        rRule: null,
        subtasks: <Subtask>[
          Subtask(
            name: 'Analyse data',
            estimatedDuration: Duration(hours: 7),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Create Hi-fi Prototype',
            estimatedDuration: Duration(hours: 35),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Evalutate Prototype',
            estimatedDuration: Duration(hours: 15),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Complete report',
            estimatedDuration: Duration(hours: 5),
            loggedTimes: [],
          ),
        ],
      ),

      // Weekly CSSE2010 quiz due monday
      Task(
        title: 'Weekly CSSE2010 Quiz',
        description:
            'Week CSSE2010 Quiz due monday. Contains 4-6 questions of medium difficulty.',
        dueDate: DateTime(2019, 6, 2),
        notification: <Duration>[Duration(days: 3), Duration(days: 1)],
        rRule: RecurrenceRule(Frequency.WEEKLY, null, null, 1, Byday([Weekday.MO], null)),
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
        dueDate: DateTime(2019, 6, 12),
        notification: <Duration>[Duration(days: 7), Duration(days: 3)],
        rRule: null,
        subtasks: <Subtask>[
          Subtask(
            name: 'Question 1',
            estimatedDuration: Duration(hours: 1, minutes: 30),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Question 2',
            estimatedDuration: Duration(minutes: 45),
            loggedTimes: [],
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
        dueDate: DateTime(2019, 6, 15),
        notification: <Duration>[
          Duration(days: 14),
          Duration(days: 7),
          Duration(days: 3),
          Duration(days: 1)
        ],
        rRule: null,
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(hours: 20),
            loggedTimes: [],
          ),
        ],
      ),

      // Monthly planning
      Task(
        title: 'Montly calendar Planning',
        description:
            'Go over and plan the next month in Google Calendar and Npolynomial Time.',
        dueDate: DateTime(2019, 6, 28),
        notification: <Duration>[Duration(days: 0)],
        rRule: RecurrenceRule(Frequency.MONTHLY, null, null, 1, Byday([Weekday.FR], 4)),
        subtasks: <Subtask>[
          Subtask(
            name: '__simple__',
            estimatedDuration: Duration(minutes: 35),
            loggedTimes: [],
          ),
        ],
      ),

      // Redesign the monitoring system
      Task(
        title: 'Redesign infrastructure monitoring system',
        description:
            'Redesign the infrastructure monitoring system in use at work to mitigate the number of false alarms.',
        dueDate: DateTime(2019, 6, 5),
        notification: <Duration>[Duration(days: 0), Duration(days: 3)],
        rRule: null,
        subtasks: <Subtask>[
          Subtask(
            name: 'Research Datadog',
            estimatedDuration: Duration(hours: 3, minutes: 30),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Research Terraform',
            estimatedDuration: Duration(hours: 3, minutes: 30),
            loggedTimes: [],
          ),
          Subtask(
            name: 'Design system architecture',
            estimatedDuration: Duration(hours: 6),
            loggedTimes: [],
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
    ]);
  }
}
