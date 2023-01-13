import '../fields/display_field.dart';
import '../items/weapon.dart';
import 'character_id.dart';
import 'species.dart';

import 'character_name.dart';

class Character {

  CharacterId id;
  CharacterNameField nameField;
  WeaponField weaponField;
  SpeciesField speciesField;

  String get name => nameField.value;

  set name(String value) => nameField.value = value;

  String get weapon => weaponField.value;

  set weapon(String value) => weaponField.value = value;

  String get species => speciesField.value;

  set species(String value) => speciesField.value = value;

  List<DisplayField> get displayFields {
    return [nameField, weaponField, speciesField];
  }

  Character({
    id,
    name,
    weapon,
    species,
  })  : id = id ?? CharacterId(),
        nameField = CharacterNameField(),
        weaponField = WeaponField(),
        speciesField = SpeciesField();

  String getDisplayValue() {
    return nameField.getDisplayValue();
  }

  Character copy() {
    return Character(
      id: id.copy(),
      name: name,
      weapon: weapon,
      species: species,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          isIdEqual(other) &&
          isNameEqual(other) &&
          isWeaponEqual(other) &&
          isSpeciesEqual(other);

  bool isSpeciesEqual(Character other) {
    var isEqual = (species == other.species);
    return isEqual;
  }

  bool isWeaponEqual(Character other) {
    var isEqual = (weapon == other.weapon);
    return isEqual;
  }

  bool isNameEqual(Character other) {
    var isEqual = (name == other.name);
    return isEqual;
  }

  bool isIdEqual(Character other) {
    var isEqual = (id == other.id);
    return isEqual;
  }

  @override
  int get hashCode =>
      id.hashCode + name.hashCode + weapon.hashCode + species.hashCode;

  @override
  String toString(){
    return "[id: $id, name: $name, species: $species, weapon: $weapon]";
  }
}
