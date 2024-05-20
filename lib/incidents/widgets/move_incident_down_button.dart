import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/move_incident_down_command.dart';
import '../model/incident.dart';
import 'incident_overview_controller.dart';

class MoveIncidentDownButton extends SmallCircularButton {
  final Incident incident;

  const MoveIncidentDownButton(this.incident, {super.key})
      : super(tooltip: "Move incident down", icon: Icons.arrow_downward);

  @override
  void onPressed(BuildContext context) {
    var commandProcessor = getIt.get<CommandProcessor>();
    var controller = context.read<IncidentOverviewController>();
    var command =
        MoveIncidentDownCommand(incident, controller.activePointInTime);
    commandProcessor.process(command);
  }

  @override
  bool isEnabled(BuildContext context) {
    var controller = context.watch<IncidentOverviewController>();
    return controller.canIncidentBeMovedDown(incident);
  }

  @override
  String? getDisabledReason(BuildContext context) =>
      "Incident can't be moved down";
}
