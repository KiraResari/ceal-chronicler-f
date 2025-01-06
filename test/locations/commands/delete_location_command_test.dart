import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/commands/delete_location_command.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late KeyFieldResolver resolver;
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    resolver = KeyFieldResolver();
    getIt.registerSingleton<KeyFieldResolver>(resolver);
    locationRepository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    processor = CommandProcessor();
  });

  test(
    "Processing command should delete location",
    () {
      var location = Location(PointInTimeId());
      locationRepository.add(location);
      var command = DeleteLocationCommand(location);

      processor.process(command);

      expect(locationRepository.content, isNot(contains(location)));
    },
  );

  test(
    "Undoing command should restore deleted location",
    () {
      var location = Location(PointInTimeId());
      locationRepository.add(location);
      var command = DeleteLocationCommand(location);

      processor.process(command);
      processor.undo();

      expect(locationRepository.content, contains(location));
    },
  );

  test(
    "Undoing command should restore deleted location with correct name",
    () {
      var loaction = Location(PointInTimeId());
      loaction.name.addOrUpdateKeyAtTime(
          "Vaught", pointInTimeRepository.activePointInTime.id);
      locationRepository.add(loaction);
      var command = DeleteLocationCommand(loaction);

      processor.process(command);
      processor.undo();

      var currentValue =
          resolver.getCurrentValue(locationRepository.content[0].name);
      expect(currentValue, equals("Vaught"));
    },
  );

  test(
    "Redoing command should re-delete location",
    () {
      var location = Location(PointInTimeId());
      locationRepository.add(location);
      var command = DeleteLocationCommand(location);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(locationRepository.content, isNot(contains(location)));
    },
  );
}
