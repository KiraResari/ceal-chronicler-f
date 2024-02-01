import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/widgets/point_in_time_button.dart';
import 'package:ceal_chronicler_f/timeline/widgets/rename_point_in_time_button.dart';
import 'package:flutter/material.dart';

import 'delete_point_in_time_button.dart';

class TimeBarPanel extends StatelessWidget {
  final PointInTime pointInTime;

  const TimeBarPanel({super.key, required this.pointInTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PointInTimeButton(point: pointInTime),
        _buildButtonRow(context),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      children: [
        DeletePointInTimeButton(point: pointInTime),
        RenamePointInTimeButton(point: pointInTime),
      ],
    );
  }
}
