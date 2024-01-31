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
  late Incident incidentToDelete;
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
    var createIncidentCommand = CreateIncidentCommand(relatedPoint);
    createIncidentCommand.execute();
    incidentToDelete = incidentRepository.incidents.first;
  });

  test(
    "Processing command should delete incident",
    () {
      var command = DeleteIncidentCommand(incidentToDelete);

      processor.process(command);

      expect(incidentRepository.incidents, isNot(contains(incidentToDelete)));
    },
  );

  test(
    "Processing command should remove incident reference from related point in time",
    () {
      var command = DeleteIncidentCommand(incidentToDelete);

      processor.process(command);

      expect(relatedPoint.incidentReferences,
          isNot(contains(incidentToDelete.id)));
    },
  );

  test(
    "Undoing command should restore incident",
    () {
      var command = DeleteIncidentCommand(incidentToDelete);

      processor.process(command);
      processor.undo();

      expect(incidentRepository.incidents, contains(incidentToDelete));
    },
  );

  test(
    "Undoing command should restore incident reference to related point in time",
    () {
      var command = DeleteIncidentCommand(incidentToDelete);

      processor.process(command);
      processor.undo();

      expect(relatedPoint.incidentReferences, contains(incidentToDelete.id));
    },
  );

  test(
    "Redoing command should re-delete incident",
    () {
      var command = DeleteIncidentCommand(incidentToDelete);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(incidentRepository.incidents, isNot(contains(incidentToDelete)));
    },
  );

  test(
    "Redoing command should re-remove incident reference from related point in time",
    () {
      var command = DeleteIncidentCommand(incidentToDelete);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(relatedPoint.incidentReferences,
          isNot(contains(incidentToDelete.id)));
    },
  );
}
