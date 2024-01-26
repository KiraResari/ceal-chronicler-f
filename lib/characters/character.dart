import '../fields/display_field.dart';
import '../items/weapon_field.dart';
import '../io/json_serializable_old.dart';
import 'character_id.dart';
import 'species_field.dart';

import 'character_name_field.dart';

class Character extends JsonSerializableOld {

  static const _idFieldName = "id";
  static const _nameFieldName = "nameField";
  static const _weaponFieldName = "weaponField";
  static const _speciesFieldName = "speciesField";

  late CharacterId id;
  late CharacterNameField nameField;
  late WeaponField weaponField;
  late SpeciesField speciesField;

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

  Character.fromJsonString(String jsonString)
      : super.fromJsonString(jsonString);

  Character.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);

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
          (id == other.id) &&
          (name == other.name) &&
          (weapon == other.weapon) &&
          (species == other.species);

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

  @override
  decodeJson(Map<String, dynamic> jsonMap) {
    id = CharacterId.fromJson(jsonMap[_idFieldName]);
    nameField = CharacterNameField.fromJson(jsonMap[_nameFieldName]);
    speciesField = SpeciesField.fromJson(jsonMap[_speciesFieldName]);
    weaponField = WeaponField.fromJson(jsonMap[_weaponFieldName]);
  }

  @override
  Map<String, dynamic> toJson() => {
    _idFieldName: id,
    _nameFieldName: nameField,
    _speciesFieldName: speciesField,
    _weaponFieldName: weaponField,
  };
}
