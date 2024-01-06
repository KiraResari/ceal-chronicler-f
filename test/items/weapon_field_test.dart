import 'package:ceal_chronicler_f/items/weapon_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("WeaponField can be json serialized and deserialized", () {
    var original = WeaponField();

    String jsonString = original.toJsonString();
    var decoded = WeaponField.fromJsonString(jsonString);

    expect(original, decoded);
  });
}