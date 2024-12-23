import 'package:ceal_chronicler_f/key_fields/widgets/select_key_button_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import '../../utils/widgets/dialogs/select_key_dropdown_dialog.dart';
import '../key_field.dart';

class SelectKeyButton<T> extends SmallCircularButton {
  final KeyField<T> keyField;
  final List<DropdownMenuEntry<T>> entries;
  final String? labelText;
  final SelectKeyButtonController<T> controller;

  SelectKeyButton({
    super.key,
    required this.keyField,
    required this.entries,
    this.labelText,
  })  : controller = SelectKeyButtonController(keyField),
        super(icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    T? selectedValue = await _showSelectionDialog(context);
    controller.updateKey(selectedValue);
  }

  Future<T?> _showSelectionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectKeyDropdownDialog<T>(
          initialSelection: controller.currentValue,
          entries: entries,
          labelText: labelText,
        );
      },
    );
  }
}
