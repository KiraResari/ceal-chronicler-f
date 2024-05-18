import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/commands/create_incident_command.dart';
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
    "Processing command should add new incident",
    () {
      int initialIncidentCount = repository.content.length;
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);

      expect(repository.content.length, equals(initialIncidentCount + 1));
    },
  );

  test(
    "Processing command should add incident reference to related point in time",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);

      Incident createdIncident = repository.content.first;
      expect(point.incidentReferences, contains(createdIncident.id));
    },
  );

  test(
    "Undoing command should remove new incident",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);
      Incident createdIncident = repository.content.first;
      processor.undo();

      expect(repository.content, isNot(contains(createdIncident)));
    },
  );

  test(
    "Undoing command should remove incident reference from related point",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);
      Incident createdIncident = repository.content.first;
      processor.undo();

      expect(point.incidentReferences, isNot(contains(createdIncident.id)));
    },
  );

  test(
    "Redoing command should re-add new incident",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);
      Incident createdIncident = repository.content.first;
      processor.undo();
      processor.redo();

      expect(repository.content, contains(createdIncident));
    },
  );

  test(
    "Redoing command should re-add incident reference to related point",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);
      Incident createdIncident = repository.content.first;
      processor.undo();
      processor.redo();

      expect(point.incidentReferences, contains(createdIncident.id));
    },
  );
}
