import '../../characters/model/character_id.dart';
import '../templates/character_view_template.dart';
import 'change_main_view_command.dart';

class OpenCharacterViewCommand extends ChangeMainViewCommand {
  CharacterId id;

  OpenCharacterViewCommand(this.id) : super(CharacterViewTemplate(id));

  @override
  String toString() {
    return 'OpenCharacterViewCommand{Target: $id; Can execute: $isRedoPossible; Can undo: $isUndoPossible}';
  }
}
