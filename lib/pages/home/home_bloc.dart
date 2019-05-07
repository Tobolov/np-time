import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _searchQueries = PublishSubject<String>();
  final _applicationFab = PublishSubject<ApplicationFab>();

  Observable<String> get searchQueries => _searchQueries.stream;
  Observable<ApplicationFab> get applicationFabs => _applicationFab.stream;

  addQuery(String query) {
    _searchQueries.sink.add(query);
  }

  updateFab(ApplicationFab applicationFab) {
    _applicationFab.sink.add(applicationFab);
  }

  dispose() {
    _searchQueries.close();
    _applicationFab.close();
  }
}

class ApplicationFab {
  IconData icon;
  Function onPressed;

  ApplicationFab({@required this.icon, @required this.onPressed});

  static ApplicationFab get none => ApplicationFab(icon: null, onPressed: null);
}

final homeBloc = HomeBloc();
