import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../utils/widgets/buttons/ceal_text_button.dart';
import '../../view/commands/open_character_view_command.dart';
import '../../view/view_processor.dart';
import '../model/character.dart';

class CharacterButton extends CealTextButton {
  final viewProcessor = getIt.get<ViewProcessor>();

  final Character character;

  CharacterButton(this.character, {super.key});

  @override
  void onPressed(BuildContext context) {
    var command = OpenCharacterViewCommand(character.id);
    viewProcessor.process(command);
  }

  @override
  String get text {
    var keyFieldResolver = getIt.get<KeyFieldResolver>();
    return keyFieldResolver.getCurrentValue(character.name);
  }

  @override
  String? get tooltip {
    var keyFieldResolver = getIt.get<KeyFieldResolver>();
    String characterName = keyFieldResolver.getCurrentValue(character.name);
    return "View/Edit $characterName";
  }
}
