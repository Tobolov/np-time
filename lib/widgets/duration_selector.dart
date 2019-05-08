import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../theme.dart';

class DurationSelector extends StatefulWidget {
  final String title;
  final Function(Duration) onSelected;
  final Duration initalDuration;

  DurationSelector({
    @required this.title,
    @required this.onSelected,
    @required this.initalDuration
  });

  @override
  State<StatefulWidget> createState() {
    return _DurationSelectorState();
  }
}

class _DurationSelectorState extends State<DurationSelector> {
  int hours;
  int minutes;

  @override
  void initState() {
    super.initState();
    hours = widget.initalDuration.inMinutes ~/ 60;
    minutes = widget.initalDuration.inMinutes % 60;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContext(),
      actions: _buildActions(),
    );
  }

  Text _buildTitle() {
    return Text(
      widget.title,
      style: TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: 23,
        color: CustomTheme.textPrimary,
      ),
    );
  }

  Widget _buildContext() {
    return Container(
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDial(
            descriptor: 'Hours',
            maxInt: 100,
            initalValue: widget.initalDuration.inMinutes ~/ 60,
            onSnapped: (int number) {
              setState(() {
                hours = number;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 17),
            child: Text(
              ':',
              style: TextStyle(
                color: CustomTheme.textDisabled,
                fontFamily: 'RobotoCondensed',
                fontSize: 43,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          _buildDial(
            descriptor: 'Minutes',
            maxInt: 60,
            initalValue: widget.initalDuration.inMinutes % 60,
            onSnapped: (int number) {
              setState(() {
                minutes = number;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDial(
      {@required String descriptor,
      @required int maxInt,
      @required Function(int) onSnapped,
      @required int initalValue}) {
    final double fontSize = 35;
    final double segmentSize = fontSize + 16 * 2;

    return Container(
      width: 80,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              descriptor,
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w300,
                fontSize: 20,
                color: CustomTheme.textDisabled,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildDialListView(
                maxInt: maxInt,
                onSnapped: onSnapped,
                fontSize: fontSize,
                segmentSize: segmentSize,
                initalValue: initalValue,
              ),
              _buildDialOverlay(segmentSize: segmentSize),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDialOverlay({@required double segmentSize}) {
    final double dividerHeight = 1.5;
    final double dividerWidth = 50;

    return IgnorePointer(
      child: Column(
        children: <Widget>[
          Container(
            height: dividerHeight,
            width: dividerWidth,
            color: CustomTheme.primaryColor,
          ),
          Container(
            height: segmentSize,
          ),
          Container(
            height: dividerHeight,
            width: dividerWidth,
            color: CustomTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDialListView(
      {@required int maxInt,
      @required Function(int) onSnapped,
      @required double fontSize,
      @required double segmentSize,
      @required int initalValue}) {
    FixedExtentScrollController fixedExtentScrollController =
        new FixedExtentScrollController();

    return Container(
      margin: EdgeInsets.only(top: 0),
      height: (segmentSize * 3) - 16 * 2,
      alignment: Alignment.center,
      child: ListWheelScrollView.useDelegate(
        controller: fixedExtentScrollController,
        physics: FixedExtentScrollPhysics(),
        perspective: 1e-100,
        itemExtent: segmentSize,
        onSelectedItemChanged: (index) => onSnapped((index + initalValue) % maxInt),
        childDelegate: ListWheelChildLoopingListDelegate(
          children: List<Widget>.generate(
            maxInt,
            (index) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  ((index + initalValue) % maxInt).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: fontSize,
                      fontWeight: FontWeight.w300,
                      color: CustomTheme.textPrimary),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      FlatButton(
        child: Text('CANCEL', style: _buildActionTextStyle()),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text('OK', style: _buildActionTextStyle()),
        onPressed: () {
          widget.onSelected(Duration(hours: hours, minutes: minutes));
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  TextStyle _buildActionTextStyle() {
    return TextStyle(fontFamily: 'RobotoCondensed', color: CustomTheme.primaryColor);
  }
}
