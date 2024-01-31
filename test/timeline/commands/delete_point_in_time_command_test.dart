import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/timeline/commands/delete_point_in_time_command.dart';
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
    "Processing command should delete point in time",
    () {
      PointInTime pointToDelete = repository.createNewAtIndex(0);
      var command = DeletePointInTimeCommand(pointToDelete);

      processor.process(command);

      List<PointInTime> pointsInRepository = repository.pointsInTime;
      expect(pointsInRepository, isNot(contains(pointToDelete)));
    },
  );

  test(
    "Undoing command should restore point in time",
        () {
      PointInTime pointToDelete = repository.createNewAtIndex(0);
      var command = DeletePointInTimeCommand(pointToDelete);

      processor.process(command);
      processor.undo();

      List<PointInTime> pointsInRepository = repository.pointsInTime;
      expect(pointsInRepository, contains(pointToDelete));
    },
  );

  test(
    "Redoing command should re-delete point in time",
        () {
      PointInTime pointToDelete = repository.createNewAtIndex(0);
      var command = DeletePointInTimeCommand(pointToDelete);

      processor.process(command);
      processor.undo();
      processor.redo();

      List<PointInTime> pointsInRepository = repository.pointsInTime;
      expect(pointsInRepository, isNot(contains(pointToDelete)));
    },
  );
}
