import 'package:ceal_chronicler_f/characters/character_selection_model.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => initializeGetItContext());
  tearDown(() => getIt.reset());
  test(
    "AddCharacter should increase Character Count by one",
    () {
      var model = CharacterSelectionModel();
      var initialCharacterCount = model.characters.length;

      model.addCharacter();

      var finalCharacterCount = model.characters.length;
      expect(finalCharacterCount, initialCharacterCount + 1);
    },
  );
  test(
    "AddCharacter twice should increase Character Count by two",
        () {
      var model = CharacterSelectionModel();
      var initialCharacterCount = model.characters.length;

      model.addCharacter();
      model.addCharacter();

      var finalCharacterCount = model.characters.length;
      expect(finalCharacterCount, initialCharacterCount + 2);
    },
  );
}