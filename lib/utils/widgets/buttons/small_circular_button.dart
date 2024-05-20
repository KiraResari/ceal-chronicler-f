import 'package:flutter/material.dart';

import 'ceal_button.dart';

abstract class SmallCircularButton extends CealButton {
  final IconData icon;

  const SmallCircularButton({
    super.key,
    required super.tooltip,
    required this.icon,
  }) : super(height: 24, width: 24);

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
