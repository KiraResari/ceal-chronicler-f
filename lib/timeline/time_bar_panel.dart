import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:flutter/material.dart';

import 'delete_point_in_time_button.dart';

class TimeBarPanel extends StatelessWidget {
  final PointInTime pointInTime;

  const TimeBarPanel({super.key, required this.pointInTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNamePanel(context),
        _buildButtonRow(context),
      ],
    );
  }

  Widget _buildNamePanel(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Text(pointInTime.name, style: theme.textTheme.bodyLarge),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      children: [
        DeletePointInTimeButton(point: pointInTime),
      ],
    );
  }
}
