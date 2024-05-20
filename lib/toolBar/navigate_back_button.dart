import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/buttons/medium_square_button.dart';
import 'tool_bar_controller.dart';

class NavigateBackButton extends MediumSquareButton {
  const NavigateBackButton({super.key})
      : super(
          tooltip: "Navigate back",
          icon: Icons.navigate_before,
        );

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<ToolBarController>();
    controller.navigateBack();
  }

  @override
  bool isEnabled(BuildContext context) {
    return context.watch<ToolBarController>().isNavigatingBackPossible;
  }

  @override
  String? getDisabledReason(BuildContext context) =>
      "Nothing to navigate back to";
}
