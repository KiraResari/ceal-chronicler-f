import 'package:flutter/material.dart';

abstract class SmallCircularButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;

  const SmallCircularButton({
    super.key,
    required this.tooltip,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: _buildButton(context),
      ),
    );
  }

  FloatingActionButton _buildButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color enabledColor = theme.colorScheme.primaryContainer;
    Color disabledColor = theme.colorScheme.secondaryContainer;
    Color enabledIconColor = theme.colorScheme.onPrimaryContainer;
    Color disabledIconColor = theme.colorScheme.onSurfaceVariant;
    return FloatingActionButton(
      backgroundColor: isEnabled(context) ? enabledColor : disabledColor,
      tooltip: isEnabled(context) ? tooltip : getDisabledReason(context),
      onPressed: isEnabled(context) ? () => onPressed(context) : null,
      child: Icon(
        icon,
        color: isEnabled(context) ? enabledIconColor : disabledIconColor,
      ),
    );
  }

  void onPressed(BuildContext context);

  bool isEnabled(BuildContext context) => true;

  String? getDisabledReason(BuildContext context) => null;
}
