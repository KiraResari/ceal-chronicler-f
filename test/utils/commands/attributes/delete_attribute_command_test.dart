import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/utils/commands/attributes/delete_attribute_command.dart';
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
    "Processing command should delete attribute",
    () {
      var character = Character(PointInTimeId());
      var attribute = Attribute();
      character.attributes.add(attribute);
      var command = DeleteAttributeCommand(character, attribute);

      processor.process(command);

      expect(character.attributes.length, equals(0));
    },
  );

  test(
    "Undoing command should restore deleted attribute",
    () {
      var character = Character(PointInTimeId());
      var attribute = Attribute();
      character.attributes.add(attribute);
      var command = DeleteAttributeCommand(character, attribute);

      processor.process(command);
      processor.undo();

      expect(character.attributes, equals([attribute]));
    },
  );

  test(
    "Undoing command should restore deleted attribute at correct index",
    () {
      var character = Character(PointInTimeId());
      var firstAttribute = Attribute();
      var secondAttribute = Attribute();
      var thirdAttribute = Attribute();
      character.attributes
          .addAll([firstAttribute, secondAttribute, thirdAttribute]);
      var command = DeleteAttributeCommand(character, secondAttribute);

      processor.process(command);
      processor.undo();

      expect(character.attributes,
          equals([firstAttribute, secondAttribute, thirdAttribute]));
    },
  );

  test(
    "Undoing command should restore deleted with correct name",
        () {
      var character = Character(PointInTimeId());
      var attribute = Attribute();
      attribute.name = "Whatever";
      character.attributes.add(attribute);
      var command = DeleteAttributeCommand(character, attribute);

      processor.process(command);
      processor.undo();

      expect(character.attributes[0].name, equals("Whatever"));
    },
  );

  test(
    "Redoing command should re-delete attribute",
        () {
      var character = Character(PointInTimeId());
      var attribute = Attribute();
      character.attributes.add(attribute);
      var command = DeleteAttributeCommand(character, attribute);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(character.attributes.length, equals(0));
    },
  );
}
