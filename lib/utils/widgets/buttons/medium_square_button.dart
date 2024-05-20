import 'package:flutter/material.dart';

import 'ceal_icon_button.dart';

abstract class MediumSquareButton extends CealIconButton {
  const MediumSquareButton({
    super.key,
    required super.tooltip,
    required super.icon,
  }) : super(height: 36, width: 36);

  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      );
}
