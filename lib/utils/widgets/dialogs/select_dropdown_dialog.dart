import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../validation/invalid_result.dart';
import '../../validation/validation_result.dart';
import 'select_dropdown_dialog_controller.dart';

class SelectDropdownDialog<T> extends StatelessWidget {
  final T? initialSelection;
  final List<DropdownMenuEntry<T>> entries;
  final String? labelText;

  const SelectDropdownDialog({
    super.key,
    required this.initialSelection,
    required this.entries,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          SelectDropdownDialogController<T>(initialSelection),
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

    if(entries.isEmpty){
      return const Text("There are no valid entries");
    }

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
        context.watch<SelectDropdownDialogController<T>>().currentSelection;
    return TextButton(
      onPressed: () => Navigator.of(context).pop(currentSelection),
      child: const Text("✔️"),
    );
  }

  SelectDropdownDialogController<T> _watchController(BuildContext context) {
    return context.watch<SelectDropdownDialogController<T>>();
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
