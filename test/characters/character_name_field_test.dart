import 'package:ceal_chronicler_f/characters/character_name_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("CharacterNameField can be json serialized and deserialized", () {
    var original = CharacterNameField();

    String jsonString = original.toJsonString();
    var decoded = CharacterNameField.fromJsonString(jsonString);

    expect(original, decoded);
  });
}