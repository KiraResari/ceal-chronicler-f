import 'package:ceal_chronicler_f/key_fields/widgets/key_field_controller.dart';
import 'package:ceal_chronicler_f/utils/widgets/buttons/ceal_icon_button.dart';
import 'package:flutter/material.dart';

class ToggleKeyButton extends CealIconButton {
  final KeyFieldController controller;
  final bool keyExistsAtCurrentPointInTime;

  const ToggleKeyButton(this.controller, this.keyExistsAtCurrentPointInTime,
      {super.key})
      : super(
            icon: keyExistsAtCurrentPointInTime
                ? Icons.hexagon
                : Icons.hexagon_outlined,
            width: 25,
            height: 25);

  @override
  void onPressed(BuildContext context) => controller.toggleKey();
}
