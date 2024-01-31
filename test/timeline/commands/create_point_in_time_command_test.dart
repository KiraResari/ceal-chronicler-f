import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/timeline/commands/create_point_in_time_command.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late CommandProcessor processor;
  late PointInTimeRepository repository;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    getIt.registerSingleton<FileService>(FileServiceMockLite());
    processor = CommandProcessor();
  });

  test(
    "Processing command should add new point in time",
    () {
      int initialPointsInTime = repository.pointsInTime.length;
      var command = CreatePointInTimeCommand(0);

      processor.process(command);

      expect(repository.pointsInTime.length, equals(initialPointsInTime + 1));
    },
  );

  test(
    "Undoing command should remove new point in time",
        () {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      PointInTime createdPoint = repository.first;
      processor.undo();

      expect(repository.pointsInTime, isNot(contains(createdPoint)));
    },
  );

  test(
    "Redoing command should re-add new point in time",
        () {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      PointInTime createdPoint = repository.first;
      processor.undo();
      processor.redo();

      expect(repository.pointsInTime, contains(createdPoint));
    },
  );
}
