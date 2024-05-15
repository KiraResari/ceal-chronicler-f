import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/commands/create_incident_command.dart';
import 'package:ceal_chronicler_f/incidents/commands/delete_incident_command.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late CommandProcessor processor;
  late IncidentRepository incidentRepository;
  late PointInTimeRepository pointInTimeRepository;
  late Incident firstIncident;
  late PointInTime relatedPoint;

  setUp(() {
    incidentRepository = IncidentRepository();
    pointInTimeRepository = PointInTimeRepository();
    getIt.reset();
    getIt.registerSingleton<IncidentRepository>(incidentRepository);
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<FileService>(FileServiceMockLite());
    processor = CommandProcessor();

    relatedPoint = pointInTimeRepository.first;

    CreateIncidentCommand(relatedPoint).execute();
    firstIncident = incidentRepository.content.first;
  });

  test(
    "Processing command should delete incident",
    () {
      var command = DeleteIncidentCommand(firstIncident);

      processor.process(command);

      expect(incidentRepository.content, isNot(contains(firstIncident)));
    },
  );

  test(
    "Processing command should remove incident reference from related point in time",
    () {
      var command = DeleteIncidentCommand(firstIncident);

      processor.process(command);

      expect(
          relatedPoint.incidentReferences, isNot(contains(firstIncident.id)));
    },
  );

  test(
    "Undoing command should restore incident",
    () {
      var command = DeleteIncidentCommand(firstIncident);

      processor.process(command);
      processor.undo();

      expect(incidentRepository.content, contains(firstIncident));
    },
  );

  test(
    "Undoing command should restore incident reference to related point in time",
    () {
      var command = DeleteIncidentCommand(firstIncident);

      processor.process(command);
      processor.undo();

      expect(relatedPoint.incidentReferences, contains(firstIncident.id));
    },
  );

  test(
    "Redoing command should re-delete incident",
    () {
      var command = DeleteIncidentCommand(firstIncident);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(incidentRepository.content, isNot(contains(firstIncident)));
    },
  );

  test(
    "Redoing command should re-remove incident reference from related point in time",
    () {
      var command = DeleteIncidentCommand(firstIncident);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(
          relatedPoint.incidentReferences, isNot(contains(firstIncident.id)));
    },
  );

  test(
    "After undo, incidents should still be in the same order",
    () {
      CreateIncidentCommand(relatedPoint).execute();

      var command = DeleteIncidentCommand(firstIncident);
      processor.process(command);
      processor.undo();

      expect(relatedPoint.incidentReferences.first, equals(firstIncident.id));
    },
  );
}
