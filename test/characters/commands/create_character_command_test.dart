import 'package:ceal_chronicler_f/characters/commands/create_character_command.dart';
import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late CharacterRepository repository;

  setUp(() {
    getIt.reset();
    repository = CharacterRepository();
    getIt.registerSingleton<CharacterRepository>(repository);
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
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
