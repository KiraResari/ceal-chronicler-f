import 'package:ceal_chronicler_f/characters/commands/create_character_command.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/utils/widgets/buttons/small_circular_button.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';

class AddCharacterButton extends SmallCircularButton {
  final PointInTimeRepository pointInTimeRepository =
      getIt.get<PointInTimeRepository>();
  final CommandProcessor commandProcessor = getIt.get<CommandProcessor>();

  AddCharacterButton({super.key}) : super(icon: Icons.add);

  @override
  void onPressed(BuildContext context) {
    var activePointInTime = pointInTimeRepository.activePointInTime;
    var command = CreateCharacterCommand(activePointInTime.id);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Add new character";
}
