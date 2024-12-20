import 'package:ceal_chronicler_f/utils/commands/delete_last_appearance_command.dart';
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

  var oldLastAppearance = PointInTimeId();

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should delete last appearance",
    () {
      var character = Character(PointInTimeId());
      character.lastAppearance = oldLastAppearance;
      var command = DeleteLastAppearanceCommand(character);

      processor.process(command);

      expect(character.lastAppearance, isNull);
    },
  );

  test(
    "Undoing command should revert last appearance",
    () {
      var character = Character(PointInTimeId());
      character.lastAppearance = oldLastAppearance;
      var command = DeleteLastAppearanceCommand(character);

      processor.process(command);
      processor.undo();

      expect(character.lastAppearance, equals(oldLastAppearance));
    },
  );

  test(
    "Redoing command should change last appearance again",
    () {
      var character = Character(PointInTimeId());
      character.lastAppearance = oldLastAppearance;
      var command = DeleteLastAppearanceCommand(character);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(character.lastAppearance, isNull);
    },
  );
}
