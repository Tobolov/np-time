import 'package:flutter/material.dart';
import 'package:np_time/pages/tasks/task_list_widget.dart';

import './home_bloc.dart';
import 'package:np_time/bloc/tasks_bloc.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearch(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return _buildSearch(context);
  }

  Widget _buildSearch(BuildContext context) {
    return TasksList(
      noData: 'It\'s lonely here. \nHow about creating a new task!',
      searchFilter: query,
    );
  }
}
