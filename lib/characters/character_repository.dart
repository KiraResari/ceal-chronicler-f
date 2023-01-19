import 'package:ceal_chronicler_f/characters/character.dart';
import 'package:ceal_chronicler_f/characters/character_id.dart';
import 'package:ceal_chronicler_f/persistence/file_reader_writer.dart';
import 'package:ceal_chronicler_f/persistence/json_serializable.dart';
import 'package:flutter/foundation.dart';
import 'package:optional/optional_internal.dart';

class CharacterRepository extends JsonSerializable {
  static const fileName = "ceal.characters.json";
  static const _charactersFieldName = "characters";

  final Map<CharacterId, Character> _characters = {};
  final _fileReaderWriter = FileReaderWriter(fileName);

  List<Character> get characters {
    return _characters.values.map((character) => character.copy()).toList();
  }

  CharacterRepository();

  CharacterRepository.fromJsonString(String jsonString)
      : super.fromJsonString(jsonString);

  CharacterRepository.fromJson(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap);

  void addOrUpdate(Character character) {
    _characters[character.id] = character.copy();
  }

  Optional<Character> get(CharacterId id) {
    var character = _characters[id];
    if (character != null) {
      return Optional.of(character.copy());
    }
    return const Optional.empty();
  }

  @override
  decodeJson(Map<String, dynamic> jsonMap) {
    var charactersJson = jsonMap[_charactersFieldName];
    for (var characterJsonMap in charactersJson) {
      var character = Character.fromJson(characterJsonMap);
      addOrUpdate(character);
    }
  }

  @override
  Map<String, dynamic> toJson() =>
      {_charactersFieldName: _characters.values.toList()};

  @override
  String toString() {
    return "Character Repository$_characters";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterRepository && mapEquals(_characters, other._characters);

  @override
  int get hashCode => _characters.hashCode;
}
