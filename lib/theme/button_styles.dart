import 'package:flutter/material.dart';

import 'custom_colors.dart';

class ButtonStyles {
  static final _defaultPadding =
      MaterialStateProperty.all(const EdgeInsets.all(5));
  static final _defaultTextStyle =
      MaterialStateProperty.all(const TextStyle(fontSize: 30));

  static final cancel = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CustomColors.cancelButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final confirm = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CustomColors.confirmButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final neutral = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CustomColors.neutralButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final save = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CustomColors.saveButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
  static final load = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CustomColors.loadButton),
    padding: _defaultPadding,
    textStyle: _defaultTextStyle,
  );
}
