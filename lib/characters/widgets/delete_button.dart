import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';

class DeleteButton extends SmallCircularButton {
  final VoidCallback? onPressedFunction;

  const DeleteButton(
      {super.key, required this.onPressedFunction})
      : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    onPressedFunction;
  }

  @override
  String? get tooltip => "Delete last appearance";
}
