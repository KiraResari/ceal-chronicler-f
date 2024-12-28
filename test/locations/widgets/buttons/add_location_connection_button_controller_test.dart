import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_direction.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/locations/model/location_level.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/widgets/buttons/add_location_connection_button_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter/src/material/dropdown_menu.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../location_test_utils.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;
  late LocationConnectionRepository locationConnectionRepository;
  late LocationTestUtils utils;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    locationRepository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    locationConnectionRepository = LocationConnectionRepository();
    getIt.registerSingleton<LocationConnectionRepository>(
        locationConnectionRepository);
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    utils = LocationTestUtils();
  });

  test(
    "validMenuEntries should return valid location",
    () {
      Location thisLocation = utils.createLocationAndAddToRepository();
      Location anotherLocation = utils.createLocationAndAddToRepository();
      var controller = AddLocationConnectionButtonController(
          thisLocation, LocationConnectionDirection.east);

      List<DropdownMenuEntry<LocationId>> validEntries =
          controller.validMenuEntries;

      expect(
        validEntries.map((entry) => entry.value).toList(),
        contains(anotherLocation.id),
      );
    },
  );

  test(
    "validMenuEntries should not return present location",
        () {
      Location thisLocation = utils.createLocationAndAddToRepository();
      var controller = AddLocationConnectionButtonController(
          thisLocation, LocationConnectionDirection.east);

      List<DropdownMenuEntry<LocationId>> validEntries =
          controller.validMenuEntries;

      expect(validEntries, isEmpty);
    },
  );

  test(
    "validMenuEntries should not return location of different level",
    () {
      Location thisLocation = utils.createLocationAndAddToRepository(
          locationLevel: LocationLevel.district);
      utils.createLocationAndAddToRepository(
          locationLevel: LocationLevel.continent);
      var controller = AddLocationConnectionButtonController(
          thisLocation, LocationConnectionDirection.east);

      List<DropdownMenuEntry<LocationId>> validEntries =
          controller.validMenuEntries;

      expect(validEntries, isEmpty);
    },
  );
}
