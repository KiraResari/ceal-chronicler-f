import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/delete_character_command.dart';
import '../model/character.dart';

class DeleteCharacterButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();

  final Character character;

  DeleteCharacterButton(this.character, {super.key}) : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var command = DeleteCharacterCommand(character);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Delete character";
}
