import 'package:ceal_chronicler_f/characters/character.dart';

class CharacterRepository {
  List<Character> _characters = [
    Character(
      name: "Sylvia",
      weapon: "Axe",
      species: "Nefilim",
    )
  ];

  List<Character> get characters {
    return _characters;
  }
}
