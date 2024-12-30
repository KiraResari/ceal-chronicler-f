import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/commands/delete_key_command.dart';
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

  test("Processing command should delete key", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    keyField.addOrUpdateKeyAtTime("New Test", pointInTimeId);
    var command = DeleteKeyCommand(keyField, pointInTimeId);

    processor.process(command);

    expect(keyField.keys.length, equals(0));
  });

  test("Undoing command should restore deleted key", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    String newValue = "New Test";
    keyField.addOrUpdateKeyAtTime(newValue, pointInTimeId);
    var command = DeleteKeyCommand(keyField, pointInTimeId);

    processor.process(command);
    processor.undo();

    expect(keyField.keys[pointInTimeId], equals(newValue));
  });

  test("Redoing command should delete key again", () {
    var keyField = StringKeyField("Test");
    var pointInTimeId = PointInTimeId();
    keyField.addOrUpdateKeyAtTime("New Test", pointInTimeId);
    var command = DeleteKeyCommand(keyField, pointInTimeId);

    processor.process(command);
    processor.undo();
    processor.redo();

    expect(keyField.keys.length, equals(0));
  });
}
