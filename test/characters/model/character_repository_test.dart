import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CharacterRepository repository;
  setUp(() {
    repository = CharacterRepository();
  });

  test("Newly created repository should be empty", () {
    expect(repository.content.length, equals(0));
  });

  test("Adding new character should work", () {
    var character = Character(PointInTimeId());
    repository.add(character);

    expect(repository.content.length, equals(1));
  });

  test("Removing character should work", () {
    var character = Character(PointInTimeId());
    repository.add(character);
    var characterToBeRemoved = repository.content.first;

    repository.remove(characterToBeRemoved);

    expect(repository.content, isNot(contains(characterToBeRemoved)));
  });
}
