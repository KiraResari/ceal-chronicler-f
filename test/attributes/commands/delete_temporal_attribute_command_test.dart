import 'package:ceal_chronicler_f/attributes/commands/delete_temporal_attribute_command.dart';
import 'package:ceal_chronicler_f/attributes/model/temporal_attribute.dart';
import 'package:ceal_chronicler_f/characters/model/character.dart';
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

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    resolver = KeyFieldResolver();
    getIt.registerSingleton<KeyFieldResolver>(resolver);
    processor = CommandProcessor();
  });

  test(
    "Processing command should delete temporal attribute",
    () {
      var character = Character(PointInTimeId());
      var attribute = TemporalAttribute();
      character.temporalAttributes.add(attribute);
      var command = DeleteTemporalAttributeCommand(character, attribute);

      processor.process(command);

      expect(character.temporalAttributes.length, equals(0));
    },
  );

  test(
    "Undoing command should restore deleted temporal attribute",
    () {
      var character = Character(PointInTimeId());
      var attribute = TemporalAttribute();
      character.temporalAttributes.add(attribute);
      var command = DeleteTemporalAttributeCommand(character, attribute);

      processor.process(command);
      processor.undo();

      expect(character.temporalAttributes, equals([attribute]));
    },
  );

  test(
    "Undoing command should restore deleted temporal attribute at correct index",
    () {
      var character = Character(PointInTimeId());
      var firstAttribute = TemporalAttribute();
      var secondAttribute = TemporalAttribute();
      var thirdAttribute = TemporalAttribute();
      character.temporalAttributes
          .addAll([firstAttribute, secondAttribute, thirdAttribute]);
      var command = DeleteTemporalAttributeCommand(character, secondAttribute);

      processor.process(command);
      processor.undo();

      expect(character.temporalAttributes,
          equals([firstAttribute, secondAttribute, thirdAttribute]));
    },
  );

  test(
    "Undoing command should restore deleted temporal attribute with correct name",
    () {
      var character = Character(PointInTimeId());
      var attribute = TemporalAttribute();
      attribute.value.addOrUpdateKeyAtTime(
          "Whatever", pointInTimeRepository.activePointInTime.id);
      character.temporalAttributes.add(attribute);
      var command = DeleteTemporalAttributeCommand(character, attribute);

      processor.process(command);
      processor.undo();

      var currentValue =
          resolver.getCurrentValue(character.temporalAttributes[0].value);
      expect(currentValue, equals("Whatever"));
    },
  );

  test(
    "Redoing command should re-delete temporal attribute",
    () {
      var character = Character(PointInTimeId());
      var attribute = TemporalAttribute();
      character.temporalAttributes.add(attribute);
      var command = DeleteTemporalAttributeCommand(character, attribute);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(character.temporalAttributes.length, equals(0));
    },
  );
}
