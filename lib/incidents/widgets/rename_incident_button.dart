import 'package:ceal_chronicler_f/incidents/commands/rename_incident_command.dart';
import 'package:ceal_chronicler_f/utils/widgets/rename_dialog.dart';
import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../model/incident.dart';

class RenameIncidentButton extends SmallCircularButton {
  static const String renameDialogLabel = "Rename Incident";

  final Incident incident;

  const RenameIncidentButton(this.incident, {super.key})
      : super(tooltip: "Rename incident", icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    String? newName = await _showRenamingDialog(context);
    if (newName != null) {
      var command = RenameIncidentCommand(incident, newName);
      var commandProcessor = getIt.get<CommandProcessor>();
      commandProcessor.process(command);
    }
  }

  Future<String?> _showRenamingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RenameDialog(
          originalName: incident.name,
          labelText: renameDialogLabel,
        );
      },
    );
  }
}
