import '../../utils/widgets/temporal_entity_button.dart';
import '../../view/commands/open_character_view_command.dart';
import '../model/character.dart';

class CharacterButton extends TemporalEntityButton<Character> {
  CharacterButton(Character character, {super.key}) : super(character);

  @override
  OpenCharacterViewCommand createOpenViewCommand(Character entity) {
    return OpenCharacterViewCommand(entity);
  }

  @override
  String get entityTypeName => "Character";
}
