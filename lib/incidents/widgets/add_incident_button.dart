import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/incidents/commands/create_incident_command.dart';
import 'package:ceal_chronicler_f/utils/widgets/small_circular_button.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';

class AddIncidentButton extends SmallCircularButton {
  const AddIncidentButton({super.key})
      : super(tooltip: "Add new incident", icon: Icons.add);

  @override
  void onPressed(BuildContext context) {
    var pointInTimeRepository = getIt.get<PointInTimeRepository>();
    var commandProcessor = getIt.get<CommandProcessor>();
    var activePointInTime = pointInTimeRepository.activePointInTime;
    var command = CreateIncidentCommand(activePointInTime);
    commandProcessor.process(command);
  }
}
