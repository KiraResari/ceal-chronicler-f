import 'package:ceal_chronicler_f/characters/character.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Two blank characters should not be equal", () {
    var firstCharacter = Character();
    var secondCharacter = Character();

    expect(firstCharacter, isNot(secondCharacter));
  });
}
