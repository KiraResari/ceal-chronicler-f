import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/commands/delete_location_connection_command.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection.dart';
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
    "Processing command should delete location connection",
    () {
      var connection = LocationConnection(
          LocationId(), LocationConnectionDirection.southwest, LocationId());
      repository.add(connection);
      var command = DeleteLocationConnectionCommand(connection);

      processor.process(command);

      expect(repository.content, isEmpty);
    },
  );

  test(
    "Undoing command should restore deleted location connection",
        () {
      var connection = LocationConnection(
          LocationId(), LocationConnectionDirection.southwest, LocationId());
      repository.add(connection);
      var command = DeleteLocationConnectionCommand(connection);

      processor.process(command);
      processor.undo();

      expect(repository.content, contains(connection));
    },
  );

  test(
    "Redoing command should re-delete location connection",
        () {
      var connection = LocationConnection(
          LocationId(), LocationConnectionDirection.southwest, LocationId());
      repository.add(connection);
      var command = DeleteLocationConnectionCommand(connection);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(repository.content, isEmpty);
    },
  );
}
