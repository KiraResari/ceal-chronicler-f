import 'package:ceal_chronicler_f/characters/character_selection_model.dart';
import 'package:ceal_chronicler_f/characters/character_selection_view.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "AddCharacter should increase Character Count by one",
    () {
      addCharacterShouldIncreaseCharacterCountByOne();
    },
  );
}

addCharacterShouldIncreaseCharacterCountByOne() {
  initializeGetItContext();

  var model = CharacterSelectionModel();
  var initialCharacterCount = model.characters.length;

  model.addCharacter();

  var finalCharacterCount = model.characters.length;
  expect(finalCharacterCount, initialCharacterCount + 1);

  getIt.reset();
}
