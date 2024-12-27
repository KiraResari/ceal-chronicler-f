import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/commands/delete_parent_location_command.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late LocationRepository repository;

  setUp(() {
    getIt.reset();
    repository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(repository);
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should delete parent location",
    () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      firstLocation.parentLocation = secondLocation.id;
      var command = DeleteParentLocationCommand(firstLocation);

      processor.process(command);

      expect(firstLocation.parentLocation, isNull);
    },
  );

  test(
    "Undoing command should restore parent location",
        () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      firstLocation.parentLocation = secondLocation.id;
      var command = DeleteParentLocationCommand(firstLocation);

      processor.process(command);
      processor.undo();

      expect(firstLocation.parentLocation, equals(secondLocation.id));
    },
  );

  test(
    "Redoing command should re-delete parent location",
        () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      firstLocation.parentLocation = secondLocation.id;
      var command = DeleteParentLocationCommand(firstLocation);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(firstLocation.parentLocation, isNull);
    },
  );
}
