import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/commands/rename_incident_command.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should rename incident",
    () {
      var incident = Incident();
      String newName = "Renamed Incident";
      var command = RenameIncidentCommand(incident, newName);

      processor.process(command);

      expect(incident.name, newName);
    },
  );

  test(
    "Undoing command should undo renaming",
    () {
      var incident = Incident();
      String oldName = incident.name;
      var command = RenameIncidentCommand(incident, "Renamed Incident");

      processor.process(command);
      processor.undo();

      expect(incident.name, oldName);
    },
  );

  test(
    "Redoing command should redo renaming",
    () {
      var incident = Incident();
      String newName = "Renamed Incident";
      var command = RenameIncidentCommand(incident, newName);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(incident.name, newName);
    },
  );
}
