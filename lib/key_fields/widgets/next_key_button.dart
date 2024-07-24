import 'package:ceal_chronicler_f/key_fields/widgets/key_field_controller.dart';
import 'package:ceal_chronicler_f/utils/widgets/buttons/ceal_icon_button.dart';
import 'package:flutter/material.dart';

class NextKeyButton extends CealIconButton {
  final KeyFieldController controller;
  final bool enabled;

  const NextKeyButton(this.controller, this.enabled, {super.key})
      : super(icon: Icons.arrow_right, width: 25, height: 25);

  @override
  void onPressed(BuildContext context) => controller.goToNext();

  @override
  bool isEnabled(BuildContext context) => enabled;
}
