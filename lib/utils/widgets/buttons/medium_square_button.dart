import 'package:flutter/material.dart';

import 'ceal_button.dart';

abstract class MediumSquareButton extends CealButton {
  final IconData icon;

  const MediumSquareButton({
    super.key,
    required super.tooltip,
    required this.icon,
    super.disabledTooltip,
  }) : super(height: 36, width: 36);

  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      );

  @override
  Widget buildChild(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color enabledIconColor = theme.colorScheme.onPrimaryContainer;
    Color disabledIconColor = theme.colorScheme.onSurfaceVariant;
    return Icon(
      icon,
      color: isEnabled(context) ? enabledIconColor : disabledIconColor,
    );
  }
}
