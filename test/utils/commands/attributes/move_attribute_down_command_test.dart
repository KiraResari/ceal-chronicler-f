import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/utils/commands/attributes/move_attribute_down_command.dart';
import 'package:ceal_chronicler_f/utils/model/attribute.dart';
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
    "Processing command should move attribute down in list",
    () {
      var character = Character(PointInTimeId());
      var firstAttribute = Attribute();
      var secondAttribute = Attribute();
      var thirdAttribute = Attribute();
      character.attributes
          .addAll([firstAttribute, secondAttribute, thirdAttribute]);
      var command = MoveAttributeDownCommand(character, secondAttribute);

      processor.process(command);

      expect(character.attributes,
          equals([firstAttribute, thirdAttribute, secondAttribute]));
    },
  );

  test(
    "Undoing command should restore original attribute order",
    () {
      var character = Character(PointInTimeId());
      var firstAttribute = Attribute();
      var secondAttribute = Attribute();
      var thirdAttribute = Attribute();
      character.attributes
          .addAll([firstAttribute, secondAttribute, thirdAttribute]);
      var command = MoveAttributeDownCommand(character, secondAttribute);

      processor.process(command);
      processor.undo();

      expect(character.attributes,
          equals([firstAttribute, secondAttribute, thirdAttribute]));
    },
  );

  test(
    "Redoing command should move attribute down in list again",
    () {
      var character = Character(PointInTimeId());
      var firstAttribute = Attribute();
      var secondAttribute = Attribute();
      var thirdAttribute = Attribute();
      character.attributes
          .addAll([firstAttribute, secondAttribute, thirdAttribute]);
      var command = MoveAttributeDownCommand(character, secondAttribute);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(character.attributes,
          equals([firstAttribute, thirdAttribute, secondAttribute]));
    },
  );
}
