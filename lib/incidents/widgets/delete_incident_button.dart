import 'package:ceal_chronicler_f/incidents/commands/delete_incident_command.dart';
import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../model/incident.dart';

class DeleteIncidentButton extends SmallCircularButton {
  final Incident incident;

  const DeleteIncidentButton(this.incident, {super.key})
      : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var commandProcessor = getIt.get<CommandProcessor>();
    var command = DeleteIncidentCommand(incident);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Delete incident";
}