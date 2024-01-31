import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/commands/rename_incident_command.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late CommandProcessor processor;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<FileService>(FileServiceMockLite());
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
