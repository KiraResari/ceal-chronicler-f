import '../../key_fields/key_field_resolver.dart';

import '../../characters/model/character.dart';
import '../../get_it_context.dart';
import '../templates/character_view_template.dart';
import 'change_main_view_command.dart';

class OpenCharacterViewCommand extends ChangeMainViewCommand {
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  Character character;

  OpenCharacterViewCommand(this.character)
      : super(CharacterViewTemplate(character));

  @override
  String toString() {
    return 'OpenCharacterViewCommand{Target: $character; Can execute: $isRedoPossible; Can undo: $isUndoPossible}';
  }

  String get getCharacterNameOrUnknown {
    String? name = _keyFieldResolver.getCurrentValue(character.name);
    return name ?? "unknown";
  }
}
