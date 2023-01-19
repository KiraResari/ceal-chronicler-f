import 'package:ceal_chronicler_f/characters/character.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Two blank characters should not be equal", () {
    var firstCharacter = Character();
    var secondCharacter = Character();

    expect(firstCharacter, isNot(secondCharacter));
  });

  test("Character should take name from constructor", () {
    const characterName = "Some Name";

    var character = Character(name: characterName);

    expect(character.name, characterName);
  });
  test("Character can be json serialized and deserialized", () {
    var original = Character();

    String jsonString = original.toJsonString();
    var decoded = Character.fromJsonString(jsonString);

    expect(original, decoded);
  });
}
