import 'package:ceal_chronicler_f/utils/validation/invalid_result.dart';
import 'package:ceal_chronicler_f/utils/validation/validation_result.dart';
import 'package:ceal_chronicler_f/utils/widgets/rename_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RenameDialog extends StatelessWidget {
  final String originalName;
  final String labelText;

  const RenameDialog({
    super.key,
    required this.originalName,
    this.labelText = "Rename",
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RenameDialogController(originalName),
      builder: (context, child) => buildAlertDialog(context),
    );
  }

  RenameDialogController readController(BuildContext context) {
    return context.read<RenameDialogController>();
  }

  RenameDialogController watchController(BuildContext context) {
    return context.watch<RenameDialogController>();
  }

  Widget buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(labelText),
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
    TextEditingController controller =
        readController(context).textEditingController;
    return TextField(
      controller: controller,
      decoration: const InputDecoration(labelText: "New Name"),
    );
  }

  Widget _buildConfirmButtonOrErrorText(BuildContext context) {
    var controller = watchController(context);
    String name = controller.textEditingController.text;
    ValidationResult nameValidationResult = controller.validateNewName(name);
    return nameValidationResult is InvalidResult
        ? _buildErrorText(nameValidationResult)
        : _buildConfirmButton(context);
  }

  Widget _buildErrorText(InvalidResult invalidResult) {
    return Text(invalidResult.reason);
  }

  Widget _buildConfirmButton(BuildContext context) {
    String name = watchController(context).textEditingController.text;
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
