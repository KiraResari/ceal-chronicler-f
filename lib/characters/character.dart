import '../fields/display_field.dart';
import '../items/weapon.dart';
import 'species.dart';

import 'character_name.dart';

class Character {
  static const nameFieldName = "Name: ";
  static const weaponFieldName = "Weapon: ";
  static const speciesFieldName = "Species: ";
  static const defaultName = "Unnamed Character";
  static const defaultWeapon = "No weapon";
  static const defaultSpecies = "Unknown species";

  CharacterName name;
  Weapon weapon;
  Species species;

  List<DisplayField> get displayFields {
    return [name, weapon, species];
  }

  Character(
      {name = defaultName, weapon = defaultName, species = defaultSpecies})
      : name = CharacterName(nameFieldName, name),
        weapon = Weapon(weaponFieldName, weapon),
        species = Species(speciesFieldName, species);

  String getDisplayValue() {
    return name.getDisplayValue();
  }
}
