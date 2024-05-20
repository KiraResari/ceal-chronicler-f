import 'package:flutter/material.dart';

import 'ceal_button.dart';

abstract class CealTextButton extends CealButton {

  const CealTextButton({
    super.key,
    super.width,
    super.height,
  });

  @override
  Widget buildChild(BuildContext context) {
    return Text(text);
  }

  String get text;
}
