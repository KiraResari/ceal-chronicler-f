import 'package:flutter/material.dart';

abstract class CealButton extends StatelessWidget {
  final double? height;
  final double? width;

  const CealButton({
    super.key,
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
        child: _buildButtonWithOptionalScaling(context),
      ),
    );
  }

  Widget _buildButtonWithOptionalScaling(BuildContext context) {
    return Transform.scale(
      scale: isHighlighted(context) ? 1.1 : 1.0,
      child: _buildButtonWithOptionalHighlight(context),
    );
  }

  Widget _buildButtonWithOptionalHighlight(BuildContext context) {
    return Container(
      decoration: isHighlighted(context)
          ? const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.amber,
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            )
          : null,
      child: buildButton(context),
    );
  }

  Widget buildButton(BuildContext context);

  void onPressed(BuildContext context);

  bool isEnabled(BuildContext context) => true;

  bool isHighlighted(BuildContext context) => false;

  String? getDisabledReason(BuildContext context) => null;

  ShapeBorder? get shape => null;

  String? get tooltip => null;

  Color? getBackgroundColor(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color enabledColor = theme.colorScheme.primaryContainer;
    Color disabledColor = theme.colorScheme.secondaryContainer;
    return isEnabled(context) ? enabledColor : disabledColor;
  }
}
