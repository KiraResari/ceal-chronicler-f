import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import '../../utils/widgets/dialogs/select_dropdown_dialog.dart';
import 'key_field_controller.dart';

class SelectKeyButton<T> extends SmallCircularButton {
  final List<DropdownMenuEntry<T>> entries;
  final String? labelText;
  final KeyFieldController<T> controller;

  const SelectKeyButton({
    super.key,
    required this.controller,
    required this.entries,
    this.labelText,
  }) : super(icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    T? selectedValue = await _showSelectionDialog(context);
    controller.updateKey(selectedValue);
  }

  Future<T?> _showSelectionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectDropdownDialog<T>(
          initialSelection: controller.currentValue,
          entries: entries,
          labelText: labelText,
        );
      },
    );
  }
}
