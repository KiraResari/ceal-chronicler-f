import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/delete_incident_command.dart';
import '../model/incident.dart';

class DeleteIncidentButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();

  final Incident incident;

  DeleteIncidentButton(this.incident, {super.key}) : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var command = DeleteIncidentCommand(incident);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Delete incident";
}
