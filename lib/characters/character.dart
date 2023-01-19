import '../fields/display_field.dart';
import '../items/weapon_field.dart';
import '../utils/json_serializable.dart';
import 'character_id.dart';
import 'species_field.dart';

import 'character_name_field.dart';

class Character extends JsonSerializable {

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
        nameField = CharacterNameField(name),
        weaponField = WeaponField(weapon),
        speciesField = SpeciesField(species);

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

  void copyValuesFrom(Character character) {
    name = character.name;
    weapon = character.weapon;
    species = character.species;
  }
}
