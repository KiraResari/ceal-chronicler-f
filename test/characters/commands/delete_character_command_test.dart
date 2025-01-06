import 'package:ceal_chronicler_f/characters/commands/delete_character_command.dart';
import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late KeyFieldResolver resolver;
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    resolver = KeyFieldResolver();
    getIt.registerSingleton<KeyFieldResolver>(resolver);
    characterRepository = CharacterRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    processor = CommandProcessor();
  });

  test(
    "Processing command should delete character",
    () {
      var character = Character(PointInTimeId());
      characterRepository.add(character);
      var command = DeleteCharacterCommand(character);

      processor.process(command);

      expect(characterRepository.content, isNot(contains(character)));
    },
  );

  test(
    "Undoing command should restore deleted character",
    () {
      var character = Character(PointInTimeId());
      characterRepository.add(character);
      var command = DeleteCharacterCommand(character);

      processor.process(command);
      processor.undo();

      expect(characterRepository.content, contains(character));
    },
  );

  test(
    "Undoing command should restore deleted character with correct name",
    () {
      var character = Character(PointInTimeId());
      character.name.addOrUpdateKeyAtTime(
          "Sylvia", pointInTimeRepository.activePointInTime.id);
      characterRepository.add(character);
      var command = DeleteCharacterCommand(character);

      processor.process(command);
      processor.undo();

      var currentValue =
          resolver.getCurrentValue(characterRepository.content[0].name);
      expect(currentValue, equals("Sylvia"));
    },
  );

  test(
    "Redoing command should re-delete character",
    () {
      var character = Character(PointInTimeId());
      characterRepository.add(character);
      var command = DeleteCharacterCommand(character);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(characterRepository.content, isNot(contains(character)));
    },
  );
}
