import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/commands/move_incident_down_command.dart';
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
    "Processing command should shift incident down",
    () {
      PointInTime point = PointInTime("Test");
      Incident firstIncident = Incident();
      Incident secondIncident = Incident();
      point.incidentReferences = [firstIncident.id, secondIncident.id];
      var command = MoveIncidentDownCommand(firstIncident, point);

      processor.process(command);

      expect(point.incidentReferences.last, equals(firstIncident.id));
    },
  );

  test(
    "Undoing command should shift back up again",
    () {
      PointInTime point = PointInTime("Test");
      Incident firstIncident = Incident();
      Incident secondIncident = Incident();
      point.incidentReferences = [firstIncident.id, secondIncident.id];
      var command = MoveIncidentDownCommand(firstIncident, point);

      processor.process(command);
      processor.undo();

      expect(point.incidentReferences.last, equals(secondIncident.id));
    },
  );

  test(
    "Redoing command should shift incident down",
    () {
      PointInTime point = PointInTime("Test");
      Incident firstIncident = Incident();
      Incident secondIncident = Incident();
      point.incidentReferences = [firstIncident.id, secondIncident.id];
      var command = MoveIncidentDownCommand(firstIncident, point);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(point.incidentReferences.last, equals(firstIncident.id));
    },
  );
}
