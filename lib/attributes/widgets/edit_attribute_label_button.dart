import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../../utils/widgets/dialogs/rename_dialog.dart';
import '../commands/edit_attribute_label_command.dart';
import '../model/attribute.dart';

class EditAttributeLabelButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();
  static const String dialogLabel = "Edit attribute label";

  final Attribute attribute;

  EditAttributeLabelButton(this.attribute, {super.key})
      : super(icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    String? newName = await _showRenamingDialog(context);
    if (newName != null) {
      var command = EditAttributeLabelCommand(attribute, newName);
      commandProcessor.process(command);
    }
  }

  Future<String?> _showRenamingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RenameDialog(
          originalName: attribute.label,
          labelText: dialogLabel,
        );
      },
    );
  }

  @override
  String? get tooltip => dialogLabel;
}
