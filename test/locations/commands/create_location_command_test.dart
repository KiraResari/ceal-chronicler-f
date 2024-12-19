import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/commands/create_location_command.dart';
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
    "Processing command should add new location",
    () {
      int initialIncidentCount = repository.content.length;
      var command = CreateLocationCommand(PointInTimeId());

      processor.process(command);

      expect(repository.content.length, equals(initialIncidentCount + 1));
    },
  );

  test(
    "Undoing command should remove new location",
    () {
      var command = CreateLocationCommand(PointInTimeId());

      processor.process(command);
      Location createdLocation = repository.content.first;
      processor.undo();

      expect(repository.content, isNot(contains(createdLocation)));
    },
  );

  test(
    "Redoing command should re-add new location",
    () {
      var command = CreateLocationCommand(PointInTimeId());

      processor.process(command);
      Location createdLocation = repository.content.first;
      processor.undo();
      processor.redo();

      expect(repository.content, contains(createdLocation));
    },
  );
}
