import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import 'key_field_controller.dart';

class PreviousKeyButton extends SmallCircularButton {
  final KeyFieldController controller;
  final bool enabled;

  const PreviousKeyButton(this.controller, this.enabled, {super.key})
      : super(icon: Icons.arrow_left);

  @override
  void onPressed(BuildContext context) => controller.goToPrevious();

  @override
  bool isEnabled(BuildContext context) => enabled;

  @override
  String? get tooltip => "Go to previous key";

  @override
  String? getDisabledReason(BuildContext context) => "No previous key to go to";
}
