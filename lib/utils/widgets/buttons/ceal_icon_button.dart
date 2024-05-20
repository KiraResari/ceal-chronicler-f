import 'package:flutter/material.dart';

import 'ceal_button.dart';

abstract class CealIconButton extends CealButton {
  final IconData icon;

  const CealIconButton({
    super.key,
    required this.icon,
    super.width,
    super.height,
  });

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
