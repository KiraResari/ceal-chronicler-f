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
  FloatingActionButton buildButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: getBackgroundColor(context),
      tooltip: isEnabled(context) ? tooltip : getDisabledReason(context),
      onPressed: isEnabled(context) ? () => onPressed(context) : null,
      shape: shape,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color enabledIconColor = theme.colorScheme.onPrimaryContainer;
    Color disabledIconColor = theme.colorScheme.onSurfaceVariant;
    return Icon(
      icon,
      color: isEnabled(context) ? enabledIconColor : disabledIconColor,
    );
  }
}
