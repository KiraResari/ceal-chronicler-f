import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/commands/update_location_level_command.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_level.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<LocationRepository>(LocationRepository());
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should update location level",
    () {
      Location location = Location(PointInTimeId());
      var command =
          UpdateLocationLevelCommand(location, LocationLevel.continent);

      processor.process(command);

      expect(location.locationLevel, equals(LocationLevel.continent));
    },
  );

  test(
    "Undoing command should revert location level",
        () {
      Location location = Location(PointInTimeId());
      var command =
      UpdateLocationLevelCommand(location, LocationLevel.continent);

      processor.process(command);
      processor.undo();

      expect(location.locationLevel, equals(LocationLevel.notSet));
    },
  );

  test(
    "Redoing command should re-set location level",
        () {
      Location location = Location(PointInTimeId());
      var command =
      UpdateLocationLevelCommand(location, LocationLevel.continent);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(location.locationLevel, equals(LocationLevel.continent));
    },
  );
}
