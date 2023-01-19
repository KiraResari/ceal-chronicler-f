import 'package:ceal_chronicler_f/characters/species_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("SpeciesField can be json serialized and deserialized", () {
    var original = SpeciesField();

    String jsonString = original.toJsonString();
    var decoded = SpeciesField.fromJsonString(jsonString);

    expect(original, decoded);
  });
}