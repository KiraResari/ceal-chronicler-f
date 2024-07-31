import 'package:ceal_chronicler_f/characters/commands/update_first_appearance_command.dart';
import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;

  var oldFirstAppearance = PointInTimeId();
  var newFirstAppearance = PointInTimeId();

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should change first appearance",
        () {
      var character = Character(oldFirstAppearance);
      var command = UpdateFirstAppearanceCommand(character, newFirstAppearance);

      processor.process(command);

      expect(character.firstAppearance, equals(newFirstAppearance));
    },
  );

  test(
    "Undoing command should revert first appearance",
        () {
      var character = Character(oldFirstAppearance);
      var command = UpdateFirstAppearanceCommand(character, newFirstAppearance);

      processor.process(command);
      processor.undo();

      expect(character.firstAppearance, equals(oldFirstAppearance));
    },
  );

  test(
    "Redoing command should change first appearance again",
        () {
      var character = Character(oldFirstAppearance);
      var command = UpdateFirstAppearanceCommand(character, newFirstAppearance);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(character.firstAppearance, equals(newFirstAppearance));
    },
  );
}
