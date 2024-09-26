import 'package:flutter/material.dart';

import '../../utils/string_key.dart';
import '../model/point_in_time.dart';
import 'delete_point_in_time_button.dart';
import 'point_in_time_button.dart';
import 'rename_point_in_time_button.dart';

class TimeBarPanel extends StatelessWidget {
  static const String pointInTimeButtonKeyBase = "pointInTimeButton";
  static const String deleteButtonKeyBase = "deleteButton";
  static const String renameButtonKeyBase = "renameButton";

  final PointInTime pointInTime;
  final StringKey stringKey;

  const TimeBarPanel({required this.stringKey, required this.pointInTime})
      : super(key: stringKey);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PointInTimeButton(
          point: pointInTime,
          key: Key("$key$pointInTimeButtonKeyBase"),
        ),
        _buildButtonRow(context),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      children: [
        RenamePointInTimeButton(
          point: pointInTime,
          key: StringKey("$key$renameButtonKeyBase"),
        ),
        DeletePointInTimeButton(
          point: pointInTime,
          key: StringKey("$key$deleteButtonKeyBase"),
        ),
      ],
    );
  }
}
