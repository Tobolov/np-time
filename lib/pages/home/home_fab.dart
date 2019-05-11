import 'package:flutter/material.dart';

import './home_bloc.dart';

class HomeFloatingActionButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeFloatingActionButtonState();
  }
}

class _HomeFloatingActionButtonState extends State<HomeFloatingActionButton> {
  Function _onPressed;
  Icon _icon;
  double _opacity = 0.0;

  _HomeFloatingActionButtonState() {
    homeBloc.applicationFabs.listen(
      ((ApplicationFab applicationFab) {
        if (applicationFab.icon != null && applicationFab.onPressed != null) {
          setState(() {
            _onPressed = applicationFab.onPressed;
            _icon = Icon(applicationFab.icon);
            _opacity = 1.0;
          });
        } else {
          setState(() {
            _onPressed = null;
            _opacity = 0.0;
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: _opacity,
      child: FloatingActionButton(
        child: _icon ?? Container(),
        onPressed: () {
          if (_onPressed != null) {
            _onPressed();
          }
        },
      ),
    );
  }
}
