import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/buttons/medium_square_button.dart';
import 'tool_bar_controller.dart';

class UndoButton extends MediumSquareButton {
  const UndoButton({super.key})
      : super(
          tooltip: "Undo",
          icon: Icons.undo,
        );

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<ToolBarController>();
    controller.undo();
  }

  @override
  bool isEnabled(BuildContext context) {
    return context.watch<ToolBarController>().isUndoPossible;
  }

  @override
  String? getDisabledReason(BuildContext context) =>
      "Nothing to undo";
}
