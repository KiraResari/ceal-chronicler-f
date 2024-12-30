import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/commands/add_or_update_key_command.dart';
import 'package:ceal_chronicler_f/key_fields/string_key_field.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test("Processing command should add key if it doesn't exist", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    var value = "Test Value";
    var command = AddOrUpdateKeyCommand(keyField, pointInTimeId, value);

    processor.process(command);

    expect(keyField.keys[pointInTimeId], equals(value));
  });

  test("Processing command should update key if it already exists", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    keyField.addOrUpdateKeyAtTime("Original Value", pointInTimeId);
    var value = "Test Value";
    var command = AddOrUpdateKeyCommand(keyField, pointInTimeId, value);

    processor.process(command);

    expect(keyField.keys[pointInTimeId], equals(value));
    expect(keyField.keys.length, equals(1));
  });

  test("Undoing command should remove added key", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    var value = "Test Value";
    var command = AddOrUpdateKeyCommand(keyField, pointInTimeId, value);

    processor.process(command);
    processor.undo();

    expect(keyField.keys.length, equals(0));
  });

  test("Undoing command should restore old value of updated key", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    var originalValue = "Original Value";
    keyField.addOrUpdateKeyAtTime(originalValue, pointInTimeId);
    var command = AddOrUpdateKeyCommand(keyField, pointInTimeId, "Test Value");

    processor.process(command);
    processor.undo();

    expect(keyField.keys[pointInTimeId], equals(originalValue));
  });

  test("Undoing and redoing command should add key again", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    var value = "Test Value";
    var command = AddOrUpdateKeyCommand(keyField, pointInTimeId, value);

    processor.process(command);
    processor.undo();
    processor.redo();

    expect(keyField.keys[pointInTimeId], equals(value));
  });

  test("Undoing and redoing command should update key again", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    keyField.addOrUpdateKeyAtTime("Original Value", pointInTimeId);
    var value = "Test Value";
    var command = AddOrUpdateKeyCommand(keyField, pointInTimeId, value);

    processor.process(command);
    processor.undo();
    processor.redo();

    expect(keyField.keys[pointInTimeId], equals(value));
    expect(keyField.keys.length, equals(1));
  });
}
