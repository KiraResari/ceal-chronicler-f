import 'package:ceal_chronicler_f/characters/character.dart';
import 'package:ceal_chronicler_f/characters/character_name.dart';

class TestCharacter extends Character {
  static const testName = "Test Character Name";
  static const testWeapon = "Test Character Weapon";
  static const testSpecies = "Test Character Species";

  TestCharacter()
      : super(name: testName, weapon: testWeapon, species: testSpecies);
}
