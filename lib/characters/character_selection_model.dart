import '../get_it_context.dart';
import 'character.dart';
import 'character_repository.dart';

class CharacterSelectionModel {
  final _characterRepository = getIt<CharacterRepository>();

  List<Character> get characters {
    return _characterRepository.characters;
  }

  void addCharacter() {
    var character = Character();
    _characterRepository.add(character);
  }
}
