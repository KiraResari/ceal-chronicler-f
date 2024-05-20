import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/buttons/medium_square_button.dart';
import 'tool_bar_controller.dart';

class NavigateForwardButton extends MediumSquareButton {
  const NavigateForwardButton({super.key}) : super(icon: Icons.navigate_next);

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<ToolBarController>();
    controller.navigateForward();
  }

  @override
  bool isEnabled(BuildContext context) {
    return context.watch<ToolBarController>().isNavigatingForwardPossible;
  }

  @override
  String? getDisabledReason(BuildContext context) =>
      "Nothing to navigate forward to";

  @override
  String? get tooltip => "Navigate forward";
}
