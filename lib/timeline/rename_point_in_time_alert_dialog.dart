import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/rename_point_in_time_alert_dialog_controller.dart';
import 'package:ceal_chronicler_f/utils/validation/invalid_result.dart';
import 'package:ceal_chronicler_f/utils/validation/validation_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RenamePointInTimeAlertDialog extends StatelessWidget {
  final PointInTime point;

  const RenamePointInTimeAlertDialog({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RenamePointInTimeAlertDialogController(point.name),
      builder: (context, child) => _buildAlertDialog(context),
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename point in time"),
      content: _buildTextField(context),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildConfirmButtonOrErrorText(context),
            _buildCancelButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    TextEditingController controller = context
        .read<RenamePointInTimeAlertDialogController>()
        .textEditingController;
    return TextField(
      controller: controller,
      decoration: const InputDecoration(labelText: "New Name"),
    );
  }

  Widget _buildConfirmButtonOrErrorText(BuildContext context) {
    RenamePointInTimeAlertDialogController controller =
        context.read<RenamePointInTimeAlertDialogController>();
    String name = context
        .watch<RenamePointInTimeAlertDialogController>()
        .textEditingController
        .text;
    ValidationResult nameValidationResult = controller.validateNewName(name);
    return nameValidationResult is InvalidResult
        ? _buildErrorText(nameValidationResult)
        : _buildConfirmButton(context);
  }

  Widget _buildErrorText(InvalidResult invalidResult) {
    return Text(invalidResult.reason);
  }

  Widget _buildConfirmButton(BuildContext context) {
    String name = context
        .watch<RenamePointInTimeAlertDialogController>()
        .textEditingController
        .text;
    return TextButton(
      onPressed: () => Navigator.of(context).pop(name),
      child: const Text("✔️"),
    );
  }

  TextButton _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("❌"),
    );
  }
}
