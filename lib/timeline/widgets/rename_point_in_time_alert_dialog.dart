import 'package:ceal_chronicler_f/timeline/widgets/rename_point_in_time_alert_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/dialogs/rename_dialog.dart';
import '../../utils/widgets/dialogs/rename_dialog_controller.dart';

class RenamePointInTimeAlertDialog extends RenameDialog {
  const RenamePointInTimeAlertDialog({super.key, required super.originalName})
      : super(labelText: "Rename point in time");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RenamePointInTimeAlertDialogController(originalName),
      builder: (context, child) => buildAlertDialog(context),
    );
  }

  @override
  RenameDialogController readController(BuildContext context) {
    return context.read<RenamePointInTimeAlertDialogController>();
  }

  @override
  RenameDialogController watchController(BuildContext context) {
    return context.watch<RenamePointInTimeAlertDialogController>();
  }
}
