import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _searchQueries  = PublishSubject<String>();

  Observable<String> get searchQueries => _searchQueries.stream;

  addQuery(String query) {
    _searchQueries.sink.add(query);
  }

  dispose() {
    _searchQueries.close();
  }
}

final homeBloc = HomeBloc();