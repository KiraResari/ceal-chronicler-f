import 'package:ceal_chronicler_f/attributes/commands/edit_temporal_attribute_label_command.dart';
import 'package:ceal_chronicler_f/attributes/model/temporal_attribute.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
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
    "Processing command should edit temporal attribute label",
    () {
      var attribute = TemporalAttribute();
      var command = EditTemporalAttributeLabelCommand(attribute, "New value");

      processor.process(command);

      expect(attribute.label, equals("New value"));
    },
  );

  test(
    "Undoing command should restore old temporal attribute label",
        () {
      var attribute = TemporalAttribute();
      String oldName = attribute.label;
      var command = EditTemporalAttributeLabelCommand(attribute, "New value");

      processor.process(command);
      processor.undo();

      expect(attribute.label, equals(oldName));
    },
  );

  test(
    "Redoing command should set new temporal attribute label again",
        () {
      var attribute = TemporalAttribute();
      var command = EditTemporalAttributeLabelCommand(attribute, "New value");

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(attribute.label, equals("New value"));
    },
  );
}
