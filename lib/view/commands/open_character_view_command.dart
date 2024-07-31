import '../../characters/model/character.dart';
import '../templates/character_view_template.dart';
import 'change_main_view_command.dart';

class OpenCharacterViewCommand extends ChangeMainViewCommand {
  Character character;

  OpenCharacterViewCommand(this.character)
      : super(CharacterViewTemplate(character));

  @override
  String toString() {
    return 'OpenCharacterViewCommand{Target: $character; Can execute: $isRedoPossible; Can undo: $isUndoPossible}';
  }
}
