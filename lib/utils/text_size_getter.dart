import 'package:flutter/material.dart';

class TextSizeGetter {
  static double getTextWidth(
      String fieldName, TextStyle? textStyle, BuildContext context) {
    Size size = getTextSize(fieldName, textStyle, context);
    return size.width;
  }

  static Size getTextSize(
      String fieldName, TextStyle? textStyle, BuildContext context) {
    var textPainter = TextPainter(
      text: TextSpan(
        text: fieldName,
        style: textStyle,
      ),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }
}
