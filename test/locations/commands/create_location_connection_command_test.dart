import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/commands/create_location_connection_command.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_direction.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late LocationConnectionRepository repository;

  setUp(() {
    getIt.reset();
    repository = LocationConnectionRepository();
    getIt.registerSingleton<LocationConnectionRepository>(repository);
    getIt.registerSingleton<LocationRepository>(LocationRepository());
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should add new location connection",
    () {
      int initialIncidentCount = repository.content.length;
      var command = CreateLocationConnectionCommand(
          LocationId(), LocationConnectionDirection.southwest, LocationId());

      processor.process(command);

      expect(repository.content.length, equals(initialIncidentCount + 1));
    },
  );

  test(
    "Undoing command should remove new location connection",
        () {
      var command = CreateLocationConnectionCommand(
          LocationId(), LocationConnectionDirection.southwest, LocationId());

      processor.process(command);
      processor.undo();

      expect(repository.content, isEmpty);
    },
  );

  test(
    "Redoing command should add new location connection again",
        () {
      int initialIncidentCount = repository.content.length;
      var command = CreateLocationConnectionCommand(
          LocationId(), LocationConnectionDirection.southwest, LocationId());

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(repository.content.length, equals(initialIncidentCount + 1));
    },
  );
}
