import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import 'key_field_controller.dart';

class ToggleKeyButton extends SmallCircularButton {
  final KeyFieldController controller;
  final bool keyExistsAtCurrentPointInTime;

  const ToggleKeyButton(this.controller, this.keyExistsAtCurrentPointInTime,
      {super.key})
      : super(
          icon: keyExistsAtCurrentPointInTime
              ? Icons.hexagon
              : Icons.hexagon_outlined,
        );

  @override
  void onPressed(BuildContext context) => controller.toggleKey();

  @override
  String? get tooltip => keyExistsAtCurrentPointInTime
      ? "Remove key"
      : "Create key at this point in time using current value";
}
