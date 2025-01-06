import 'package:ceal_chronicler_f/attributes/commands/edit_attribute_name_command.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/attributes/model/attribute.dart';
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
    "Processing command should edit attribute name",
    () {
      var attribute = Attribute();
      var command = EditAttributeNameCommand(attribute, "New value");

      processor.process(command);

      expect(attribute.name, equals("New value"));
    },
  );

  test(
    "Undoing command should restore old attribute name",
        () {
      var attribute = Attribute();
      String oldName = attribute.name;
      var command = EditAttributeNameCommand(attribute, "New value");

      processor.process(command);
      processor.undo();

      expect(attribute.name, equals(oldName));
    },
  );

  test(
    "Redoing command should set new attribute name again",
        () {
      var attribute = Attribute();
      var command = EditAttributeNameCommand(attribute, "New value");

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(attribute.name, equals("New value"));
    },
  );
}
