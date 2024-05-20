import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/buttons/medium_square_button.dart';
import 'tool_bar_controller.dart';

class SaveButton extends MediumSquareButton {
  const SaveButton({super.key})
      : super(
          tooltip: "Save chronicle",
          icon: Icons.save,
        );

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<ToolBarController>();
    controller.save();
  }

  @override
  bool isEnabled(BuildContext context) {
    if (kIsWeb) {
      return false;
    }
    return context.watch<ToolBarController>().isSavingPossible;
  }

  @override
  String? getDisabledReason(BuildContext context) =>
      kIsWeb ? "Saving in browser is not supported" : "Nothing to save";
}
