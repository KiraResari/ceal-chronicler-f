import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Character to JSON and back should return equal object",
    () {
      var original = Character();

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded, equals(original));
    },
  );
}
