import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../utils/widgets/buttons/ceal_text_button.dart';
import '../../view/commands/open_character_view_command.dart';
import '../../view/view_processor.dart';
import '../model/character.dart';

class CharacterButton extends CealTextButton {
  final viewProcessor = getIt.get<ViewProcessor>();
  final keyFieldResolver = getIt.get<KeyFieldResolver>();

  final Character character;

  CharacterButton(this.character, {super.key});

  @override
  void onPressed(BuildContext context) {
    var command = OpenCharacterViewCommand(character);
    viewProcessor.process(command);
  }

  @override
  String get text {
    return keyFieldResolver.getCurrentValue(character.name) ?? "";
  }

  @override
  String? get tooltip {
    return "View/Edit $text";
  }
}
