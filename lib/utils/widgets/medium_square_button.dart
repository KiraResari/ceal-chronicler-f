import 'package:flutter/material.dart';

abstract class MediumSquareButton extends StatelessWidget {
  final String tooltip;
  final String? disabledTooltip;
  final IconData icon;

  const MediumSquareButton({
    super.key,
    required this.tooltip,
    required this.icon,
    this.disabledTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 36,
        width: 36,
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
      tooltip: isEnabled(context) ? tooltip : disabledTooltip,
      onPressed: isEnabled(context) ? () => onPressed(context) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        icon,
        color: isEnabled(context) ? enabledIconColor : disabledIconColor,
      ),
    );
  }

  void onPressed(BuildContext context);

  bool isEnabled(BuildContext context) => true;
}
