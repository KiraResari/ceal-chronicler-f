import 'package:flutter/material.dart';

abstract class CealButton extends StatelessWidget {
  final String tooltip;
  final String? disabledTooltip;
  final double? height;
  final double? width;

  const CealButton({
    super.key,
    required this.tooltip,
    this.disabledTooltip,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        width: width,
        child: _buildButton(context),
      ),
    );
  }

  FloatingActionButton _buildButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color enabledColor = theme.colorScheme.primaryContainer;
    Color disabledColor = theme.colorScheme.secondaryContainer;
    return FloatingActionButton(
      backgroundColor: isEnabled(context) ? enabledColor : disabledColor,
      tooltip: isEnabled(context) ? tooltip : disabledTooltip,
      onPressed: isEnabled(context) ? () => onPressed(context) : null,
      shape: shape,
      child: buildChild(context),
    );
  }

  void onPressed(BuildContext context);

  bool isEnabled(BuildContext context) => true;

  Widget buildChild(BuildContext context);

  ShapeBorder? get shape => null;
}
