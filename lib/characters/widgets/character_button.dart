import 'package:ceal_chronicler_f/view/commands/open_character_view_command.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../model/character.dart';

class CharacterButton extends StatelessWidget {
  final Character character;

  const CharacterButton(this.character, {super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onPressed(),
      child: Text(character.name),
    );
  }

  void _onPressed() {
    var viewProcessor = getIt.get<ViewProcessor>();
    var command = OpenCharacterViewCommand(character.id);
    viewProcessor.process(command);
  }
}
