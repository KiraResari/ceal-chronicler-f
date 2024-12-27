import 'package:flutter/material.dart';

import '../dialogs/select_dropdown_dialog.dart';
import 'edit_dropdown_button_controller.dart';
import 'small_circular_button.dart';

abstract class EditDropdownButton<T> extends SmallCircularButton {
  final EditDropdownButtonController<T> controller;
  final T? initialSelection;
  final String labelText;

  const EditDropdownButton({
    required this.controller,
    required this.initialSelection,
    required this.labelText,
    super.key,
  }) : super(icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    T? selectedValue = await _showSelectionDialog(context);
    controller.update(selectedValue);
  }

  Future<T?> _showSelectionDialog(BuildContext context) {
    List<DropdownMenuEntry<T>> validEntries = controller.validMenuEntries;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectDropdownDialog<T>(
          initialSelection: initialSelection,
          entries: validEntries,
          labelText: labelText,
        );
      },
    );
  }
}
