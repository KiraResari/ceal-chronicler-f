import 'package:flutter/material.dart';

import '../dialogs/select_dropdown_dialog.dart';
import 'dropdown_popup_button_controller.dart';
import 'small_circular_button.dart';

abstract class DropdownPopupButton<T> extends SmallCircularButton {
  final DropdownPopupButtonController<T> controller;
  final T? initialSelection;
  final String labelText;

  const DropdownPopupButton({
    required this.controller,
    required this.initialSelection,
    required this.labelText,
    required super.icon,
    super.key,
  });

  @override
  void onPressed(BuildContext context) async {
    T? selectedValue = await _showSelectionDialog(context);
    controller.onConfirm(selectedValue);
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
