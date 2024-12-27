import 'package:flutter/material.dart';

import 'small_circular_button.dart';

class DeleteButton extends SmallCircularButton {
  final VoidCallback? onPressedFunction;
  @override
  final String tooltip;

  const DeleteButton({
    super.key,
    required this.onPressedFunction,
    this.tooltip = "Delete",
  }) : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    onPressedFunction?.call();
  }
}
