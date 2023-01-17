import 'package:ceal_chronicler_f/characters/character_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("CharacterId can be json serialized and deserialized", () {
    var originalId = CharacterId();

    String jsonString = originalId.toJsonString();
    var decodedId = CharacterId.fromJsonString(jsonString);

    expect(originalId, decodedId);
  });
  test("Two newly created CharacterIDs should not be equal", (){
    var firstId = CharacterId();
    var secondId = CharacterId();

    expect(firstId, isNot(secondId));
  });
  test("Copied CharacterId should be equal to original", (){
    var original  = CharacterId();

    var copy = original.copy();

    expect(original, copy);
  });
  test("Copied CharacterId should not be identical to original", (){
    var original  = CharacterId();

    var copy = original.copy();

    expect(identical(original, copy), false);
  });
}