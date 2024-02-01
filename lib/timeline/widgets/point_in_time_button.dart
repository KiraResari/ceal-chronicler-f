import 'package:ceal_chronicler_f/timeline/widgets/point_in_time_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/point_in_time.dart';

class PointInTimeButton extends StatelessWidget {
  static const tooltip = "Make this the active point in time";
  static const disabledTooltip = "This is already the active point in time";

  final PointInTime point;

  const PointInTimeButton({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    var controller = PointInTimeButtonController(point);
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, child) => _buildPaddedButton(context),
    );
  }

  Widget _buildPaddedButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 36,
        width: 150,
        child: _buildButton(context),
      ),
    );
  }

  FloatingActionButton _buildButton(BuildContext context) {
    var controller = context.watch<PointInTimeButtonController>();
    ThemeData theme = Theme.of(context);
    Color enabledColor = theme.colorScheme.primaryContainer;
    Color disabledColor = theme.colorScheme.secondaryContainer;
    TextStyle textStyle = TextStyle(
      color: controller.isEnabled
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
    );
    return FloatingActionButton(
      backgroundColor: controller.isEnabled ? enabledColor : disabledColor,
      tooltip: controller.isEnabled ? tooltip : disabledTooltip,
      onPressed:
          controller.isEnabled ? () => controller.activatePointInTime() : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        controller.point.name,
        style: textStyle,
      ),
    );
  }
}
