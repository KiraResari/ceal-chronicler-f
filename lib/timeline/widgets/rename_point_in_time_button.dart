import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import 'rename_point_in_time_alert_dialog.dart';

class RenamePointInTimeButton extends SmallCircularButton {
  final PointInTime point;

  const RenamePointInTimeButton({super.key, required this.point})
      : super(tooltip: "Rename", icon: Icons.edit);

  @override
  Future<void> onPressed(BuildContext context) async {
    TimeBarController controller = context.read<TimeBarController>();
    String? newName = await _showRenamingDialog(context);
    if (newName != null && _nameChangedAndIsNotEmpty(newName)) {
      controller.rename(point, newName);
    }
  }

  Future<String?> _showRenamingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RenamePointInTimeAlertDialog(originalName: point.name);
      },
    );
  }

  bool _nameChangedAndIsNotEmpty(String name) =>
      name.isNotEmpty && name != point.name;
}
