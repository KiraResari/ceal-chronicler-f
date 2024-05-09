import 'package:ceal_chronicler_f/characters/commands/create_character_command.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/utils/widgets/small_circular_button.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';

class AddCharacterButton extends SmallCircularButton {
  final PointInTimeRepository pointInTimeRepository;
  final CommandProcessor commandProcessor;

  AddCharacterButton({super.key})
      : pointInTimeRepository = getIt.get<PointInTimeRepository>(),
        commandProcessor = getIt.get<CommandProcessor>(),
        super(tooltip: "Add new incident", icon: Icons.add);

  @override
  void onPressed(BuildContext context) {
    var activePointInTime = pointInTimeRepository.activePointInTime;
    var command = CreateCharacterCommand(activePointInTime.id);
    commandProcessor.process(command);
  }
}
