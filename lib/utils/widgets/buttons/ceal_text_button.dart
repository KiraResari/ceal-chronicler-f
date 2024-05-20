import 'package:flutter/material.dart';

import 'ceal_button.dart';

abstract class CealTextButton extends CealButton {
  const CealTextButton({
    super.key,
    super.width,
    super.height = 32,
  });

  @override
  FloatingActionButton buildButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: getBackgroundColor(context),
      tooltip: isEnabled(context) ? tooltip : getDisabledReason(context),
      onPressed: isEnabled(context) ? () => onPressed(context) : null,
      shape: shape,
      label: Text(
        text,
        style: getTextStyle(context),
      ),
    );
  }

  String get text;

  TextStyle getTextStyle(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextStyle(
      color: isEnabled(context)
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
    );
  }
}
