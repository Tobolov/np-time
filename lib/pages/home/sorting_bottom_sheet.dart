import 'package:flutter/material.dart';
import 'package:np_time/bloc/tasks_bloc.dart';
import 'package:np_time/models/task.dart';
import 'package:np_time/theme.dart';

class SortingBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SortingBottomSheetState();
  }
}

class _SortingBottomSheetState extends State<SortingBottomSheet> {
  SortBy radioSortingMethodOption;
  SortOrder radioSortingOrderOption;

  @override
  void initState() {
    super.initState();

    radioSortingMethodOption = tasksBloc.lastSortBy;
    radioSortingOrderOption = tasksBloc.lastSortOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, bottom: 16),
            child: Text('Sort by', style: CustomTheme.buildTextStyle(size: 25)),
          ),
          _buildSortingMethodOption(label: 'Title', sortBy: SortBy.Title),
          _buildSortingMethodOption(label: 'Due date', sortBy: SortBy.DueDate),
          _buildSortingMethodOption(label: 'Percent complete', sortBy: SortBy.PercentComplete),
          _buildSortingMethodOption(label: 'Estimated Duration', sortBy: SortBy.EstimatedDuration),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: CustomTheme.textDisabled),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, bottom: 16),
            child: Text('Order', style: CustomTheme.buildTextStyle(size: 25)),
          ),
          _buildSortingOrderOption(label: 'Ascending', sortOrder: SortOrder.Ascending),
          _buildSortingOrderOption(label: 'Descending', sortOrder: SortOrder.Descending),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'CANCEL',
                        style: CustomTheme.buildTextStyle(
                          color: CustomTheme.primaryColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 16),
                    FlatButton(
                      child: Text(
                        'DONE',
                        style: CustomTheme.buildTextStyle(
                          color: CustomTheme.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        tasksBloc.setSortBy(radioSortingMethodOption);
                        tasksBloc.setSortOrder(radioSortingOrderOption);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortingOrderOption(
      {@required String label, @required SortOrder sortOrder}) {
    return _buildRadioOption<SortOrder>(
      label: label,
      groupValue: radioSortingOrderOption,
      value: sortOrder,
      onPressed: () {
        setState(() => radioSortingOrderOption = sortOrder);
      },
    );
  }

  Widget _buildSortingMethodOption({@required String label, @required SortBy sortBy}) {
    return _buildRadioOption<SortBy>(
      label: label,
      groupValue: radioSortingMethodOption,
      value: sortBy,
      onPressed: () {
        setState(() => radioSortingMethodOption = sortBy);
      },
    );
  }

  Widget _buildRadioOption<T>(
      {@required String label,
      @required T value,
      @required T groupValue,
      @required Function onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Row(children: <Widget>[
        Radio<T>(
          value: value,
          onChanged: (value) {},
          groupValue: groupValue,
          activeColor: CustomTheme.primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(
          child: Text(label, style: CustomTheme.buildTextStyle()),
        ),
      ]),
    );
  }
}
