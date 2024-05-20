import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/buttons/medium_square_button.dart';
import 'tool_bar_controller.dart';

class LoadButton extends MediumSquareButton {
  const LoadButton({super.key}) : super(icon: Icons.folder_rounded);

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<ToolBarController>();
    controller.load();
  }

  @override
  bool isEnabled(BuildContext context) => !kIsWeb;

  @override
  String? getDisabledReason(BuildContext context) {
    return kIsWeb ? "Loading in browser is not supported" : null;
  }

  @override
  String? get tooltip => "Load chronicle";
}
