import 'package:flutter/material.dart';

import 'custom_colors.dart';

class ButtonStyles {
  static final _defaultPadding =
      WidgetStateProperty.all(const EdgeInsets.all(5));
  static final _defaultTextStyle =
      WidgetStateProperty.all(const TextStyle(fontSize: 30));

  static final cancel = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(CustomColors.cancelButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final confirm = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(CustomColors.confirmButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final neutral = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(CustomColors.neutralButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final save = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(CustomColors.saveButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final load = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(CustomColors.loadButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
}
