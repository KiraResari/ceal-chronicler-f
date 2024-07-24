import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import 'key_field_controller.dart';

class NextKeyButton extends SmallCircularButton {
  final KeyFieldController controller;
  final bool enabled;

  const NextKeyButton(this.controller, this.enabled, {super.key})
      : super(icon: Icons.arrow_right);

  @override
  void onPressed(BuildContext context) => controller.goToNext();

  @override
  bool isEnabled(BuildContext context) => enabled;

  @override
  String? get tooltip => "Go to next key";

  @override
  String? getDisabledReason(BuildContext context) => "No next key to go to";
}
