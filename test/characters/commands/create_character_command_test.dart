import 'package:ceal_chronicler_f/characters/commands/create_character_command.dart';
import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late CommandProcessor processor;
  late CharacterRepository repository;

  setUp(() {
    getIt.reset();
    repository = CharacterRepository();
    getIt.registerSingleton<CharacterRepository>(repository);
    getIt.registerSingleton<FileService>(FileServiceMockLite());
    processor = CommandProcessor();
  });

  test(
    "Processing command should add new character",
    () {
      int initialIncidentCount = repository.content.length;
      var command = CreateCharacterCommand(PointInTimeId());

      processor.process(command);

      expect(repository.content.length, equals(initialIncidentCount + 1));
    },
  );

  test(
    "Undoing command should remove new character",
    () {
      var command = CreateCharacterCommand(PointInTimeId());

      processor.process(command);
      Character createdCharacter = repository.content.first;
      processor.undo();

      expect(repository.content, isNot(contains(createdCharacter)));
    },
  );

  test(
    "Redoing command should re-add new character",
    () {
      var command = CreateCharacterCommand(PointInTimeId());

      processor.process(command);
      Character createdCharacter = repository.content.first;
      processor.undo();
      processor.redo();

      expect(repository.content, contains(createdCharacter));
    },
  );
}
