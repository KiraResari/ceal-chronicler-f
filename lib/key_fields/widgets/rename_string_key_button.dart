import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import '../../utils/widgets/rename_dialog.dart';
import 'string_key_field_controller.dart';

class RenameStringKeyButton extends SmallCircularButton {
  final StringKeyFieldController controller;

  const RenameStringKeyButton(this.controller, {super.key})
      : super(icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    String? newName = await _showRenamingDialog(context);
    if (newName != null) {
      controller.renameKey(newName);
    }
  }

  Future<String?> _showRenamingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RenameDialog(
          originalName: controller.currentValue,
          labelText: labelText,
        );
      },
    );
  }

  String get labelText => controller.keyExistsAtCurrentPointInTime
      ? "Edit value at this point in time"
      : "Create new key with the following value";
}
