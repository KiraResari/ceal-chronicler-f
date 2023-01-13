import 'package:ceal_chronicler_f/characters/character.dart';
import 'package:ceal_chronicler_f/characters/character_id.dart';
import 'package:optional/optional_internal.dart';

class CharacterRepository {
  final Map<CharacterId, Character> _characters = {};

  List<Character> get characters {
    return _characters.values.toList();
  }

  void add(Character character) {
    _characters[character.id] = character.copy();
  }

  Optional<Character> get(CharacterId id) {
    var character = _characters[id];
    if (character != null){
      return Optional.of(character.copy());
    }
    return const Optional.empty();
  }
}
