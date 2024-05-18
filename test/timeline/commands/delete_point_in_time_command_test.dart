import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/commands/delete_point_in_time_command.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor commandProcessor;
  late PointInTimeRepository repository;
  late PointInTime newPoint;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    commandProcessor = CommandProcessor();
    newPoint = repository.createNewAtIndex(0);
  });

  test(
    "Processing command should delete point in time",
    () {
      var command = DeletePointInTimeCommand(newPoint);

      commandProcessor.process(command);

      List<PointInTime> pointsInRepository = repository.pointsInTime;
      expect(pointsInRepository, isNot(contains(newPoint)));
    },
  );

  test(
    "Undoing command should restore point in time",
    () {
      var command = DeletePointInTimeCommand(newPoint);

      commandProcessor.process(command);
      commandProcessor.undo();

      List<PointInTime> pointsInRepository = repository.pointsInTime;
      expect(pointsInRepository, contains(newPoint));
    },
  );

  test(
    "Redoing command should re-delete point in time",
    () {
      var command = DeletePointInTimeCommand(newPoint);

      commandProcessor.process(command);
      commandProcessor.undo();
      commandProcessor.redo();

      List<PointInTime> pointsInRepository = repository.pointsInTime;
      expect(pointsInRepository, isNot(contains(newPoint)));
    },
  );

  test(
    "Deleting active point in time should make other point in time active",
    () {
      PointInTime activePoint = repository.activePointInTime;
      var command = DeletePointInTimeCommand(activePoint);

      commandProcessor.process(command);

      PointInTime newActivePoint = repository.activePointInTime;
      expect(newActivePoint, equals(newPoint));
    },
  );

  test(
    "Undoing deletion of active point in time should make that point in time active again",
    () {
      PointInTime activePoint = repository.activePointInTime;
      var command = DeletePointInTimeCommand(activePoint);

      commandProcessor.process(command);
      commandProcessor.undo();

      PointInTime newActivePoint = repository.activePointInTime;
      expect(newActivePoint, equals(activePoint));
    },
  );

  test(
    "Redoing deletion of active point in time should make other point in time active again",
    () {
      PointInTime activePoint = repository.activePointInTime;
      var command = DeletePointInTimeCommand(activePoint);

      commandProcessor.process(command);
      commandProcessor.undo();
      commandProcessor.redo();

      PointInTime newActivePoint = repository.activePointInTime;
      expect(newActivePoint, equals(newPoint));
    },
  );

  test(
    "By default, next point should become active if active point is deleted",
    () {
      repository.createNewAtIndex(0);
      PointInTime secondPoint = repository.pointsInTime[1];
      PointInTime thirdPoint = repository.pointsInTime[2];
      repository.activePointInTime = secondPoint;
      var command = DeletePointInTimeCommand(secondPoint);

      commandProcessor.process(command);

      PointInTime newActivePoint = repository.activePointInTime;
      expect(newActivePoint, equals(thirdPoint));
    },
  );

  test(
    "If last point is deleted and active, previous point should become active",
    () {
      PointInTime firstPoint = repository.pointsInTime[0];
      PointInTime secondPoint = repository.pointsInTime[1];
      repository.activePointInTime = secondPoint;
      var command = DeletePointInTimeCommand(secondPoint);

      commandProcessor.process(command);

      PointInTime newActivePoint = repository.activePointInTime;
      expect(newActivePoint, equals(firstPoint));
    },
  );
}
