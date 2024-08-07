import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/incidents/commands/create_incident_command.dart';
import 'package:ceal_chronicler_f/utils/widgets/buttons/small_circular_button.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';

class AddIncidentButton extends SmallCircularButton {
  final PointInTimeRepository pointInTimeRepository =
      getIt.get<PointInTimeRepository>();
  final CommandProcessor commandProcessor = getIt.get<CommandProcessor>();

  AddIncidentButton({super.key}) : super(icon: Icons.add);

  @override
  void onPressed(BuildContext context) {
    var activePointInTime = pointInTimeRepository.activePointInTime;
    var command = CreateIncidentCommand(activePointInTime);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Add new incident";
}
