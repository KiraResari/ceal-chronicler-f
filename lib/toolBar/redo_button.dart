import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/medium_square_button.dart';
import 'tool_bar_controller.dart';

class RedoButton extends MediumSquareButton {
  const RedoButton({super.key})
      : super(
          tooltip: "Redo",
          disabledTooltip: "Nothing to redo",
          icon: Icons.redo,
        );

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<ToolBarController>();
    controller.redo();
  }

  @override
  bool isEnabled(BuildContext context) {
    return context.watch<ToolBarController>().isRedoPossible;
  }
}
