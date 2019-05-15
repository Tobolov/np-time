import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../theme.dart';

class DialSelector extends StatefulWidget {
  final String title;
  final List<String> dialTitles;
  final List<int> initalDialValues;
  final List<int> dialMaxs;
  final Function(List<int>) onSelected;

  DialSelector({
    @required this.title,
    @required this.dialTitles,
    @required this.initalDialValues,
    @required this.dialMaxs,
    @required this.onSelected,
  });

  @override
  State<StatefulWidget> createState() {
    return _DialSelectorState();
  }
}

class _DialSelectorState extends State<DialSelector> {
  List<int> dialValues;

  @override
  void initState() {
    super.initState();
    dialValues = List<int>.from(widget.initalDialValues);
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
      height: 225,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: () {
          List<Widget> widgets = [];
          for (int index = 0; index < widget.dialMaxs.length; index++) {
            // add dial
            widgets.add(_buildDial(
              descriptor: widget.dialTitles[index],
              maxInt: widget.dialMaxs[index],
              initalValue: widget.initalDialValues[index],
              onSnapped: (int number) {
                setState(() {
                  dialValues[index] = number;
                });
              },
            ));

            // add ':' seperator between every dial
            if (index < widget.dialMaxs.length - 1) {
              widgets.add(
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
              );
            }
          }
          return widgets;
        }(),
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
            color: CustomTheme.secondaryColor,
          ),
          Container(
            height: segmentSize,
          ),
          Container(
            height: dividerHeight,
            width: dividerWidth,
            color: CustomTheme.secondaryColor,
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
        onPressed: () async {
          await widget.onSelected(dialValues);
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  TextStyle _buildActionTextStyle() {
    return CustomTheme.buildTextStyle(color: CustomTheme.secondaryColor);
  }
}
