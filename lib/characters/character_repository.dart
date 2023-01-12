import 'package:ceal_chronicler_f/characters/character.dart';

class CharacterRepository {
  List<Character> _characters = [
    Character(
      name: "Sylvia Zerin",
      weapon: "Axe",
      species: "Nefilim",
    ),
    Character(
      name: "Idra Kegis",
      weapon: "Claws",
      species: "Dragon",
    )
  ];

  List<Character> get characters {
    return _characters;
  }
}
