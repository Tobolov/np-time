import 'package:flutter/material.dart';

class CustomTheme {
  static final Color textPrimary = const Color(0xFFFFFFFF);
  static final Color textSecondary = const Color(0xB2FFFFFF);
  static final Color textDisabled = const Color(0x4CFFFFFF);
  static final Color accent = const Color(0xFFF9A825);
  static final Color secondaryColor = const Color(0xFF00838F);
  static final Color secondaryLight = const Color(0xFF4FB3BF);
  static final Color primaryColor = const Color(0xFF33333D);
  static final Color backgroundColor = const Color(0xFF27272F);
  static final Color errorColor = const Color(0xFFC62828);

  static final double borderRadius = 6;

  static TextStyle buildTextStyle({Color color, double size, FontWeight weight}) {
    return TextStyle(
      fontSize: size ?? 19,
      fontFamily: 'RobotoCondensed',
      fontWeight: weight ?? FontWeight.w300,
      color: color ?? CustomTheme.textPrimary,
    );
  }

  static Widget buildDivider({double horizontalMargin, double verticalMargin}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin ?? 16,
        vertical: verticalMargin ?? 0,
      ),
      child: Divider(
        height: 1,
        color: CustomTheme.textDisabled,
      ),
    );
  }

}
