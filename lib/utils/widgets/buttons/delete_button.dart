import 'package:flutter/material.dart';

import 'small_circular_button.dart';

class DeleteButton extends SmallCircularButton {
  final VoidCallback? onPressedFunction;

  const DeleteButton(
      {super.key, required this.onPressedFunction})
      : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    onPressedFunction?.call();
  }

  @override
  String? get tooltip => "Delete last appearance";
}
