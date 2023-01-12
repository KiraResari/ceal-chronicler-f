import 'package:flutter/material.dart';

import '../custom_colors.dart';

class ButtonStyles {
  static final cancel = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CustomColors.cancelButton),
    padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 30)),
  );
}
