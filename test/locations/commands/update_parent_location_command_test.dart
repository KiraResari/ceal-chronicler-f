import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/commands/update_parent_location_command.dart';
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
    "Processing command should update parent location",
    () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      var command =
          UpdateParentLocationCommand(firstLocation, secondLocation.id);

      processor.process(command);

      expect(firstLocation.parentLocation, equals(secondLocation.id));
    },
  );

  test(
    "Processing command should be able to remove parent location",
    () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      firstLocation.parentLocation = secondLocation.id;
      var command = UpdateParentLocationCommand(firstLocation, null);

      processor.process(command);

      expect(firstLocation.parentLocation, isNull);
    },
  );

  test(
    "Undoing command should remove parent location if none was present before",
    () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      var command =
          UpdateParentLocationCommand(firstLocation, secondLocation.id);

      processor.process(command);
      processor.undo();

      expect(firstLocation.parentLocation, isNull);
    },
  );

  test(
    "Undoing command should change parent location back to previous value if one was present before",
    () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      Location thirdLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      repository.add(thirdLocation);
      firstLocation.parentLocation = secondLocation.id;
      var command =
          UpdateParentLocationCommand(firstLocation, thirdLocation.id);

      processor.process(command);
      processor.undo();

      expect(firstLocation.parentLocation, equals(secondLocation.id));
    },
  );

  test(
    "Redoing command should re-update parent location",
        () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      var command =
      UpdateParentLocationCommand(firstLocation, secondLocation.id);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(firstLocation.parentLocation, equals(secondLocation.id));
    },
  );

  test(
    "Redoing command should re-remove parent location",
        () {
      Location firstLocation = Location(PointInTimeId());
      Location secondLocation = Location(PointInTimeId());
      repository.add(firstLocation);
      repository.add(secondLocation);
      firstLocation.parentLocation = secondLocation.id;
      var command = UpdateParentLocationCommand(firstLocation, null);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(firstLocation.parentLocation, isNull);
    },
  );
}
