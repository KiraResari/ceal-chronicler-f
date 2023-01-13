import 'package:ceal_chronicler_f/characters/character.dart';
import 'package:ceal_chronicler_f/characters/character_id.dart';
import 'package:ceal_chronicler_f/characters/character_repository.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optional/optional_internal.dart';

import 'test_character.dart';

void main() {
  CharacterRepository repository;
  setUp(() => initializeGetItContext());
  tearDown(() => getIt.reset());
  test(
    "get should return added character",
    () {
      var character = TestCharacter();
      repository = getIt<CharacterRepository>();
      repository.add(character);

      Optional<Character> returnedCharacterOption =
          repository.get(character.id);

      expect(returnedCharacterOption.isPresent, true,
          reason: "Character was not found");
      var returnedCharacter = returnedCharacterOption.value;
      expect(returnedCharacter, character,
          reason: "Returned character did not equal original character");
    },
  );
  test(
    "get should return empty Optional if character was not added",
    () {
      var characterId = CharacterId();
      repository = getIt<CharacterRepository>();

      Optional<Character> returnedCharacterOption = repository.get(characterId);

      expect(returnedCharacterOption.isPresent, false);
    },
  );
  test(
    "Changing character after putting it into repository should not change it inside repository",
    () {
      var character = TestCharacter();
      repository = getIt<CharacterRepository>();
      repository.add(character);

      character.name = "Changed Name";
      Optional<Character> returnedCharacterOption =
          repository.get(character.id);

      expect(returnedCharacterOption.value.name, TestCharacter.testName);
    },
  );
}
