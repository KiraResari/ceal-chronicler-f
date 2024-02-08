import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_id.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository repository;
  late TimeBarController controller;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    getIt.registerSingleton<FileService>(FileServiceMockLite());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    controller = TimeBarController();
  });

  test("Point with incidents should not be deletable", () {
    PointInTime newPoint = repository.createNewAtIndex(0);

    newPoint.incidentReferences.add(IncidentId());

    expect(controller.canPointBeDeleted(newPoint), isFalse);
  });

  test("Point without incidents should be deletable", () {
    PointInTime newPoint = repository.createNewAtIndex(0);

    expect(controller.canPointBeDeleted(newPoint), isTrue);
  });

  test("Last point should not be deletable", () {
    PointInTime onlyPoint = repository.first;

    expect(controller.canPointBeDeleted(onlyPoint), isFalse);
  });
}