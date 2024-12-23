import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../validation/invalid_result.dart';
import '../../validation/validation_result.dart';
import 'select_key_dropdown_dialog_controller.dart';

class SelectKeyDropdownDialog<T> extends StatelessWidget {
  final T? initialSelection;
  final List<DropdownMenuEntry<T>> entries;
  final String? labelText;

  const SelectKeyDropdownDialog({
    super.key,
    required this.initialSelection,
    required this.entries,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          SelectKeyDropdownDialogController<T>(initialSelection),
      builder: (context, child) => buildAlertDialog(context),
    );
  }

  Widget buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(labelText ?? "Select"),
      content: _buildDropdown(context),
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

  Widget _buildDropdown(BuildContext context) {
    var controller = _watchController(context);

    return DropdownMenu<T>(
      initialSelection: controller.initialSelection,
      dropdownMenuEntries: entries,
      onSelected: (T? selection) => controller.onSelected(selection),
    );
  }

  Widget _buildConfirmButtonOrErrorText(BuildContext context) {
    ValidationResult nameValidationResult =
        _watchController(context).validateSelection;
    return nameValidationResult is InvalidResult
        ? _buildErrorText(nameValidationResult)
        : _buildConfirmButton(context);
  }

  Widget _buildErrorText(InvalidResult invalidResult) {
    return Text(invalidResult.reason);
  }

  Widget _buildConfirmButton(BuildContext context) {
    T? currentSelection =
        context.watch<SelectKeyDropdownDialogController<T>>().currentSelection;
    return TextButton(
      onPressed: () => Navigator.of(context).pop(currentSelection),
      child: const Text("✔️"),
    );
  }

  SelectKeyDropdownDialogController<T> _watchController(BuildContext context) {
    return context.watch<SelectKeyDropdownDialogController<T>>();
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
