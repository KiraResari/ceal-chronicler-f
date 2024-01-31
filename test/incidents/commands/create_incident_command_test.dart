import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/commands/create_incident_command.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late CommandProcessor processor;
  late IncidentRepository repository;

  setUp(() {
    getIt.reset();
    repository = IncidentRepository();
    getIt.registerSingleton<IncidentRepository>(repository);
    getIt.registerSingleton<FileService>(FileServiceMockLite());
    processor = CommandProcessor();
  });

  test(
    "Processing command should add new incident",
    () {
      int initialIncidentCount = repository.incidents.length;
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);

      expect(repository.incidents.length, equals(initialIncidentCount + 1));
    },
  );

  test(
    "Processing command should add incident reference to related point in time",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);

      Incident createdIncident = repository.incidents.first;
      expect(point.incidentReferences, contains(createdIncident.id));
    },
  );

  test(
    "Undoing command should remove new incident",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);
      Incident createdIncident = repository.incidents.first;
      processor.undo();

      expect(repository.incidents, isNot(contains(createdIncident)));
    },
  );

  test(
    "Undoing command should remove incident reference from related point",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);
      Incident createdIncident = repository.incidents.first;
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
      Incident createdIncident = repository.incidents.first;
      processor.undo();
      processor.redo();

      expect(repository.incidents, contains(createdIncident));
    },
  );

  test(
    "Redoing command should re-add incident reference to related point",
    () {
      PointInTime point = PointInTime("Test");
      var command = CreateIncidentCommand(point);

      processor.process(command);
      Incident createdIncident = repository.incidents.first;
      processor.undo();
      processor.redo();

      expect(point.incidentReferences, contains(createdIncident.id));
    },
  );
}
