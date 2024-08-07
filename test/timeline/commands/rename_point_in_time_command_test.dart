import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/commands/rename_point_in_time_command.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late PointInTimeRepository repository;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should rename point in time",
    () {
      PointInTime point = repository.createNewAtIndex(0);
      String newName = "New Point Name";
      var command = RenamePointInTimeCommand(point, newName);

      processor.process(command);

      expect(point.name, newName);
    },
  );

  test(
    "Undoing command should undo renaming",
        () {
      PointInTime point = repository.createNewAtIndex(0);
      String oldName = point.name;
      var command = RenamePointInTimeCommand(point, "New Point Name");

      processor.process(command);
      processor.undo();

      expect(point.name, oldName);
    },
  );

  test(
    "Redoing command should redo renaming",
        () {
      PointInTime point = repository.createNewAtIndex(0);
      String newName = "New Point Name";
      var command = RenamePointInTimeCommand(point, newName);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(point.name, newName);
    },
  );
}
