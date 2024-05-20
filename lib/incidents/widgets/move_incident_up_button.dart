import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/move_incident_up_command.dart';
import '../model/incident.dart';
import 'incident_overview_controller.dart';

class MoveIncidentUpButton extends SmallCircularButton {
  final Incident incident;

  const MoveIncidentUpButton(this.incident, {super.key})
      : super(tooltip: "Move incident up", icon: Icons.arrow_upward);

  @override
  void onPressed(BuildContext context) {
    var commandProcessor = getIt.get<CommandProcessor>();
    var controller = context.read<IncidentOverviewController>();
    var command = MoveIncidentUpCommand(incident, controller.activePointInTime);
    commandProcessor.process(command);
  }

  @override
  bool isEnabled(BuildContext context) {
    var controller = context.watch<IncidentOverviewController>();
    return controller.canIncidentBeMovedUp(incident);
  }

  @override
  String? getDisabledReason(BuildContext context) =>
      "Incident can't be moved up";
}
