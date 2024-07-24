import 'package:ceal_chronicler_f/key_fields/widgets/key_field_controller.dart';
import 'package:ceal_chronicler_f/utils/widgets/buttons/ceal_icon_button.dart';
import 'package:flutter/material.dart';

class PreviousKeyButton extends CealIconButton {
  final KeyFieldController controller;
  final bool enabled;

  const PreviousKeyButton(this.controller, this.enabled, {super.key})
      : super(icon: Icons.arrow_left, width: 25, height: 25);

  @override
  void onPressed(BuildContext context) => controller.goToPrevious();

  @override
  bool isEnabled(BuildContext context) => enabled;

  @override
  String? get tooltip => "Go to previous key";

  @override
  String? getDisabledReason(BuildContext context) => "No previous key to go to";
}
