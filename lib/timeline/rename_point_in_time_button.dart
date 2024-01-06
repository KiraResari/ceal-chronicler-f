import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/time_bar_controller.dart';
import 'package:ceal_chronicler_f/utils/validation/invalid_result.dart';
import 'package:ceal_chronicler_f/utils/validation/validation_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/small_circular_button.dart';
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
      ValidationResult validationResult = controller.validateNewName(newName);
      if (validationResult is InvalidResult) {
        _showErrorDialog(context, validationResult.reason);
      } else {
        controller.rename(point, newName);
      }
    }
  }

  Future<String?> _showRenamingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RenamePointInTimeAlertDialog(point: point);
      },
    );
  }

  bool _nameChangedAndIsNotEmpty(String name) =>
      name.isNotEmpty && name != point.name;

  Future<void> _showErrorDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }
}
