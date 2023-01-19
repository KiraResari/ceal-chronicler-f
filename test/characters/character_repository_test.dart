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
      repository = getIt<CharacterRepository>();
      TestCharacter character = addTestCharacterToRepository(repository);

      Character returnedCharacter =
          getCharacterFromRepository(repository, character.id);

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
      repository = getIt<CharacterRepository>();
      TestCharacter character = addTestCharacterToRepository(repository);

      character.name = "Changed Name";
      Character returnedCharacter =
          getCharacterFromRepository(repository, character.id);

      expect(returnedCharacter.name, TestCharacter.testName);
    },
  );

  test(
    "Changing character after getting it out of repository should not change it inside repository",
    () {
      repository = getIt<CharacterRepository>();
      TestCharacter character = addTestCharacterToRepository(repository);

      Character returnedCharacter =
          getCharacterFromRepository(repository, character.id);
      returnedCharacter.name = "Changed Name";

      Character returnedAgainCharacter =
          getCharacterFromRepository(repository, character.id);
      expect(returnedAgainCharacter.name, TestCharacter.testName);
    },
  );

  test(
    "Changing character after getting it out of repository via list should not change it inside repository",
    () {
      repository = getIt<CharacterRepository>();
      addTestCharacterToRepository(repository);

      List<Character> characters = repository.characters;
      Character firstCharacter = characters.first;
      firstCharacter.name = "Changed Name";

      Character characterFromRepository =
          getCharacterFromRepository(repository, firstCharacter.id);
      expect(characterFromRepository.name, TestCharacter.testName);
    },
  );

  test(
    "Changing and saving character should change it inside repository",
    () {
      const changedName = "Changed Name";
      repository = getIt<CharacterRepository>();
      TestCharacter character = addTestCharacterToRepository(repository);

      Character returnedCharacter =
          getCharacterFromRepository(repository, character.id);
      returnedCharacter.name = changedName;
      repository.addOrUpdate(returnedCharacter);

      Character returnedAgainCharacter =
          getCharacterFromRepository(repository, character.id);
      expect(returnedAgainCharacter.name, changedName);
    },
  );

  test("CharacterRepository can be json serialized and deserialized", () {
    var original = CharacterRepository();
    original.addOrUpdate(Character(name: "First Character"));
    original.addOrUpdate(Character(name: "Second Character"));

    String jsonString = original.toJsonString();
    var decoded = CharacterRepository.fromJsonString(jsonString);

    expect(original, decoded);
  });

  test("Exporting CharacterRepository to file should work", () {
    var repository = CharacterRepository();
    addTestCharacterToRepository(repository);

    repository.exportToFile();
  });
  
  test("Exported and then imported CharacterRepository should be equal", () {
    var firstRepository = CharacterRepository();
    addTestCharacterToRepository(firstRepository);

    var futureFile = firstRepository.exportToFile();
    expect(futureFile, completes);
    var secondRepository = CharacterRepository();
    var futureRepository = secondRepository.importFromFile();

    expect(futureRepository, completion(firstRepository));
  });
}

Character getCharacterFromRepository(
    CharacterRepository repository, CharacterId id) {
  Optional<Character> returnedCharacterOption = repository.get(id);

  expect(returnedCharacterOption.isPresent, true,
      reason: "Character was not found");
  return returnedCharacterOption.value;
}

TestCharacter addTestCharacterToRepository(CharacterRepository repository) {
  var character = TestCharacter();
  repository.addOrUpdate(character);
  return character;
}
