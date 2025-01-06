import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/utils/commands/attributes/create_attribute_command.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should create new attribute",
    () {
      var character = Character(PointInTimeId());
      var command = CreateAttributeCommand(character);

      processor.process(command);

      expect(character.attributes.length, equals(1));
    },
  );

  test(
    "Undoing command should remove created attribute",
        () {
      var character = Character(PointInTimeId());
      var command = CreateAttributeCommand(character);

      processor.process(command);
      processor.undo();

      expect(character.attributes.length, equals(0));
    },
  );

  test(
    "Redoing command should re-add created attribute",
        () {
      var character = Character(PointInTimeId());
      var command = CreateAttributeCommand(character);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(character.attributes.length, equals(1));
    },
  );
}
