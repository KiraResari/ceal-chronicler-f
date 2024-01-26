import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/medium_square_button.dart';
import 'tool_bar_controller.dart';

class SaveButton extends MediumSquareButton {
  const SaveButton({super.key})
      : super(
          tooltip: "Save chronicle",
          disabledTooltip: "Nothing to save",
          icon: Icons.save,
        );

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<ToolBarController>();
    controller.save();
  }

  @override
  bool isEnabled(BuildContext context) {
    return context.watch<ToolBarController>().isSavingPossible;
  }
}
