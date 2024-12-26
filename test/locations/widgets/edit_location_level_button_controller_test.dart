import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_level.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/widgets/edit_location_level_button_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter/src/material/dropdown_menu.dart';
import 'package:flutter_test/flutter_test.dart';

import '../location_test_utils.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;
  late LocationTestUtils utils;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    locationRepository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    utils = LocationTestUtils();
  });

  test(
    "validEntries should return valid location levels",
    () {
      Location thisLocation = utils.createLocationAndAddToRepository(
          locationLevel: LocationLevel.notSet);
      var controller = EditLocationLevelButtonController(thisLocation);

      List<DropdownMenuEntry<LocationLevel>> validEntries =
          controller.validEntries;

      expect(
        validEntries.map((entry) => entry.value).toList(),
        containsAll(LocationLevel.values),
      );
    },
  );

  test(
    "validEntries should only return location levels higher than those of children",
    () {
      Location thisLocation = utils.createLocationAndAddToRepository(
          locationLevel: LocationLevel.universe);
      Location childLocation = utils.createLocationAndAddToRepository(
          locationLevel: LocationLevel.continent);
      childLocation.parentLocation = thisLocation.id;
      var controller = EditLocationLevelButtonController(thisLocation);

      List<DropdownMenuEntry<LocationLevel>> validEntries =
          controller.validEntries;

      expect(
        validEntries.map((entry) => entry.value).toList(),
        unorderedEquals([
          LocationLevel.minayero,
          LocationLevel.universe,
          LocationLevel.world,
          LocationLevel.notSet,
        ]),
      );
    },
  );
}
