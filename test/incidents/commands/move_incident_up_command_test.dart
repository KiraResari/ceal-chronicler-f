import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/commands/move_incident_up_command.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late IncidentRepository repository;

  setUp(() {
    getIt.reset();
    repository = IncidentRepository();
    getIt.registerSingleton<IncidentRepository>(repository);
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should shift incident up",
    () {
      PointInTime point = PointInTime("Test");
      Incident firstIncident = Incident();
      Incident secondIncident = Incident();
      point.incidentReferences = [firstIncident.id, secondIncident.id];
      var command = MoveIncidentUpCommand(secondIncident, point);

      processor.process(command);

      expect(point.incidentReferences.first, equals(secondIncident.id));
    },
  );

  test(
    "Undoing command should shift back down again",
    () {
      PointInTime point = PointInTime("Test");
      Incident firstIncident = Incident();
      Incident secondIncident = Incident();
      point.incidentReferences = [firstIncident.id, secondIncident.id];
      var command = MoveIncidentUpCommand(secondIncident, point);

      processor.process(command);
      processor.undo();

      expect(point.incidentReferences.first, equals(firstIncident.id));
    },
  );

  test(
    "Redoing command should shift incident up",
    () {
      PointInTime point = PointInTime("Test");
      Incident firstIncident = Incident();
      Incident secondIncident = Incident();
      point.incidentReferences = [firstIncident.id, secondIncident.id];
      var command = MoveIncidentUpCommand(secondIncident, point);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(point.incidentReferences.first, equals(secondIncident.id));
    },
  );
}
