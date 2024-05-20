import 'package:flutter/material.dart';

import 'ceal_button.dart';

abstract class CealTextButton extends CealButton {

  const CealTextButton({
    super.key,
    super.width,
    super.height,
  });

  @override
  FloatingActionButton buildButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: getBackgroundColor(context),
      tooltip: isEnabled(context) ? tooltip : getDisabledReason(context),
      onPressed: isEnabled(context) ? () => onPressed(context) : null,
      shape: shape,
      label: Text(text),
    );
  }

  String get text;
}
